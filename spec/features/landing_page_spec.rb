require 'rails_helper'
include ResponsiveHelpers

describe 'the homepage' do
  before :each do
    Capybara.current_driver = :selenium
    visit '/'
  end

  describe 'the header' do
    it 'shows the Mapping PoliceViolence link' do
      expect(find('.navbar-header')).to have_content('MAPPING POLICE VIOLENCE')
    end

    it 'links to the cities page' do
      href = 'http://mappingpoliceviolence.org/cities/'
      expect(page).to have_selector ".navbar-header a[href='#{href}']", text: 'STATES & CITIES'
    end

    it 'links to the reports page' do
      href = 'http://mappingpoliceviolence.org/reports/'
      expect(page).to have_selector ".navbar-header a[href='#{href}']", text: 'REPORTS'
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

    it 'displays the carousel' do
      expect(page.find ".carousel-wrapper").to be_visible
      expect(page.find(".carousel-image")['src']).to have_content 'carousel_1.png'
    end

    it 'clicking right advances the image carousel' do
      page.find("#right-carousel-link").click
      expect(page.find(".carousel-image")['src']).to have_content 'carousel_2.png'
    end

    it 'clicking left rewinds (is that the right word? shrug) the image carousel' do
      page.find("#left-carousel-link").click
      expect(page.find(".carousel-image")['src']).to have_content 'carousel_4.png'
    end

  describe 'map is present' do
    it 'leaflet-map-pane exists' do
      expect(page.find ".leaflet-map-pane").to be_visible
    end
  end
end