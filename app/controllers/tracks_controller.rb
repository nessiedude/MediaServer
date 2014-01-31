require 'taglib'

class TracksController < ApplicationController

	def new
		@track = Track.new
	end
	
	def create
		@track = Track.new(track_params)
		if @track.save
			redirect_to @track
		else
			render 'new'
		end
	end
	
	def show
		@track = Track.find(params[:id])
	end
	
	def index
		@tracks = Track.all
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
	
	def destroy
		@track = Track.find(params[:id])
		@track.destroy
		
		redirect_to tracks_path
	end
	
	private

	def track_params
		params.require(:track).permit(:title, :location, :album_id)
	end
end
