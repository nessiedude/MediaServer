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
	
	this.initialise = function(){
		if (isInitialised){return;}
		
		var container = $("#" + idString);
		if (!container || !window.jQuery){return;}
		
		container.append("<div id='musicplayer_progress'><div id='musicplayer_complete'></div><div id='musicplayer_remaining'></div></div><div class='controls clearfix'><div class='button' id='musicplayer_sb'>SkipBackward</div><!--<div class='button' id='musicplayer_rw'>Rewind</div>--><div class='button' id='musicplayer_pp'>Play</div><!--<div class='button' id='musicplayer_ff'>FastForward</div>--><div class='button' id='musicplayer_sf'>SkipForward</div></div>");
	
		audio = new Audio();
		audio.controls = false;
		container.append(audio);
		
		timeCompleteDiv = $("#" + idString + "_complete");
		timeRemainingDiv = $("#" + idString + "_remaining");
		progressDiv = $("#" + idString + "_progress");
		
		var thisObject = this;
		$("#" + idString + "_pp").on("click",function(){togglePlaying(this)});
		$("#" + idString + "_sf").on("click",skipForward);
		$("#" + idString + "_sb").on("click",skipBackward);
		//document.getElementById(idString + "_pp").onclick = function(){togglePlaying(this);};
		//document.getElementById(idString + "_sf").onclick = skipForward;
		//document.getElementById(idString + "_sb").onclick = skipBackward;
		$(audio).on("ended error stalled",skipForward);
		$(audio).on("timeupdate",updateProgress);
		//audio.onended = audio.onerror = audio.onstalled = skipForward;
		//audio.ontimeupdate = updateProgress;
		
		isInitialised = true;
	}

	function updateProgress(){
		var completeWidth = progressDiv.width();
		var duration = playlist[currentTrackIndex].duration ? playlist[currentTrackIndex].duration : audio.duration;
		var currentTime = Math.round((audio.currentTime * completeWidth) / duration);
		var remainingTime = completeWidth - currentTime;

		timeCompleteDiv.width(currentTime + "px");
		timeRemainingDiv.width(remainingTime + "px");
	}
	
	function togglePlaying(button){
		if (isPlaying)
		{
			audio.pause();
			isPlaying = false;
			button.innerHTML = "Play";
		}
		else
		{
			audio.play();
			isPlaying = true;
			button.innerHTML = "Pause";
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
		audio.src = playlist[currentTrackIndex].src;
		audio.load;
		if (isPlaying){
			audio.play();
		}
	}
	
	this.addToPlaylist = function(track){
		var load = playlist.length == 0;
		
		if (track instanceof Array){
			for (var i = 0; i < track.length; i++){
				playlist.push(track[i]);
			}
		}
		else{
			playlist.push(track);
		}
		
		if (load){
			audio.src = track.src;
			audio.load();
			currentTrackIndex = 0;
		}
	};
	
	this.initialise();
}
