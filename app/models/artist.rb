class Artist < ActiveRecord::Base
	has_many :albums
	
	def self.options_for_select
		artists = self.all
		options = artists.sort{|a,b|a.name <=> b.name}.map{|artist| [artist.name, artist.id]}
		options.unshift(["None", nil])
	end
end
