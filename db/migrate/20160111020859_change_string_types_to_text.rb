class ChangeStringTypesToText < ActiveRecord::Migration
  def up
    change_column :incidents, :within_city_limits, :text
    change_column :incidents, :officers_involved, :text
    change_column :incidents, :race_of_officers_involved, :text
    change_column :incidents, :gender_of_officers_involved, :text
    change_column :incidents, :notes_related_to_officers_involved, :text
    change_column :incidents, :suspect_weapon_type, :text
  end

  def down
    change_column :incidents, :within_city_limits, :string
    change_column :incidents, :officers_involved, :string
    change_column :incidents, :race_of_officers_involved, :string
    change_column :incidents, :gender_of_officers_involved, :string
    change_column :incidents, :notes_related_to_officers_involved, :string
    change_column :incidents, :suspect_weapon_type, :string
  end
end
