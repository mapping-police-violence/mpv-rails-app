require 'rails_helper'

describe 'the dashboard' do
  before :each do
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    visit '/admin'
    fill_in "Email", :with => "admin@example.com"
    fill_in "Password", :with => "password"
    click_button "Login"
  end

  it "shows the import from the counted button" do
    click_on 'Import from The Counted'
    expect(page).to have_content('Upload')

    attach_file "dump_file", "#{Rails.root}/spec/fixtures/the_counted_data.csv"
    click_button('Submit')

    expect(page).to have_content('Incidents')
    expect(page).to have_content('Richard Carlin')
    expect(page).to have_content('Matthew Hoffman')
    expect(page).to have_content('Omarr Jackson')

    # expected number of incidents, plus extra header row
    expect(page.all('tr').size).to be 5
  end

  it "shows the import from the fatal encounters button" do
    click_on 'Import from Fatal Encounters'
    expect(page).to have_content('Upload')

    attach_file "dump_file", "#{Rails.root}/spec/fixtures/fatal_encounters_data.csv"
    click_button('Submit')

    expect(page).to have_content('Incidents')
    expect(page).to have_content('Raymond Herisse')
    expect(page).to have_content('Filimoni Raiyawa')
    expect(page.all('tr').size).to be 8
  end

  it "shows the import from killed by police button" do
    click_on 'Import from Killed By Police'
    expect(page).to have_content('Upload')

    attach_file "dump_file", "#{Rails.root}/spec/fixtures/killed_by_police_data.xlsx"
    click_button('Submit')

    expect(page).to have_content('Incidents')
    expect(page).to have_content('Kobvey Igbuhay')
    expect(page.all('tr').size).to be 13
  end

  it "shows the import from mpv button" do
    click_on 'Re-import MPV data'
    expect(page).to have_content('Upload')
    attach_file "dump_file", "#{Rails.root}/spec/fixtures/mpv_test_data.csv"

    click_button('Submit')
    expect(page).to have_content('Incidents')
    expect(page).to have_content('Garrett Chruma')
    expect(page.all('tr').size).to be 7
  end

  it "shows the versions table" do
    incident = Incident.create(
        :victim_name => 'Bob Foo',
        :incident_city => 'Oakland',
        :incident_state => 'CA',
        :incident_zip => '94607'
    )

    incident.update_attributes(incident_city: 'Berkeley')
    visit '/admin'
    expect(page).to have_content 'Recently updated content'
    expect(page).to have_content 'Bob Foo'
  end

  it 'has a button to go to the CSV download page' do
    click_on 'Download CSV'
    expect(page).to have_content('Download')
    expect(page).to have_content('Entries after')
  end

end
