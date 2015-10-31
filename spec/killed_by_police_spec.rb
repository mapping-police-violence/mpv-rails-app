require 'rails_helper'

describe 'KilledByPoliceImporter' do
  describe '#import' do
    it 'imports the data correctly' do
      file = File.new('spec/fixtures/killed_by_police_data.csv')
      KilledByPoliceImporter.import file
      expect(Incident.all.count).to eq 3
    end
  end
end