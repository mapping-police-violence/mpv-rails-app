require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Incidents' do
  header 'Accept', 'application/json'

  before do
    MpvImporter.import 'spec/fixtures/mpv_test_data.csv'
    Incident.where(victim_name: 'Garrett Chruma').first.update_attribute(:needs_review, false)
    Incident.where(victim_name: 'Alan Bellew').first.update_attribute(:needs_review, false)
  end

  get '/api/v1/incidents' do
    parameter :verbose, 'Set verbosity level of response. True includes all fields and false only includes lat/long and incident ID. Defaults to false.'

    example_request 'Getting a list of incidents in summary mode' do
      expect(status).to eq(200)
      response_json = JSON.parse(response_body)
      expect(response_json.length).to eq 3

      first_incident = Incident.where(victim_name: "Binh Van Nguyen").first
      expect(response_json[1]["id"]).to eq first_incident.id
      expect(response_json[1]["latitude"]).to eq "33.745989"
      expect(response_json[1]["longitude"]).to eq "-117.93968"
      expect(response_json[1].keys).not_to include "victim_name"
      expect(response_json[1].keys).not_to include "victim_age"
      expect(response_json[1].keys).not_to include "victim_gender"
      expect(response_json[1].keys).not_to include "victim_race"
      expect(response_json[1].keys).not_to include "victim_image_url"
      expect(response_json[1].keys).not_to include "incident_date"
      expect(response_json[1].keys).not_to include "incident_street_address"
      expect(response_json[1].keys).not_to include "incident_city"
      expect(response_json[1].keys).not_to include "incident_state"
      expect(response_json[1].keys).not_to include "incident_zip"
      expect(response_json[1].keys).not_to include "incident_county"
      expect(response_json[1].keys).not_to include "agency_responsible"
      expect(response_json[1].keys).not_to include "cause_of_death"
      expect(response_json[1].keys).not_to include "alleged_victim_crime"
      expect(response_json[1].keys).not_to include "crime_category"
      expect(response_json[1].keys).not_to include "aggregate_crime_category"
      expect(response_json[1].keys).not_to include "caveat"
      expect(response_json[1].keys).not_to include "solution"
      expect(response_json[1].keys).not_to include "incident_description"
      expect(response_json[1].keys).not_to include "official_disposition_of_death"
      expect(response_json[1].keys).not_to include "criminal_charges"
      expect(response_json[1].keys).not_to include "news_url"
      expect(response_json[1].keys).not_to include "mental_illness"
      expect(response_json[1].keys).not_to include "unarmed"
      expect(response_json[1].keys).not_to include "line_of_duty"
      expect(response_json[1].keys).not_to include "note"
      expect(response_json[1].keys).not_to include "in_custody"
      expect(response_json[1].keys).not_to include "arrest_related_death"
      expect(response_json[1].keys).not_to include "unique_mpv"
      expect(response_json[1].keys).not_to include "needs_review"

      zero_incident = Incident.where(victim_name: "Garrett Chruma").first
      expect(response_json[0]["id"]).to eq zero_incident.id
      expect(response_json[0]["latitude"]).to eq "30.8137"
      expect(response_json[0]["longitude"]).to eq "-88.3332"
      expect(response_json[0].keys).not_to include "victim_name"
      expect(response_json[0].keys).not_to include "victim_age"
      expect(response_json[0].keys).not_to include "victim_gender"
      expect(response_json[0].keys).not_to include "victim_race"
      expect(response_json[0].keys).not_to include "victim_image_url"
      expect(response_json[0].keys).not_to include "incident_date"
      expect(response_json[0].keys).not_to include "incident_street_address"
      expect(response_json[0].keys).not_to include "incident_city"
      expect(response_json[0].keys).not_to include "incident_state"
      expect(response_json[0].keys).not_to include "incident_zip"
      expect(response_json[0].keys).not_to include "incident_county"
      expect(response_json[0].keys).not_to include "agency_responsible"
      expect(response_json[0].keys).not_to include "cause_of_death"
      expect(response_json[0].keys).not_to include "alleged_victim_crime"
      expect(response_json[0].keys).not_to include "crime_category"
      expect(response_json[0].keys).not_to include "aggregate_crime_category"
      expect(response_json[0].keys).not_to include "caveat"
      expect(response_json[0].keys).not_to include "solution"
      expect(response_json[0].keys).not_to include "incident_description"
      expect(response_json[0].keys).not_to include "official_disposition_of_death"
      expect(response_json[0].keys).not_to include "criminal_charges"
      expect(response_json[0].keys).not_to include "news_url"
      expect(response_json[0].keys).not_to include "mental_illness"
      expect(response_json[0].keys).not_to include "unarmed"
      expect(response_json[0].keys).not_to include "line_of_duty"
      expect(response_json[0].keys).not_to include "note"
      expect(response_json[0].keys).not_to include "in_custody"
      expect(response_json[0].keys).not_to include "arrest_related_death"
      expect(response_json[0].keys).not_to include "unique_mpv"
      expect(response_json[1].keys).not_to include "needs_review"
    end

    example_request 'Getting a list of incidents in verbose mode', :verbose => true do
      expect(status).to eq(200)
      response_json = JSON.parse(response_body)
      expect(response_json.length).to eq 3

      first_incident = Incident.where(victim_name: "Binh Van Nguyen").first
      expect(response_json[1]["id"]).to eq first_incident.id
      expect(response_json[1]["victim_name"]).to eq "Binh Van Nguyen"
      expect(response_json[1]["victim_age"]).to eq 39
      expect(response_json[1]["victim_gender"]).to eq "Male"
      expect(response_json[1]["victim_race"]).to eq "Asian"
      expect(response_json[1]["victim_image_url"]).to eq "http://media.nbcbayarea.com/images/01-bihnnguyen.JPG"
      expect(response_json[1]["incident_date"]).to eq "2013-11-01"
      expect(response_json[1]["incident_street_address"]).to eq "200 block North Maxine Street"
      expect(response_json[1]["incident_city"]).to eq "Santa Ana"
      expect(response_json[1]["incident_state"]).to eq "CA"
      expect(response_json[1]["incident_zip"]).to eq "92703"
      expect(response_json[1]["incident_county"]).to eq "Orange"
      expect(response_json[1]["agency_responsible"]).to eq "Santa Ana Police Department"
      expect(response_json[1]["cause_of_death"]).to eq "Gunshot"
      expect(response_json[1]["alleged_victim_crime"]).to be_nil
      expect(response_json[1]["crime_category"]).to be_nil
      expect(response_json[1]["aggregate_crime_category"]).to be_nil
      expect(response_json[1]["caveat"]).to be_nil
      expect(response_json[1]["solution"]).to be_nil
      expect(response_json[1]["incident_description"]).to eq "Officers on patrol attempted to speak to a suspicious person in the back seat of a car. The suspect jumped into the front seat and drove towards the officers who then fatally shot him."
      expect(response_json[1]["official_disposition_of_death"]).to eq "Justified"
      expect(response_json[1]["criminal_charges"]).to eq "No Known Charges"
      expect(response_json[1]["news_url"]).to eq "http://www.nbclosangeles.com/news/local/Man-Fatally-Shot-by-Santa-Ana-Police-is-Identified-186616081.html"
      expect(response_json[1]["mental_illness"]).to eq "No"
      expect(response_json[1]["unarmed"]).to eq "Allegedly Armed"
      expect(response_json[1]["line_of_duty"]).to eq "Line of Duty"
      expect(response_json[1]["note"]).to be_nil
      expect(response_json[1]["in_custody"]).to be_nil
      expect(response_json[1]["arrest_related_death"]).to be_nil
      expect(response_json[1]["unique_mpv"]).to eq 39
      expect(response_json[1]["latitude"]).to eq "33.745989"
      expect(response_json[1]["longitude"]).to eq "-117.93968"
      expect(response_json[1].keys).not_to include "needs_review"

      expect(response_json[0]["victim_name"]).to eq "Garrett Chruma"
      expect(response_json[0]["victim_age"]).to eq 21
      expect(response_json[0]["victim_gender"]).to eq "Male"
      expect(response_json[0]["victim_race"]).to eq "Asian"
      expect(response_json[0]["victim_image_url"]).to eq "https://usgunviolence.files.wordpress.com/2014/03/garett-chruma.jpg?w=625"
      expect(response_json[0]["incident_date"]).to eq "2013-08-06"
      expect(response_json[0]["incident_street_address"]).to eq "Mason Ferry Road"
      expect(response_json[0]["incident_city"]).to eq "Wilmer"
      expect(response_json[0]["incident_state"]).to eq "AL"
      expect(response_json[0]["incident_zip"]).to eq "36587"
      expect(response_json[0]["incident_county"]).to eq "Mobile"
      expect(response_json[0]["agency_responsible"]).to eq "Alabama State Police"
      expect(response_json[0]["cause_of_death"]).to eq "Gunshot"
      expect(response_json[0]["alleged_victim_crime"]).to be_nil
      expect(response_json[0]["crime_category"]).to be_nil
      expect(response_json[0]["aggregate_crime_category"]).to be_nil
      expect(response_json[0]["caveat"]).to be_nil
      expect(response_json[0]["solution"]).to be_nil
      expect(response_json[0]["incident_description"]).to eq "Alabama State Troopers began a \"short, high speed chase\" of Garrett Chruma, 21, armed on motorcycle. The chase continued on foot, ended with a confrontation between officers in which Chruma was shot and killed, near Mason Ferry Road in Wilmer.The Alabama Bureau of Investigation (ABI) is conducting an investigation."
      expect(response_json[0]["official_disposition_of_death"]).to eq "Pending investigation"
      expect(response_json[0]["criminal_charges"]).to eq "No Known Charges"
      expect(response_json[0]["news_url"]).to eq "http://www.abc3340.com/story/22548035/state-trooper-shoots-kills-suspect-after-chase-near-mobile"
      expect(response_json[0]["mental_illness"]).to eq "No"
      expect(response_json[0]["unarmed"]).to eq "Allegedly Armed"
      expect(response_json[0]["line_of_duty"]).to eq "Line of Duty"
      expect(response_json[0]["note"]).to be_nil
      expect(response_json[0]["in_custody"]).to be_nil
      expect(response_json[0]["arrest_related_death"]).to be_nil
      expect(response_json[0]["unique_mpv"]).to eq 457
      expect(response_json[0]["latitude"]).to eq "30.8137"
      expect(response_json[0]["longitude"]).to eq "-88.3332"
      expect(response_json[1].keys).not_to include "needs_review"

      expect(response_json[2]["victim_name"]).to eq "Alan Bellew"
      expect(response_json[2]["officers_involved"]).to eq "Dominic Lovato; Michael Currier"
      expect(response_json[2]["suspect_weapon_type"]).to eq "Non-lethal firearm"
      expect(response_json[1].keys).not_to include "needs_review"
    end
  end
end