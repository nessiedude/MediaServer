module TracksHelper
	def self.musicplayer_script(tracks)
		html = []
		html.push('<script>')
		html.push('var player = new MusicPlayer();')
		tracks.each {|track|
			html.push('player.addToPlaylist({title: "')
			html.push(track.title.to_s)
			html.push('", src: "')
			html.push(Rails.application.routes.url_helpers.stream_url(track, :only_path => true))
			html.push('", duration: ')
			html.push(track.duration.to_s)
			html.push('});')
		}
		html.push('</script>')
		html.join.html_safe
	end
end
