class MusicController < ApplicationController
  def home
	@artists = Artist.all
  end
end
