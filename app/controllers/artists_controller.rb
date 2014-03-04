class ArtistsController < ApplicationController

	def index
		@artists = Artist.includes(:albums).where("albums.artist_id IS NOT NULL")
	end
	
	def data
		if (params[:mode] == "album") then
			@artists = Artist.includes(:albums).where("albums.artist_id IS NOT NULL")
		elsif (params[:mode] == "track") then
			@artists = Artist.includes(:tracks).where("tracks.artist_id IS NOT NULL")
		else
			@artists = Artist.all
		end
		#render text: params[:mode]
		#render action: "data.js.erb", layout: false, content_type: "text/javascript"
		#render json: @artists

		render :json => @artists.to_json(only: [:id, :name])
	end

	def new
		@artist = Artist.new
	end
	
	def show
		@artist = Artist.find(params[:id])
	end
	
	def edit
		@artist = Artist.find(params[:id])
	end
	
	def update
		@artist = Artist.find(params[:id])
		
		if (@artist.update(artist_params))
			redirect_to @artist
		else
			render 'edit'
		end
			
	end
	
	def create
		@artist = Artist.new(artist_params)
		if @artist.save
			redirect_to artists_path
		else
			render 'new'
		end
	end
	
	def destroy
		@artist = Artist.find(params[:id])
		@artist.albums.each{|album|
			album.artist_id = nil
			album.save
		}
		@artist.destroy
		
		redirect_to artists_path
	end
	
	private
	def artist_params
		params.require(:artist).permit(:name)
	end
end
