class AddTrackNoToTrack < ActiveRecord::Migration
  def change
	  add_column :tracks, :track_no, :integer
  end
end
