require 'rails_helper'
include ResponsiveHelpers

describe 'the header' do
  before :each do
    Capybara.current_driver = :selenium
    visit '/'
  end

  it 'shows the Mapping PoliceViolence link' do
    expect(find('.navbar-header')).to have_content('MAPPING POLICE VIOLENCE')
  end

  it 'links to the cities page' do
    href = 'http://mappingpoliceviolence.org/cities/'
    page.should have_selector ".navbar-header a[href='#{href}']", text: 'STATES & CITIES'
  end

  it 'links to the reports page' do
    href = 'http://mappingpoliceviolence.org/reports/'
    page.should have_selector ".navbar-header a[href='#{href}']", text: 'REPORTS'
  end

  it 'hides the hamburger menu in full screen view' do
    expect(page.find ".navbar-toggle", :visible => false).not_to be_visible
  end

  describe 'phone layout' do
    before :each do
      resize_window_to_mobile
    end

    it 'displays the hamburger icon' do
      expect(page.find ".navbar-toggle").to be_visible
    end
  end
end