class AddUniqueConstraintToUniqueMpv < ActiveRecord::Migration
  def change
    add_index(:incidents, [:unique_mpv], :unique => true)
  end
end
