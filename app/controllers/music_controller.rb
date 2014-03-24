class MusicController < ApplicationController
  def home
	@artists = Artist.all
	@locations = Location.all
	@new_location = Location.new
  end
end
