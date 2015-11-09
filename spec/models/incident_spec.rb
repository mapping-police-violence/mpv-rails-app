require 'rails_helper'
include GeocodingHelpers

describe 'Incident' do
  describe 'geocoding' do
    context 'with a full street address' do
      let(:subject) { Incident.create(
          :incident_street_address => '455 7th St',
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94607'
      ) }

      before do
        stub_geocoding_request('455 7th St, Oakland, CA, 94607', 37.7995099, -122.2749114)
      end

      it 'makes a geocoding request and saves the response' do
        expect(subject.latitude).to eq 37.7995099
        expect(subject.longitude).to eq -122.2749114
      end

    end

    context 'with only city and state' do
      let(:subject) {
        Incident.create(
            :incident_city => 'Oakland',
            :incident_state => 'CA',
            :incident_zip => '94607'
        ) }

      before do
        stub_geocoding_request('Oakland, CA, 94607', 37.7995099, -122.2749114)
      end

      it 'geocodes based on the city and state and saves the response' do
        expect(subject.latitude).to eq 37.7995099
        expect(subject.longitude).to eq -122.2749114
      end
    end
  end


  context 'when latitude and longitude already exists' do
    let(:subject) {
      Incident.create(
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94608',
          :latitude => 88.9000001,
          :longitude => 123.7654321
      ) }

    it 'does not issue a geocoding request' do
      expect(subject.latitude).to eq 88.9000001
      expect(subject.longitude).to eq 123.7654321
    end
  end

  context 'rate-limiting' do
    it 'throttles incident creation rate to respect geocoding rate limit' do
      subject1 = Incident.create(
          :incident_street_address => '455 7th St',
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94607'
      )
      time_after_first_create = Time::now
      subject2 = Incident.create(
          :incident_street_address => '455 7th St',
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94607'
      )

      expect(Time::now - time_after_first_create > 1.0/Incident::MAX_GEOCODE_CALLS_PER_SECOND)
    end

    it 'refrains from throttling incident creation rate for incidents that do not require geocoding' do
      Incident.create(
          :incident_street_address => '455 7th St',
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94607',
          :latitude => 88.9000001,
          :longitude => 123.7654321
      )
      time_after_first_create = Time::now
      Incident.create(
          :incident_street_address => '455 7th St',
          :incident_city => 'Oakland',
          :incident_state => 'CA',
          :incident_zip => '94607'
      )

      expect(Time::now - time_after_first_create < 1.0/Incident::MAX_GEOCODE_CALLS_PER_SECOND)
    end
  end
end