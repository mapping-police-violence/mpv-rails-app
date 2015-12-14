require 'rails_helper'

describe 'api docs' do
  before :each do
    visit '/doc/index.html'
  end

  describe 'api documentation page' do
    it 'Incidents page exists' do
      expect(page).to have_content('Getting a list of incidents')
    end
  end
end
