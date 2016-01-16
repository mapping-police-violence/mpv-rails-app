class AddNeedsReviewFlag < ActiveRecord::Migration
  def change
    add_column :incidents, :needs_review, :boolean
  end
end
