require 'rails_helper'
include ResponsiveHelpers

describe "the header" do
  before :each do
    Capybara.current_driver = :selenium
    visit '/'
  end

  it "shows the Mapping PoliceViolence link" do
    expect(find('.navbar-header')).to have_content('MAPPING POLICE VIOLENCE')
  end

  it "links to the cities page" do
    within('.navbar-header') do
      click_link 'STATES & CITIES'
    end
    expect(page).to have_content 'City Comparison Tool'
  end

  it "links to the reports page" do
    within('.navbar-header') do
      click_link 'REPORTS'
    end
    expect(page).to have_content 'Police Violence Reports'
  end

  describe 'phone layout' do
    before :each do
      resize_window_to_mobile
    end

    it "shows the Mapping PoliceViolence link" do
      expect(find('.navbar-header')).to have_content('MAPPING POLICE VIOLENCE')
    end
  end
end