class Api::V1::IncidentsController < ApplicationController

  respond_to :json

  def index
    respond_with Incident.all
  end
end