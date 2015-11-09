class UniqueMpvSeq < ActiveRecord::Base
  self.table_name = 'unique_mpv_seq'

  def self.last
    self.sequence.last_value
  end

  def self.update_last(value)
    self.sequence.update!(:last_value => value)
  end

  def self.next
    new_value = last + 1
    update_last(new_value)
    new_value
  end

  private
  def self.sequence
    if UniqueMpvSeq.first
      UniqueMpvSeq.first
    else
      UniqueMpvSeq.create(:last_value => 0)
    end
  end
end