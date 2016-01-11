class RemoveNotesRelatedToOfficerInvolved < ActiveRecord::Migration
  def change
    remove_column :incidents, :notes_related_to_officer_involved, :string
  end
end
