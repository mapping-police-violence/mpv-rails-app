require 'rails_helper'
include GeocodingHelpers

describe 'FatalEncountersImporter' do
  describe '#import' do
    before do
      stub_geocoding_request('18th Street and Collins Avenue, Miami Beach, FL, 33139', 37.79951, -122.274911)
    end

    it 'imports CSV data correctly' do
      test_file_import('spec/fixtures/fatal_encounters_data.csv')
    end

    it 'imports XLSX data correctly' do
      test_file_import('spec/fixtures/fatal_encounters_data.xlsx')
    end

    def test_file_import(path)
      UniqueMpvSeq.create(:last_value => 5)

      file = File.new(path)
      FatalEncountersImporter.import file
      expect(Incident.all.count).to eq 7

      first_incident = Incident.where(:victim_name => 'Raymond Herisse').first
      expect(first_incident.victim_age).to eq 22
      expect(first_incident.victim_gender).to eq 'Male'
      expect(first_incident.victim_race).to eq 'Black'
      expect(first_incident.victim_image_url).to eq 'http://graphics8.nytimes.com/images/2013/08/04/us/MIAMI/MIAMI-popup.jpg'
      expect(first_incident.incident_date).to eq Date.parse('30/5/2011')
      expect(first_incident.incident_street_address).to eq '18th Street and Collins Avenue'
      expect(first_incident.incident_city).to eq 'Miami Beach'
      expect(first_incident.incident_state).to eq 'FL'
      expect(first_incident.incident_zip).to eq '33139'
      expect(first_incident.incident_county).to eq 'Miami-Dade'
      expect(first_incident.agency_responsible).to eq 'Miami Beach Police Department'
      expect(first_incident.cause_of_death).to eq 'Gunshot'
      expect(first_incident.alleged_victim_crime).to eq nil
      expect(first_incident.crime_category).to eq nil
      expect(first_incident.aggregate_crime_category).to eq nil
      expect(first_incident.caveat).to eq nil
      expect(first_incident.solution).to eq nil
      expect(first_incident.incident_description).to eq 'Police tried to stop Herisse’s speeding four-door Hyundai as it barreled down a crowded Collins Avenue.'
      expect(first_incident.official_disposition_of_death).to eq 'justified'
      expect(first_incident.criminal_charges).to eq nil
      expect(first_incident.news_url).to eq 'http://www.miamiherald.com/2013/04/10/3336557/lab-report-man-slain-in-wild-sobe.html#storylink=cpy'
      expect(first_incident.mental_illness).to eq 'Unknown'
      expect(first_incident.unarmed).to eq nil
      expect(first_incident.line_of_duty).to eq nil
      expect(first_incident.unique_mpv).to eq 6
      expect(first_incident.latitude).to eq 37.79951
      expect(first_incident.longitude).to eq -122.274911

      second_incident = Incident.where(:victim_name => 'Gil Collar').first
      expect(second_incident.victim_race).to eq 'White'

      third_incident = Incident.where(:victim_name => 'Andy Lopez').first
      expect(third_incident.victim_race).to eq 'Hispanic'

      fourth_incident = Incident.where(:victim_name => 'Jack Sun Keewatinawin').first
      expect(fourth_incident.victim_race).to eq 'Native American'

      fifth_incident = Incident.where(:victim_name => 'Wilson A. Lutz').first
      expect(fifth_incident.victim_race).to eq 'Unknown Race'

      sixth_incident = Incident.where(:victim_name => 'Ki Yang').first
      expect(sixth_incident.victim_race).to eq 'Asian'

      seventh_incident = Incident.where(:victim_name => 'Filimoni Raiyawa').first
      expect(seventh_incident.victim_race).to eq 'Asian/Pacific Islander'
    end

    it 'handles duplicate entries by populating all data that does not already exist' do
      Incident.create(:victim_name => "Raymond Herisse",
                      :incident_date => "May 29, 2011",
                      :victim_race => "White",
                      :official_disposition_of_death => "wrongful"
      )

      Incident.create(:victim_name => "Filimoni Raiyawa",
                      :incident_date => "August 18, 2015",
      )
      file = File.new('spec/fixtures/fatal_encounters_data.csv')
      FatalEncountersImporter.import file
      expect(Incident.all.count).to eq 8

      expect(Incident.where(:victim_name => 'Filimoni Raiyawa').count).to eq 2
      expect(Incident.where(:victim_name => 'Raymond Herisse').count).to eq 1
      first_incident = Incident.where(:victim_name => "Raymond Herisse").first

      expect(first_incident.victim_age).to eq 22
      expect(first_incident.victim_gender).to eq "Male"
      expect(first_incident.victim_race).to eq "White"
      expect(first_incident.victim_image_url).to eq "http://graphics8.nytimes.com/images/2013/08/04/us/MIAMI/MIAMI-popup.jpg"
      expect(first_incident.incident_date).to eq Date.parse("2011/05/29")
      expect(first_incident.incident_street_address).to eq "18th Street and Collins Avenue"
      expect(first_incident.incident_city).to eq "Miami Beach"
      expect(first_incident.incident_state).to eq "FL"
      expect(first_incident.incident_zip).to eq "33139"
      expect(first_incident.incident_county).to eq "Miami-Dade"
      expect(first_incident.agency_responsible).to eq "Miami Beach Police Department"
      expect(first_incident.official_disposition_of_death).to eq "wrongful"
      expect(first_incident.news_url).to eq "http://www.miamiherald.com/2013/04/10/3336557/lab-report-man-slain-in-wild-sobe.html#storylink=cpy"
      expect(first_incident.incident_description).to eq "Police tried to stop Herisse’s speeding four-door Hyundai as it barreled down a crowded Collins Avenue."
    end
  end
end

