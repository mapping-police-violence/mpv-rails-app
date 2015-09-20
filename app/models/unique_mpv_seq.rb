class UniqueMpvSeq < ActiveRecord::Base
  self.table_name = 'unique_mpv_seq'

  def self.next
    sequence = UniqueMpvSeq.first
    if sequence.nil?
      sequence = UniqueMpvSeq.create(:last_value => 0)
    end
    new_value = sequence.last_value + 1
    sequence.update!(:last_value => new_value)
    new_value
  end
end