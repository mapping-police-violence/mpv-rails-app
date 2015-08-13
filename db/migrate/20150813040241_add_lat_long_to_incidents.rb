class AddLatLongToIncidents < ActiveRecord::Migration
  def change
    add_column :incidents, :latitude, :decimal, {:precision=>10, :scale=>6}
    add_column :incidents, :longitude, :decimal, {:precision=>10, :scale=>6}
  end
end
