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

  index do
    selectable_column
    column 'Name' do |incident|
      link_to incident.victim_name, admin_incident_path(incident)
    end
    column 'Race', :victim_race
    column 'Gender', :victim_gender
    column 'Image' do |incident|
      link_to 'link', incident.victim_image_url
    end
    column 'Date', :incident_date
    column 'Street Address', :incident_street_address
    column 'City', :incident_city
    column 'State', :incident_state
    column 'Agency Responsible', :agency_responsible
    column 'Aggregate Crime Category', :aggregate_crime_category
    column 'Unarmed', :unarmed
  end
end
