require 'uri'

module GeocodingHelpers
  def stub_geocoding_request address, latitude, longitude
    Geocoder::Lookup::Test.add_stub(
        address, [
                   {
                       'latitude' => latitude,
                       'longitude' => longitude
                   }
               ]
    )
  end
end