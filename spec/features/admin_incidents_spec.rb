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
        line.sub! 'Allegedly Armed,,,,,,,8178.1,', 'Allegedly Armed,,,,,true,,8178.1,'
      end
      if line.include? 'Kong Nay'
        line.sub! 'Line of Duty,,,,,,4027.1,', 'Line of Duty,,,,true,,4027.1,'
      end
      if line.include? 'Christopher A. Fredette'
        line.sub! 'Line of Duty,,,,,,3810.1,', 'Line of Duty,,,,true,,3810.1,'
      end
      if line.include? 'Alan Bellew'
        line.sub! 'Not In-Custody/Inmate,,,,7735.1,', 'Not In-Custody/Inmate,,true,,7735.1,'
      end
      line.sub! 'TRUE', 'true'
      line.sub! 'FALSE', 'false'
      expect(page).to have_content line
    end
  end

  it 'shows the incident version information' do
    click_link 'Mohammad Abdulazeez'
    expect(page).to have_content 'This is the latest version'
    expect(page).not_to have_content 'Other versions'
    click_link 'Edit Incident'
    fill_in 'Victim age', :with => '45'
    click_button 'Update Incident'
    expect(page).to have_content 'This is the latest version'
    expect(page).to have_content 'By: admin@example.com'
    expect(page).to have_content 'Other versions'
    click_link 'Version 1'
    expect(page).to have_content 'This is version 1'
    expect(page).to have_link 'Latest'

    click_link 'View History'
    expect(page.find('#diff-version-1')).to have_content 'Version 1'
    expect(page.find('#diff-version-2')).to have_content 'Version 2'
    expect(page.find('#diff-version-2')).to have_content 'victim_age:'
    expect(page.find('#diff-version-2')).to have_content '- 24'
    expect(page.find('#diff-version-2')).to have_content '- 45'
  end
end

