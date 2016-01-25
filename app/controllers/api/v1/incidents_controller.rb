class Api::V1::IncidentsController < ApplicationController

  respond_to :json
  # caches_action(:index)

  def index
    respond_with Incident.where(:needs_review => false).order(:incident_date), :except => :needs_review
    # TODO: figure out if there are other columns we'd like to exclude from api output
  end
end