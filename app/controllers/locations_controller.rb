require 'taglib'

class LocationsController < ApplicationController
	def self.create(folder_location)
		location = Location.new(location: folder_location)
		location.location.gsub! "\\", "/"
		
		if location.save then
			locations_helper = LocationsController.new
			locations_helper.gather(location)
		end
	end

	def self.remove(location_id)
		location = Location.find(location_id)
		
		if (!location.nil?) then
			locations_helper = LocationsController.new
			locations_helper.discard(location)
			location.destroy
		end
	end

	def self.display
		locations = Location.all
		locations.each do |location|
			puts "Id: " + location.id.to_s + " Location: " + location.location
		end
	end

	def gather_all
		locations = Locations.all
		locations.each{|location| gather(location)}
	end
	
	def gather(location)
		if (@tracks.nil?) then
			@tracks = Track.all
		end
		
		if (@albums.nil?) then
			@albums = Album.all
		end
		
		if (@artists.nil?) then
			@artists = Artist.all
		end
		
		albums_to_update = []
		
		root = location.location
		
		found_files = getFiles(root)
		
		files = []
		found_files.each{|file|
			downFile = file.downcase
			index = @tracks.index{|track| track.location.downcase == downFile}
			if (index.nil?) then
				files.push(file)
			else
				@tracks.delete_at(index)
			end
		}
		
		new_tracks = []
		new_albums = []
		new_artists = []
		
		files.each do |file|
			TagLib::FileRef.open(file) do |fileref|
				unless fileref.null?
					artistName = fileref.tag.artist
					albumTitle = fileref.tag.album
					title = fileref.tag.title
					trackNo = fileref.tag.track
					
					artist, existingArtist = get_artist artistName
					
					if (!existingArtist && !artist.nil?) then
						new_artists.push artist
					end
					
					album, existingAlbum = get_album albumTitle, artist
					
					if (existingAlbum && !albums_to_update.include?(album)) then
						albums_to_update.push(album)
					elsif (!existingAlbum && !album.nil?) then
						new_albums.push album
					end
					
					if (title.nil? || title.strip == "") then
						title = File.basename(file,".*")
					end
					
					new_tracks.push({:title => title, :location => file, :album => album, :root_id => location.id, :track_no => trackNo, :artist => artist})
				end
			end
		end
		
		Artist.transaction do
			new_artists.each do |artist|
				artist.save
			end
		end
		
		Album.transaction do
			new_albums.each do |album|
				album.save
			end
		end
		
		Track.transaction do
			Track.create(new_tracks)
		end
		
		update_album_artist albums_to_update
	end
	
	def discard(location)
		Track.transaction do
			Track.where(:root_id => location.id).destroy_all
		end
		
		Album.transaction do
			albums = Album.includes(:tracks)
			albums.each do |album|
				if (album.tracks.length == 0) then
					album.destroy
				end
			end
		end
		
		Artist.transaction do
			artists = Artist.includes(:tracks,:albums)
			artists.each do |artist|
				if (artist.tracks.length == 0 && artist.albums.length == 0) then
					artist.destroy
				end
			end
		end
	end
	
	private
	def get_artist(artistName)
		artist = nil
		existing = false
		
		if (!artistName.nil? && artistName.strip != "") then
			artistName.strip!
			artistNameLower = artistName.downcase
			artistIndex = @artists.find_index{|artist|artist.name.downcase == artistNameLower}
			
			if (artistIndex.nil?) then
				artist = Artist.new({:name => artistName })
				if (!artist.valid?) then
					artist = nil
				else
					@artists.push(artist)
				end
			else
				artist = @artists[artistIndex]
				existing = true
			end
		end
		
		[artist, existing]
	end
	
	def get_album(albumTitle, artist)
		album = nil
		existing = false
		
		if (!albumTitle.nil? && albumTitle.strip != "") then
			albumTitle.strip!
			albumTitleLower = albumTitle.downcase
			albumIndex = @albums.find_index{|album|album.title.downcase == albumTitleLower}
			
			if (albumIndex.nil?) then
				album = Album.new({:title => albumTitle, :artist => artist})
				if (!album.valid?) then
					album = nil
				else
					@albums.push(album)
				end
			else
				album = @albums[albumIndex]
				existing = true
			end
		end
		
		[album, existing]
	end
	
	def update_album_artist(albums_to_update)
		various_artist, existing = get_artist "Various"
		unknown_artist, existing = get_artist "Unknown"
		update_albums = []
		update_tracks = []
		
		albums_to_update.each do |album|
			albumArtist = album.artist
			if (albumArtist.nil?) then
				albumArtist = unknown_artist
				album.artist = unknown_artist
			end
			
			tracks = album.tracks
			
			artists = tracks.map{|track|track.artist}
			
			matching = true
			prev = nil
			
			artists.each do |artist|
				if (!artist.nil?) then
					if (!prev.nil? && artist.name != prev) then
						matching = false
					end
					
					prev = artist.name
				end
			end
			
			if (!matching && albumArtist.name != "Various") then
				album.artist = various_artist
				update_albums.push album
			end
			
			if (matching) then
				album.tracks.each do |track|
					if (track.artist.nil? || track.artist == unknown_artist) then
						track.artist = album.artist
						update_tracks.push track
					end
				end
			end
		end
		
		Album.transaction do
			update_albums.each{|album| album.save}
		end

		Track.transaction do
			update_tracks.each{|track| track.save}
		end
	end
	@@unrecognisedFileExtensions = {}
	@@fileExtensions = [".mp3",".wma",".wav"]

	def getFiles(folder)
		entries = Dir.entries(folder).reject{|entry| entry == "." || entry == ".."}
		files = []
	
		entries.each{|entry|
			place = folder + "/" + entry
			if (File.exists?(place)) then
				if (File.directory?(place)) then
					begin
						result = getFiles(place)
						if (result.nil?) then
							puts "failed on " + place
							gets
						else
							files.concat(getFiles(place))
						end
					rescue Exception => e
						return nil
					end
				elsif (@@fileExtensions.include?(File.extname(place).downcase))
					files.push(place)
				else
					fileExt = File.extname(place).downcase
					if (@@unrecognisedFileExtensions.has_key?(fileExt)) then
						@@unrecognisedFileExtensions[fileExt] += 1
					else
						@@unrecognisedFileExtensions[fileExt] = 1
					end
				end
			end
		}
	
		return files
	end
end
