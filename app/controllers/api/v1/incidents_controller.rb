class Api::V1::IncidentsController < ApplicationController

  respond_to :json

  caches_page :index

  def index
    respond_with Incident.all
  end
end