class AlbumsController < ApplicationController
	def index
		@albums = Album.all
	end
	
	def new
		@album = Album.new
		@artists = Artist.all
	end
	
	def create
		@album = Album.new(album_params)
		if @album.save
			redirect_to action: "index"
		else
			render 'new'
		end
	end
	
	private
	def album_params
		params.require(:album).permit(:title, :artist_id)
	end
end
