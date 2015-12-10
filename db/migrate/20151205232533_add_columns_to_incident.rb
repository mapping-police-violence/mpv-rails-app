class AddColumnsToIncident < ActiveRecord::Migration
  def change
    add_column :incidents, :within_city_limits, :string
    add_column :incidents, :officers_involved, :string
    add_column :incidents, :race_of_officers_involved, :string
    add_column :incidents, :gender_of_officers_involved, :string
    add_column :incidents, :notes_related_to_officers_involved, :string
    add_column :incidents, :sort_order, :integer
    add_column :incidents, :unique_identifier, :decimal
    add_column :incidents, :suspect_weapon_type, :string
    add_column :incidents, :notes_related_to_officer_involved, :string
  end
end
