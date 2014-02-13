require 'taglib'

class TracksController < ApplicationController
	
	def show
		@track = Track.find(params[:id])
	end
	
	def index
		@tracks = Track.all.order(:title)
	end
	
	def edit
		@track = Track.find(params[:id])
	end
	
	def update
		@track = Track.find(params[:id])
		
		if @track.update(track_params)
			redirect_to @track
		else
			render 'edit'
		end
	end
	
	private

	def track_params
		params.require(:track).permit(:title, :album_id, :track_no, :artist_id)
	end
end
