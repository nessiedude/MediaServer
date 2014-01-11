class TracksController < ApplicationController

	def new
	end
	
	def create
		render text: params[:track].inspect
	end
end
