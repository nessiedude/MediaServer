class Track < ActiveRecord::Base
	belongs_to :album
	validates :title, presence: true, length: { minimum: 5 }
end
