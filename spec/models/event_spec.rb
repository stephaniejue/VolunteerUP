require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "Event" do
    it "has to be real" do
      expect{Event.new}.to_not raise_error
    end
    it "has a name" do
      new_event = Event.new
      new_event.name = "ABC"
      expect(new_event.name).to eq "ABC"
    end
    it "has a description" do
      new_event = Event.new
      new_event.description = "a non profit org"
      expect(new_event.description).to eq "a non profit org"
    end
    it "has a cause" do
      new_event = Event.new
      new_event.cause = "Animals"
      expect(new_event.cause).to eq "Animals"
    end
    it "has a start time" do
      new_event = Event.new
      new_event.start_time = DateTime.new(2017,1,18,1,30)
      expect(new_event.start_time.year).to eq 2017
      expect(new_event.start_time.month).to eq 1
      expect(new_event.start_time.day).to eq 18
      expect(new_event.start_time.hour).to eq 1
      expect(new_event.start_time.min).to eq 30
    end
    it "has a end time" do
      new_event = Event.new
      new_event.end_time = DateTime.new(2017,1,18,5,30)
      expect(new_event.end_time.year).to eq 2017
      expect(new_event.end_time.month).to eq 1
      expect(new_event.end_time.day).to eq 18
      expect(new_event.end_time.hour).to eq 5
      expect(new_event.end_time.min).to eq 30
    end
    it "has an organization" do
      new_event = Event.new(name: "ABC", cause: "Animals", start_time: DateTime.new(2017,1,18,1,30), end_time: DateTime.new(2017,1,18,5,30), volunteers_needed: 100)
      new_org = Organization.new(name: "The Red Cross", description: "A non-profit organization")
      new_org.save
      new_event.organization = new_org
      expect(new_event.organization.name).to eq "The Red Cross"
      expect(new_event.organization.description).to eq "A non-profit organization"
    end
    it "has a number of volunteers needed" do
      new_event = Event.new
      new_event.volunteers_needed = 100
      expect(new_event.volunteers_needed).to eq 100
    end
    it "should save" do
      new_event = Event.new(name: "ABC", description: "Helping the animals", cause: "Animals", start_time: DateTime.new(2017,1,18,1,30), end_time: DateTime.new(2017,1,18,5,30), volunteers_needed: 100)
      new_org = Organization.new(name: "The Red Cross", description: "A non-profit organization")
      new_org.save
      new_event.organization = new_org
      expect{new_event.save}.to_not raise_error
      @event = Event.find_by_name("ABC")
      expect(new_event.description).to eq @event.description
      expect(new_event.cause).to eq @event.cause
      expect(new_event.start_time).to eq @event.start_time
      expect(new_event.end_time).to eq @event.end_time
      expect(new_event.organization.name).to eq @event.organization.name
    end
  end
end
