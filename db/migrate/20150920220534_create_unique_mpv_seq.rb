class CreateUniqueMpvSeq < ActiveRecord::Migration
  def change
    create_table :unique_mpv_seq do |t|
      t.integer :last_value
    end

    last_incident = Incident.order(:unique_mpv).where.not(:unique_mpv => nil).last
    if (last_incident)
      UniqueMpvSeq.create(:last_value => last_incident.unique_mpv)
    else
      UniqueMpvSeq.create(:last_value => 0)
    end
  end
end

