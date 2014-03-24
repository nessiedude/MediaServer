class Track < ActiveRecord::Base
	belongs_to :album
	belongs_to :root
	belongs_to :artist
end
