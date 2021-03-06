class Event < ApplicationRecord
  # after_initialize :create_waitlist
  before_save :set_cause

  #if an event is destroyed, this destroys the link between event and user, but not the actual user
  has_many :user_events, :dependent => :destroy
  has_many :users, through: :user_events

  belongs_to :organization

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :volunteers_needed, presence: true
  validates :organization, presence:true

  geocoded_by :address
  after_validation :geocode

  def address
    "#{street}, #{city} #{state} #{postal_code}"
  end

  def remaining_vol
    volunteers_needed - self.users.count
  end

  def set_cause
    self.cause = "Other" if self.cause.nil?
  end


  filterrific(
    default_filter_params: { sorted_by: 'event_name_asc' },
    available_filters: [
      :sorted_by,
      :search_query,
    #   :with_start_time,
    #   :with_end_time
    #  :with_distance
    ]
  )

  scope :search_query, lambda { |query|
    return nil if query.blank?
    # condition query, parse into individual keywords from a string
    terms = query.to_s.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    num_of_conds = 3
    where(
      terms.map { |term|
        "(LOWER(events.name) LIKE ? OR LOWER(events.cause) LIKE ? OR LOWER(organizations.name) LIKE ?)"
      }.join(' AND '),
      *terms.map { |e| [e] * num_of_conds }.flatten
    ).joins(:organization)
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    # when /^event_created_at_/
      # Simple sort on the event created_at column.
      # Make sure to include the table name to avoid ambiguous column names.
      # Joining on other tables is quite common in Filterrific, and almost
      # every ActiveRecord table has a 'created_at' column.
      # order("(events.created_at) #{ direction }")
    when /^event_name_/
      # Simple sort on the event name columns
      order("LOWER(events.name) #{ direction }")
    when /^organization_name_/
      # Simple sort on the organization name columns
      order("LOWER(organizations.name) #{ direction }").joins(:organization)
    when /^event_start_time_/
      # Simple sort on the event date column
      order("(events.start_time)")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  # scope :with_start_time, lambda { |reference_time|
  #   where('events.start_time >= ?', reference_time)
  # }
  #
  # # always exclude the upper boundary for semi open intervals
  # scope :with_end_time, lambda { |reference_time|
  #   where('events.end_time <= ?', reference_time)
  # }

  scope :with_distance, lambda { |reference_dist|
    # x = reference_dist["city"]
    # y = reference_dist["max_distance"]
    Event.near(reference_dist["zip"].to_s, reference_dist["max_distance"].to_i)
  }

  def self.options_for_sorted_by
    [
      ['Event Name (Ascending)', 'event_name_asc'],
      ['Event Name (Descending)', 'event_name_desc'],
      ['Organization (Ascending)', 'organization_name_asc' ],
      ['Organization (Descending)', 'organization_name_desc' ],
      ['Date', 'event_start_time_desc']
    ]
  end

  resourcify
end
