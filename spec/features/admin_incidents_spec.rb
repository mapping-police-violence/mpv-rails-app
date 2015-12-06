require 'rails_helper'

describe 'the incidents page' do
  before :each do
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    MpvImporter.import 'spec/fixtures/mpv_test_data.csv'
    visit '/admin/incidents'
    fill_in 'Email', :with => 'admin@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Login'
  end

  it 'downloads a CSV with no ID column' do
    click_on 'CSV'

    header = page.response_headers['Content-Disposition']
    expect(header).to match /^attachment/
    expect(header).to match /filename="incidents-.+\.csv"$/

    File.open('spec/fixtures/mpv_test_data.csv', 'r:bom|utf-8').each do |line|
      if line.include? 'Mohammad Abdulazeez'
        mohammad = Incident.where(:victim_name => 'Mohammad Abdulazeez').first
        line.sub! ',34.733616', "#{mohammad.unique_mpv},34.733616"
      end
      expect(page).to have_content line
    end
  end
end

