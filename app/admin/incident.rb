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

  form do |f|
    inputs do
      input :victim_name, :as => :string
      input :victim_age, :as => :number
      input :victim_gender, :as => :select, :collection => Incident.gender_options
      input :victim_race, :as => :select, :collection => Incident.race_options
      input :victim_image_url, :as => :string
      input :incident_date, :as => :date_select
      input :incident_street_address, :as => :string
      input :incident_city, :as => :string
      input :incident_state, :as => :select, :collection => Incident.state_options
      input :incident_zip, :as => :string
      input :incident_county, :as => :string
      input :agency_responsible, :as => :string
      input :cause_of_death, :as => :select, :collection => Incident.cause_of_death_options
      input :alleged_victim_crime, :as => :string
      input :crime_category, :as => :select, :collection => Incident.crime_category_options
      input :aggregate_crime_category, :as => :select, :collection => Incident.aggregate_crime_category_options
      input :caveat, :as => :string
      input :solution, :as => :string
      input :incident_description
      input :official_disposition_of_death, :as => :select, :collection => Incident.official_disposition_of_death_options
      input :criminal_charges, :as => :string
      input :news_url, :as => :string
      input :mental_illness, :as => :select, :collection => Incident.mental_illness_options
      input :unarmed, :as => :select, :collection => Incident.unarmed_options
      input :line_of_duty, :as => :select, :collection => Incident.line_of_duty_options
      input :note, :as => :string
      input :in_custody, :as => :select, :collection => Incident.in_custody_options
      input :arrest_related_death, :as => :string
      input :unique_mpv, :as => :number
      input :latitude, :as => :number
      input :longitude, :as => :number
    end
    actions
    semantic_errors

  end

  collection_action :upload_file do
    render 'admin/upload_file'
  end

  collection_action :import_file, :method => :post do
    if params[:type] == 'the_counted'
      CountedImporter.import(params[:dump][:file])
    elsif params[:type] == 'fatal_encounters'
      FatalEncountersImporter.import(params[:dump][:file])
    elsif params[:type] == 'killed_by_police'
      KilledByPoliceImporter.import(params[:dump][:file])
    elsif params[:type] == 'mpv'
      MpvImporter.import(params[:dump][:file])
    end

    redirect_to :action => :index, :notice => 'File imported successfully!'
  end

end
