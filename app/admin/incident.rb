ActiveAdmin.register Incident do

  permit_params :victim_name, :victim_age, :victim_gender, :victim_race, :victim_image_url, :incident_date,
                :incident_street_address, :incident_city, :incident_state, :incident_zip, :incident_county,
                :agency_responsible, :cause_of_death, :alleged_victim_crime, :crime_category, :aggregate_crime_category,
                :caveat, :solution, :incident_description, :official_disposition_of_death, :criminal_charges,
                :news_url, :mental_illness, :unarmed, :line_of_duty, :note, :in_custody, :arrest_related_death,
                :unique_mpv, :latitude, :longitude


  after_save do
    expire_action :controller => '/api/v1/incidents',
                  :action => :index,
                  :format => :json
  end
  after_destroy do
    expire_action :controller => '/api/v1/incidents',
                  :action => :index,
                  :format => :json
  end
end
