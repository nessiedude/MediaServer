class Album < ActiveRecord::Base
	belongs_to :artist
	has_many :tracks
	
	def self.options_for_select
		albums = self.all
		options = albums.sort{|a,b|a.title <=> b.title}.map{|album| [album.title, album.id]}
		options.unshift(["None", nil])
	end
end
