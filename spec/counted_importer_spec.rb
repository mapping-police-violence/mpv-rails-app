require 'rails_helper'

describe 'CountedImporter' do
  describe '#import' do
    it 'imports the data correctly' do
      UniqueMpvSeq.create(:last_value => 5)

      file = File.new('spec/fixtures/the_counted_data.csv')
      CountedImporter.import file
      expect(Incident.all.count).to eq 4

      first_incident = Incident.where(:victim_name => "Roberto Ornelas").first
      expect(first_incident.victim_age).to eq 18
      expect(first_incident.victim_gender).to eq "Male"
      expect(first_incident.victim_race).to eq "Hispanic"
      expect(first_incident.victim_image_url).to eq nil
      expect(first_incident.incident_date).to eq Date.parse("1/1/2015")
      expect(first_incident.incident_street_address).to eq "39 N Marlin Ave"
      expect(first_incident.incident_city).to eq "Key Largo"
      expect(first_incident.incident_state).to eq "FL"
      expect(first_incident.incident_zip).to eq nil
      expect(first_incident.incident_county).to eq nil
      expect(first_incident.agency_responsible).to eq "Monroe County Sheriff's Office"
      expect(first_incident.cause_of_death).to eq "Unknown"
      expect(first_incident.alleged_victim_crime).to eq nil
      expect(first_incident.crime_category).to eq nil
      expect(first_incident.aggregate_crime_category).to eq nil
      expect(first_incident.caveat).to eq nil
      expect(first_incident.solution).to eq nil
      expect(first_incident.incident_description).to eq nil
      expect(first_incident.official_disposition_of_death).to eq nil
      expect(first_incident.criminal_charges).to eq nil
      expect(first_incident.news_url).to eq nil
      expect(first_incident.mental_illness).to eq nil
      expect(first_incident.unarmed).to eq "Unarmed"
      expect(first_incident.line_of_duty).to eq nil
      expect(first_incident.unique_mpv).to eq 6
      expect(first_incident.latitude).to eq nil
      expect(first_incident.longitude).to eq nil

      second_incident = Incident.where(:victim_name => "Omarr Jackson").first
      expect(second_incident.unarmed).to eq "Allegedly Armed"

      third_incident = Incident.where(:victim_name => "Matthew Hoffman").first
      expect(third_incident.unarmed).to eq "Unarmed"

      fourth_incident = Incident.where(:victim_name => "Richard Carlin").first
      expect(fourth_incident.unarmed).to eq "Unclear"
    end
  end

  after(:all) do
    Incident.delete_all
  end
end