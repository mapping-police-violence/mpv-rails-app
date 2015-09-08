class Api::V1::IncidentsController < ApplicationController

  respond_to :json
  caches_action(:index)

  def index
    respond_with Incident.all
  end
end