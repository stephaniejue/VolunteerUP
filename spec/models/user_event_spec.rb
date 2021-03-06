require 'rails_helper'
require 'date'
RSpec.describe UserEvent, type: :model do

  before(:each) do
    @start = DateTime.now
    @end = DateTime.now + (2 / 24.0)
    @pw = "123456"
    @u1 = User.find_by_email("a@yahoo.com")
    @u2 = User.find_by_email("b@yahoo.com")
    @e1 = Event.create(name: "Blood Donation", description: "Give Blood",
      cause: "Animals", start_time: @start, end_time: @end,
      street: "704 J St", city: "San Diego", state: "CA", postal_code: "92101",
      country: "USA", volunteers_needed: 100)
    @e2 = Event.create(name: "Mercury Donation", description: "Give Mercury",
      cause: "Animals", start_time: @start, end_time: @end,
      street: "704 J St", city: "San Diego", state: "CA", postal_code: "92101",
      country: "USA", volunteers_needed: 10)
    @org = Organization.create(name: "People of Earth", description: "A non-profit",
      phone: "555-555-5555", email: "peopleofearth@yahoo.com",
      website: "www.peopleofearth.com")
    @e1.organization = @org
    @e2.organization = @org
    @start_length = @u1.events.length #something is strange about this test, may need to add 2 at the bottom check
  end

  describe "User" do
    it "can have many events" do
      expect(@u1.user_events.new(event: @e1).save).to eq true
      expect(@u1.user_events.new(event: @e2).save).to eq true
      expect(@u1.events.length).to eq @start_length
    end
  end

  describe "Event" do
    it "can have many users" do
      expect(@e1.user_events.new(user: @u1).save).to eq true
      expect(@e1.user_events.new(user: @u2).save).to eq true
      expect(@e1.users.length).to eq 2
    end
  end
end
