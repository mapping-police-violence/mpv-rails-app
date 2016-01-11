require 'rails_helper'

describe 'the download page' do
  before :each do
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    visit '/admin/incidents/download_file'
    fill_in "Email", :with => "admin@example.com"
    fill_in "Password", :with => "password"
    click_button "Login"
  end

  it ('allows users to download entries after a given date') do

    Incident.create!({
                        :victim_name => 'Current Test Entry'
                    })

    Timecop.freeze(Time.local(2000)) do
      Incident.create!({
                           :victim_name => 'Older Test Entry'
                       })
    end

    fill_in 'Entries after:', :with => '2015-01-01'
    click_button 'Download'

    header = page.response_headers['Content-Disposition']
    expect(header).to match /^attachment/
    expect(header).to match /filename="incidents-.+\.csv"$/

    expect(page).to have_content('Current Test Entry')
    expect(page).not_to have_content('Older Test Entry')
  end


end

