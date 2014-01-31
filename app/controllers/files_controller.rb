require 'taglib'

class FilesController# < ApplicationController
	def gather_all
		locations = Locations.all
		locations.each{|location| gather(location)}
	end
	
	def gather(location)
		if (@tracks.nil?) then
			@tracks = Track.all
		end
		
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
		files.each{|file|
			TagLib::FileRef.open(file) do |fileref|
				unless fileref.null?
					#artist = fileref.tag.artist
					#album = fileref.tag.album
					title = fileref.tag.title
					#trackNo = fileref.tag.track
					new_tracks.push({:title => title, :location => file, :album_id => nil, :root_id => location})

					#music.addTrack(title,trackNo,files[i],album,artist)
					#track = Track.new(title: title, location: file, album_id: nil)
					#if (!track.save) then
					#	@fails.push(file)
					#end
				end
			end
		}
		Track.transaction do
			Track.create(new_tracks)
		end
	end
	
	def discard(location)
		Track.transaction do
			Track.where(:root_id => location.id).destroy_all
		end
	end
	
	private

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
