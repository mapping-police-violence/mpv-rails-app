require 'rails_helper'

describe 'KilledByPoliceImporter' do
  describe '#import' do
    it 'imports XLSX data correctly' do
      test_file_import('spec/fixtures/killed_by_police_data.xlsx', true)
    end

    it 'imports CSV data correctly' do
      # converting the data to CSV strips the victim image URLs, since they are represented
      # as HTML link targets rather than in their own column
      test_file_import('spec/fixtures/killed_by_police_data.csv', false)
    end

    def test_file_import(path, expect_image_url)
      file = File.new(path)
      KilledByPoliceImporter.import file
      expect(Incident.all.count).to eq 12

      first_incident = Incident.where(:victim_name => 'Kobvey Igbuhay').first
      expect(first_incident.victim_age).to eq 18
      expect(first_incident.victim_gender).to eq 'Male'
      expect(first_incident.victim_race).to eq 'Unknown Race'
      if expect_image_url
        expect(first_incident.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150979.jpg'
      end
      expect(first_incident.incident_state).to eq 'FL'
      expect(first_incident.incident_date).to eq Date.parse('26/10/2015')
      expect(first_incident.news_url).to eq 'http://www.tampabay.com/news/publicsafety/crime/one-suspect-shot-two-in-custody-and-tampa-police-hunting-for-a-fourth/2251265'
      expect(first_incident.latitude).to eq 40.714353
      expect(first_incident.longitude).to eq -74.005973

      # missing both name and age
      # also missing race
      second_incident = Incident.where(:incident_date => Date.parse('30/10/2015')).first
      expect(second_incident.victim_name).to eq nil
      expect(second_incident.victim_age).to eq nil
      expect(second_incident.victim_image_url).to eq nil
      expect(second_incident.victim_race).to eq 'Unknown Race'

      # missing name but not age
      third_incident = Incident.where(:incident_date => Date.parse('21/10/2015')).first
      expect(third_incident.victim_name).to eq nil
      expect(third_incident.victim_age).to eq 36
      expect(third_incident.victim_image_url).to eq nil

      # female
      fourth_incident = Incident.where(:incident_date => Date.parse('14/10/2015')).first
      expect(fourth_incident.victim_gender).to eq 'Female'
      expect(fourth_incident.victim_race).to eq 'White'
      if expect_image_url
        expect(fourth_incident.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150924.jpg'
      end

      #  black, male
      fifth_incident = Incident.where(:victim_name => 'Kaleb Alexander').first
      expect(fifth_incident.victim_gender).to eq 'Male'
      expect(fifth_incident.victim_race).to eq 'Black'

      # age, no name
      sixth_incident = Incident.where(:incident_date => Date.parse('4/10/2015')).first
      # the input is a string '40s'. This gets converted to a number, 40 which seems like reasonable behavior.
      expect(sixth_incident.victim_age).to eq 40
      expect(sixth_incident.victim_name).to eq nil

      # asian
      seventh_incident = Incident.where(:victim_name => 'Kevin Lau').first
      expect(seventh_incident.victim_race).to eq 'Asian'

      # two incidents jammed into one row
      eighth_entry = Incident.where(:incident_date => Date.parse('6/9/2015'))
      expect(eighth_entry.first.victim_name).to eq 'Angelo Delano Perry'
      expect(eighth_entry.first.victim_age).to eq 35
      expect(eighth_entry.first.victim_gender).to eq 'Male'
      expect(eighth_entry.second.victim_name).to eq 'India Kager'
      expect(eighth_entry.second.victim_age).to eq 28
      expect(eighth_entry.second.victim_gender).to eq 'Female'
      # the xlsx importer gem we are using can't handle multiple links in the same cell, so we
      # are currently unable to handle this edge case.
      #expect(eighth_entry.first.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150812.jpg'
      #expect(eighth_entry.second.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150811.jpg'

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
      expect(eleventh_incident.incident_date).to eq Date.parse('1/1/2015')


    end

    it 'updates victim image and news url fields for existing entries with the same name and date within 3 days' do
      Incident.create(
          :victim_name => 'Kobvey Igbuhay',
          :victim_age => 21,
          :victim_gender => 'Female',
          :victim_race => 'Black',
          :victim_image_url => 'http://badurl.jpg',
          :incident_state => 'LA',
          :incident_date => Date.parse('29/10/2015'),
          :news_url => 'http://fakenews.com',
      )

      Incident.create(
          :victim_name => 'Garrett Gagne',
          :incident_date => Date.parse('2014/12/28')
      )

      file = File.new('spec/fixtures/killed_by_police_data.xlsx')
      KilledByPoliceImporter.import file
      expect(Incident.all.count).to eq 13

      expect(Incident.where(:victim_name => 'Garrett Gagne').count).to eq 2

      expect(Incident.where(:victim_name => 'Kobvey Igbuhay').count).to eq 1
      first_incident = Incident.where(:victim_name => 'Kobvey Igbuhay').first
      expect(first_incident.victim_age).to eq 21
      expect(first_incident.victim_gender).to eq 'Female'
      expect(first_incident.victim_race).to eq 'Black'
      expect(first_incident.victim_image_url).to eq 'http://www.killedbypolice.net/victims/150979.jpg'
      expect(first_incident.incident_state).to eq 'LA'
      expect(first_incident.incident_date).to eq Date.parse('29/10/2015')
      expect(first_incident.news_url).to eq 'http://www.tampabay.com/news/publicsafety/crime/one-suspect-shot-two-in-custody-and-tampa-police-hunting-for-a-fourth/2251265'
    end
  end

end