class AddDurationToTrack < ActiveRecord::Migration
  def change
	add_column :tracks, :duration, :integer
  end
end
