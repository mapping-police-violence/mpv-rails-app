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
    click_on 'Import CSV from The Counted'
    expect(page).to have_content('Upload Csv')

    attach_file "dump_file", "#{Rails.root}/spec/fixtures/the_counted_data.csv"
    click_button('Submit')

    expect(page).to have_content('Incidents')
    expect(page).to have_content('Richard Carlin')
    expect(page).to have_content('Matthew Hoffman')
    expect(page).to have_content('Omarr Jackson')
  end

end