require 'rails_helper'

describe 'KilledByPoliceImporter' do
  describe '#import' do
    it 'imports the data correctly' do
      file = File.new('spec/fixtures/killed_by_police_data.xlsx')
      KilledByPoliceImporter.import file
      expect(Incident.all.count).to eq 11

      first_incident = Incident.where(:victim_name => 'Kobvey Igbuhay').first
      expect(first_incident.victim_age).to eq 18
      expect(first_incident.victim_gender).to eq 'Male'
      expect(first_incident.victim_race).to eq 'Unknown Race'
      expect(first_incident.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150979.jpg'
      expect(first_incident.incident_state).to eq 'FL'
      expect(first_incident.incident_date).to eq Date.parse("26/10/2015")
      expect(first_incident.news_url).to eq 'http://www.tampabay.com/news/publicsafety/crime/one-suspect-shot-two-in-custody-and-tampa-police-hunting-for-a-fourth/2251265'
      expect(first_incident.latitude).to eq 40.714353
      expect(first_incident.longitude).to eq -74.005973

      # missing both name and age
      # also missing race
      second_incident = Incident.where(:incident_date => Date.parse("30/10/2015")).first
      expect(second_incident.victim_name).to eq nil
      expect(second_incident.victim_age).to eq nil
      expect(second_incident.victim_image_url).to eq nil
      expect(second_incident.victim_race).to eq 'Unknown Race'

      # missing name but not age
      third_incident = Incident.where(:incident_date => Date.parse("21/10/2015")).first
      expect(third_incident.victim_name).to eq nil
      expect(third_incident.victim_age).to eq 36
      expect(third_incident.victim_image_url).to eq nil

      # female
      fourth_incident = Incident.where(:incident_date => Date.parse("14/10/2015")).first
      expect(fourth_incident.victim_gender).to eq 'Female'
      expect(fourth_incident.victim_race).to eq 'White'
      expect(fourth_incident.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150924.jpg'

      #  black, male
      fifth_incident = Incident.where(:victim_name => 'Kaleb Alexander').first
      expect(fifth_incident.victim_gender).to eq 'Male'
      expect(fifth_incident.victim_race).to eq 'Black'

      # age, no name
      sixth_incident = Incident.where(:incident_date => Date.parse("4/10/2015")).first
      # the input is a string '40s'. This gets converted to a number, 40 which seems like reasonable behavior.
      expect(sixth_incident.victim_age).to eq 40
      expect(sixth_incident.victim_name).to eq nil

      # asian
      seventh_incident = Incident.where(:victim_name => 'Kevin Lau').first
      expect(seventh_incident.victim_race).to eq 'Asian'

      # two incidents jammed into one row
      # eighth_incident = Incident.where(:incident_date => Date.parse("6/9/2015")).first
      # expect(eighth_incident.victim_name).to eq "Angelo Delano Perry"

      # multiple news URLs with plaintext
      ninth_incident = Incident.where(:victim_name => 'Gilbert Flores').first
      expect(ninth_incident.victim_race).to eq 'Hispanic'
      # we drop all but the first URL
      expect(ninth_incident.news_url).to eq 'http://www.kens5.com/story/news/crime/2015/08/28/assault-suspect-killed-officer-involved-shooting-far-nw-bexar-co/71328772/'

      # native american
      tenth_incident = Incident.where(:victim_name => 'Kenneth Arnold Buck').first
      expect(tenth_incident.victim_race).to eq 'Native American'

      # extra line in date field
      eleventh_incident = Incident.where(:victim_name => 'Garrett Gagne').first
      expect(eleventh_incident.incident_date).to eq Date.parse("1/1/2015")


    end
  end

end