function MusicPlayer(){
	
	var isInitialised = false;
	var isPlaying = false;
	var playlist = [];
	var currentTrackIndex = -1
	var audio = null;
	var idString = "musicplayer";
	var timeCompleteDiv = null;
	var timeRemainingDiv = null;
	var progressDiv = null;
	var playlistContainer = null;
	
	this.initialise = function(){
		if (isInitialised){return;}
		
		var container = $("#" + idString);
		if (!container || !window.jQuery){return;}
		
		container.append("<div id='musicplayer_playlist'></div><div id='musicplayer_progress'><div id='musicplayer_complete'></div><div id='musicplayer_remaining'></div></div><div class='controls clearfix'><div class='button first' id='musicplayer_sb' style='background-image:url(/assets/gnome_media_skip_backward.png);background-size:100%;'></div><!--<div class='button' id='musicplayer_rw'>Rewind</div>--><div class='button' id='musicplayer_pp' style='background-image:url(/assets/gnome_media_playback_start.png);background-size:100%;'></div><!--<div class='button' id='musicplayer_ff'>FastForward</div>--><div class='button' id='musicplayer_sf' style='background-image:url(/assets/gnome_media_skip_forward.png);background-size:100%;'></div></div>");
	
		audio = new Audio();
		audio.controls = false;
		container.append(audio);
		audio.onended = skipForward;
		audio.onerror = function(){skipForward;};
		audio.onstalled = function(){skipForward;};
		
		timeCompleteDiv = $("#" + idString + "_complete");
		timeRemainingDiv = $("#" + idString + "_remaining");
		progressDiv = $("#" + idString + "_progress");
		playlistContainer = $("#" + idString + "_playlist");
		
		var thisObject = this;
		$("#" + idString + "_pp").on("click",function(){togglePlaying(this)});
		$("#" + idString + "_sf").on("click",skipForward);
		$("#" + idString + "_sb").on("click",skipBackward);

		$(audio).on("timeupdate",updateProgress);
		
		isInitialised = true;
	}

	function updateProgress(){
		var completeWidth = progressDiv.width();
		var duration = playlist[currentTrackIndex].duration ? playlist[currentTrackIndex].duration : audio.duration;
		var currentTime = Math.round((audio.currentTime * completeWidth) / duration);
		var remainingTime = completeWidth - currentTime;

		timeCompleteDiv.width(currentTime + "px");
		timeRemainingDiv.width(remainingTime + "px");

		if (currentTime > completeWidth)
		{
			audio.pause();
			skipForward();
		}
	}
	
	function togglePlaying(button){
		if (isPlaying)
		{
			audio.pause();
			isPlaying = false;
			$(button).css("background-image","url(/assets/gnome_media_playback_start.png)");
		}
		else
		{
			isPlaying = true;
			$(button).css("background-image","url(/assets/gnome_media_playback_pause.png)");
			moveToCurrentIndex();
		}
	}
	this.togglePlaying = togglePlaying;
	
	function skipForward(){
		if (currentTrackIndex >= 0 && currentTrackIndex < playlist.length - 1){
			currentTrackIndex++;
			moveToCurrentIndex();
		}
	}
	this.skipForward = skipForward;
	
	function skipBackward(){
		if (currentTrackIndex > 0){
			currentTrackIndex--;
			moveToCurrentIndex();
		}
	}
	this.skipBackward = skipBackward;
	
	function moveToCurrentIndex(){
		var currentId = "#musicplayer_" + currentTrackIndex;
		$(".playlist_item").not(currentId).slideUp();
		$(currentId).slideDown();
		if (isPlaying){
			audio.src = playlist[currentTrackIndex].src;
			audio.play();
		}
	}
	
	this.addToPlaylist = function(track){
		var load = playlist.length == 0;
		
		if (track instanceof Array){
			for (var i = 0; i < track.length; i++){
				playlist.push(track[i]);
				playlistContainer.append("<div id='musicplayer_" + (playlist.length-1) + "' class='playlist_item'><div class='playlist_inner'>" + track.title + "</div></div>");
			}
		}
		else{
			playlist.push(track);
				playlistContainer.append("<div id='musicplayer_" + (playlist.length-1) + "' class='playlist_item'><div class='playlist_inner'>" + track.title + "</div></div>");
		}
		
		if (load){
			currentTrackIndex = 0;
			moveToCurrentIndex();
		}
	};
	
	this.initialise();
}
