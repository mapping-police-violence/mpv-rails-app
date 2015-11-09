require 'rails_helper'

describe "Incidents API" do
  it 'sends a list of incidents', type: :request  do
    MpvImporter.import 'spec/fixtures/test_data.csv'

    get '/api/v1/incidents', nil, {'HTTP_ACCEPT' => "application/json"}

    expect(response).to be_success
    response_json = JSON.parse(response.body)
    expect(response_json.length).to eq 5

    expect(response_json[0]["victim_name"]).to eq "Binh Van Nguyen"
    expect(response_json[0]["victim_age"]).to eq 39
    expect(response_json[0]["victim_gender"]).to eq "Male"
    expect(response_json[0]["victim_race"]).to eq "Asian"
    expect(response_json[0]["victim_image_url"]).to eq "http://media.nbcbayarea.com/images/01-bihnnguyen.JPG"
    expect(response_json[0]["incident_date"]).to eq "2013-11-01"
    expect(response_json[0]["incident_street_address"]).to eq "200 block North Maxine Street"
    expect(response_json[0]["incident_city"]).to eq "Santa Ana"
    expect(response_json[0]["incident_state"]).to eq "CA"
    expect(response_json[0]["incident_zip"]).to eq "92703"
    expect(response_json[0]["incident_county"]).to eq "Orange"
    expect(response_json[0]["agency_responsible"]).to eq "Santa Ana Police Department"
    expect(response_json[0]["cause_of_death"]).to eq "Gunshot"
    expect(response_json[0]["alleged_victim_crime"]).to be_nil
    expect(response_json[0]["crime_category"]).to be_nil
    expect(response_json[0]["aggregate_crime_category"]).to be_nil
    expect(response_json[0]["caveat"]).to be_nil
    expect(response_json[0]["solution"]).to be_nil
    expect(response_json[0]["incident_description"]).to eq "Officers on patrol attempted to speak to a suspicious person in the back seat of a car. The suspect jumped into the front seat and drove towards the officers who then fatally shot him."
    expect(response_json[0]["official_disposition_of_death"]).to eq "Justified"
    expect(response_json[0]["criminal_charges"]).to eq "No Known Charges"
    expect(response_json[0]["news_url"]).to eq "http://www.nbclosangeles.com/news/local/Man-Fatally-Shot-by-Santa-Ana-Police-is-Identified-186616081.html"
    expect(response_json[0]["mental_illness"]).to eq "No"
    expect(response_json[0]["unarmed"]).to eq "Allegedly Armed"
    expect(response_json[0]["line_of_duty"]).to eq "Line of Duty"
    expect(response_json[0]["note"]).to be_nil
    expect(response_json[0]["in_custody"]).to be_nil
    expect(response_json[0]["arrest_related_death"]).to be_nil
    expect(response_json[0]["unique_mpv"]).to eq 39


    expect(response_json[1]["victim_name"]).to eq "Garrett Chruma"
    expect(response_json[1]["victim_age"]).to eq 21
    expect(response_json[1]["victim_gender"]).to eq "Male"
    expect(response_json[1]["victim_race"]).to eq "Asian"
    expect(response_json[1]["victim_image_url"]).to eq "https://usgunviolence.files.wordpress.com/2014/03/garett-chruma.jpg?w=625"
    expect(response_json[1]["incident_date"]).to eq "2013-08-06"
    expect(response_json[1]["incident_street_address"]).to eq "Mason Ferry Road"
    expect(response_json[1]["incident_city"]).to eq "Wilmer"
    expect(response_json[1]["incident_state"]).to eq "AL"
    expect(response_json[1]["incident_zip"]).to eq "36587"
    expect(response_json[1]["incident_county"]).to eq "Mobile"
    expect(response_json[1]["agency_responsible"]).to eq "Alabama State Police"
    expect(response_json[1]["cause_of_death"]).to eq "Gunshot"
    expect(response_json[1]["alleged_victim_crime"]).to be_nil
    expect(response_json[1]["crime_category"]).to be_nil
    expect(response_json[1]["aggregate_crime_category"]).to be_nil
    expect(response_json[1]["caveat"]).to be_nil
    expect(response_json[1]["solution"]).to be_nil
    expect(response_json[1]["incident_description"]).to eq "Alabama State Troopers began a \"short, high speed chase\" of Garrett Chruma, 21, armed on motorcycle. The chase continued on foot, ended with a confrontation between officers in which Chruma was shot and killed, near Mason Ferry Road in Wilmer.The Alabama Bureau of Investigation (ABI) is conducting an investigation."
    expect(response_json[1]["official_disposition_of_death"]).to eq "Pending investigation"
    expect(response_json[1]["criminal_charges"]).to eq "No Known Charges"
    expect(response_json[1]["news_url"]).to eq "http://www.abc3340.com/story/22548035/state-trooper-shoots-kills-suspect-after-chase-near-mobile"
    expect(response_json[1]["mental_illness"]).to eq "No"
    expect(response_json[1]["unarmed"]).to eq "Allegedly Armed"
    expect(response_json[1]["line_of_duty"]).to eq "Line of Duty"
    expect(response_json[1]["note"]).to be_nil
    expect(response_json[1]["in_custody"]).to be_nil
    expect(response_json[1]["arrest_related_death"]).to be_nil
    expect(response_json[1]["unique_mpv"]).to eq 457
  end
end