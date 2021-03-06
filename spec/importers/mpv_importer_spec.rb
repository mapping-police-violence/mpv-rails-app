require 'rails_helper'

describe 'MpvImporter' do
  describe '#import' do

    it 'imports CSV data correctly' do
      test_file_import('spec/fixtures/mpv_test_data.csv')
    end

    it 'imports XLSX data correctly' do
      test_file_import('spec/fixtures/mpv_test_data.xlsx')
    end

    it 'creates new incidents for novel unique_mpvs and updates existing unique_mpvs on re-import' do
      MpvImporter.import('spec/fixtures/mpv_test_data.csv')
      MpvImporter.import 'spec/fixtures/mpv_test_data_revised.csv'

      # data is updated to match contents of revised file
      expect(Incident.all.count).to eq 7
      second_incident = Incident.where(:victim_name => "Garrett Chruma").first
      expect(second_incident.victim_age).to eq 24
      expect(second_incident.incident_date).to eq Date.parse("7/8/2013")
      expect(Incident.where(:victim_name => "Garrett Chruma").first.needs_review).to eq false
      expect(Incident.where(:victim_name => 'Don White').first.unique_mpv).to eq 988

      # data that weren't modified in the revised file remain the same
      check_common_imported_values
    end
  end

  def test_file_import(path)
    MpvImporter.import(path)
    # if this fails and the count is 1 short, see comment at end of check_common_imported_values
    expect(Incident.all.count).to eq 6
    check_common_imported_values

    # also check values that aren't covered by check_common_imported_values
    second_incident = Incident.where(:victim_name => "Garrett Chruma").first
    expect(second_incident.victim_age).to eq 21
    expect(second_incident.incident_date).to eq Date.parse("6/8/2013")
    expect(second_incident.needs_review).to eq true
  end

  # this doesn't check values that are modified in mpv_test_data_revised
  def check_common_imported_values
    second_incident = Incident.where(:victim_name => "Garrett Chruma").first
    expect(second_incident.victim_name).to eq "Garrett Chruma"
    expect(second_incident.victim_gender).to eq "Male"
    expect(second_incident.victim_race).to eq "Asian"
    expect(second_incident.victim_image_url).to eq "https://usgunviolence.files.wordpress.com/2014/03/garett-chruma.jpg?w=625"
    expect(second_incident.incident_street_address).to eq "Mason Ferry Road"
    expect(second_incident.incident_city).to eq "Wilmer"
    expect(second_incident.incident_state).to eq "AL"
    expect(second_incident.incident_zip).to eq "36587"
    expect(second_incident.incident_county).to eq "Mobile"
    expect(second_incident.agency_responsible).to eq "Alabama State Police"
    expect(second_incident.cause_of_death).to eq "Gunshot"
    expect(second_incident.alleged_victim_crime).to eq nil
    expect(second_incident.crime_category).to eq nil
    expect(second_incident.aggregate_crime_category).to eq nil
    expect(second_incident.caveat).to eq nil
    expect(second_incident.solution).to eq nil
    expect(second_incident.incident_description).to eq 'Alabama State Troopers began a "short, high speed chase" of Garrett Chruma, 21, armed on motorcycle. The chase continued on foot, ended with a confrontation between officers in which Chruma was shot and killed, near Mason Ferry Road in Wilmer.The Alabama Bureau of Investigation (ABI) is conducting an investigation.'
    expect(second_incident.official_disposition_of_death).to eq "Pending investigation"
    expect(second_incident.criminal_charges).to eq "No Known Charges"
    expect(second_incident.news_url).to eq "http://www.abc3340.com/story/22548035/state-trooper-shoots-kills-suspect-after-chase-near-mobile"
    expect(second_incident.mental_illness).to eq "No"
    expect(second_incident.unarmed).to eq "Allegedly Armed"
    expect(second_incident.line_of_duty).to eq "Line of Duty"
    expect(second_incident.unique_mpv).to eq 457
    expect(second_incident.latitude).to eq BigDecimal.new(30.8137, 10)
    expect(second_incident.longitude).to eq BigDecimal.new(-88.3332, 10)

    expect(Incident.where(:victim_name => "Binh Van Nguyen").first.unique_mpv).to eq 39
    expect(Incident.where(:victim_name => "Christopher A. Fredette").first.unique_mpv).to eq 608
    expect(Incident.where(:victim_name => "Kong Nay").first.unique_mpv).to eq 607

    expect(Incident.where(:victim_name => "Binh Van Nguyen").first.needs_review).to eq false
    expect(Incident.where(:victim_name => "Kong Nay").first.needs_review).to eq true

    # this is the person with the blank unique_mpv. if the entries are imported in the wrong
    # order, he'll be assigned 608, and then the subsequent entry with unique_mpv 608 will be treated
    # as an edit to an existing entry rather than a new entry.
    expect(Incident.where(:victim_name => "Mohammad Abdulazeez").first.unique_mpv).to eq 609
  end

  after(:all) do
    Incident.delete_all
  end
end
