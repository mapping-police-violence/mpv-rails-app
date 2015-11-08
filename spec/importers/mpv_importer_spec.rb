require 'rails_helper'

describe 'MpvImporter' do
  describe '#import' do
    it 'imports the data correctly' do
      MpvImporter.import 'spec/fixtures/test_data.csv'
      expect(Incident.all.count).to eq 2

      first_incident = Incident.first
      expect(first_incident.victim_name).to eq "Garrett Chruma"
      expect(first_incident.victim_age).to eq 21
      expect(first_incident.victim_gender).to eq "Male"
      expect(first_incident.victim_race).to eq "Asian"
      expect(first_incident.victim_image_url).to eq "https://usgunviolence.files.wordpress.com/2014/03/garett-chruma.jpg?w=625"
      expect(first_incident.incident_date).to eq Date.parse("6/8/2013")
      expect(first_incident.incident_street_address).to eq "Mason Ferry Road"
      expect(first_incident.incident_city).to eq "Wilmer"
      expect(first_incident.incident_state).to eq "AL"
      expect(first_incident.incident_zip).to eq "36587"
      expect(first_incident.incident_county).to eq "Mobile"
      expect(first_incident.agency_responsible).to eq "Alabama State Police"
      expect(first_incident.cause_of_death).to eq "Gunshot"
      expect(first_incident.alleged_victim_crime).to eq nil
      expect(first_incident.crime_category).to eq nil
      expect(first_incident.aggregate_crime_category).to eq nil
      expect(first_incident.caveat).to eq nil
      expect(first_incident.solution).to eq nil
      expect(first_incident.incident_description).to eq 'Alabama State Troopers began a "short, high speed chase" of Garrett Chruma, 21, armed on motorcycle. The chase continued on foot, ended with a confrontation between officers in which Chruma was shot and killed, near Mason Ferry Road in Wilmer.The Alabama Bureau of Investigation (ABI) is conducting an investigation.'
      expect(first_incident.official_disposition_of_death).to eq "Pending investigation"
      expect(first_incident.criminal_charges).to eq "No Known Charges"
      expect(first_incident.news_url).to eq "http://www.abc3340.com/story/22548035/state-trooper-shoots-kills-suspect-after-chase-near-mobile"
      expect(first_incident.mental_illness).to eq "No"
      expect(first_incident.unarmed).to eq "Allegedly Armed"
      expect(first_incident.line_of_duty).to eq "Line of Duty"
      expect(first_incident.unique_mpv).to eq 457
      expect(first_incident.latitude).to eq BigDecimal.new(30.8137, 10)
      expect(first_incident.longitude).to eq BigDecimal.new(-88.3332, 10)
    end
  end

  after(:all) do
    Incident.delete_all
  end
end
