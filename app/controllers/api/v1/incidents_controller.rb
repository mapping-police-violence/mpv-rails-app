class Api::V1::IncidentsController < ApplicationController

  respond_to :json
  # caches_action(:index)

  def index
      excluded_fields = [:needs_review]
    unless params[:verbose]
      excluded_fields.concat [
          :victim_name,
          :victim_age,
          :victim_gender,
          :victim_race,
          :victim_image_url,
          :incident_date,
          :incident_street_address,
          :incident_city,
          :incident_state,
          :incident_zip,
          :incident_county,
          :agency_responsible,
          :cause_of_death,
          :alleged_victim_crime,
          :crime_category,
          :aggregate_crime_category,
          :caveat,
          :solution,
          :incident_description,
          :official_disposition_of_death,
          :criminal_charges,
          :news_url,
          :mental_illness,
          :unarmed,
          :line_of_duty,
          :note,
          :in_custody,
          :arrest_related_death,
          :unique_mpv,
          :created_at,
          :updated_at,
          :within_city_limits,
          :officers_involved,
          :race_of_officers_involved,
          :gender_of_officers_involved,
          :notes_related_to_officers_involved,
          :sort_order,
          :unique_identifier,
          :suspect_weapon_type]
    end
    respond_with Incident.where(:needs_review => false).order(:incident_date), :except => excluded_fields
  end
end