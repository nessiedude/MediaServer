class TracksController < ApplicationController

	def new
	end
	
	def create
		@track = Track.new(track_params)
		@track.save
		redirect_to @track
	end
	
	def show
		@track = Track.find(params[:id])
	end
	
	private
	def track_params
		params.require(:track).permit(:title, :location)
	end
end
