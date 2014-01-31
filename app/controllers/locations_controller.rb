class LocationsController < ApplicationController
	def create
		location = Location.new(location_params)
		
		if location.save then
			files_controller = FilesController.new
			files_controller.gather(location)
		end
		
		redirect_to root_path
	end
	
	def destroy
		@location = Location.find(params[:id])
		@location.destroy
		
		files_controller = FilesController.new
		files_controller.discard(@location)
		
		redirect_to root_path
	end
	
	private
	def location_params
		params.require(:location).permit(:location)
	end
end
