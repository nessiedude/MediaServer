class AddLocationRefToTrack < ActiveRecord::Migration
  def change
	  add_column :tracks, :root_id, :integer
  end
end
