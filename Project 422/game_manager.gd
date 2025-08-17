#game_manager.gs
extends Node

var audio_generator := AudioStreamGenerator.new()
var audio_playback : AudioStreamGeneratorPlayback
var audio_player := AudioStreamPlayer.new()
var audio_is_beeping := false

# References to scene elements
var current_scene

const GAME_SIZE: Vector2 = Vector2(2048, 2048)



func _ready():
	# When the active scene changes (e.g. changing levels),
	# grab references again
	audio_generator.mix_rate = AudioServer.get_mix_rate()
	audio_generator.buffer_length = 0.1
	add_child(audio_player)
	audio_player.stream =audio_generator
	audio_player.play()
	await get_tree().process_frame
	audio_playback = audio_player.get_stream_playback()
	await get_tree().create_timer(0.5).timeout
	#test bip
	play_bip(440.0,0.15) # 440 Hz, 150 ms


func play_bip(frequency: float, duration: float):
	if audio_is_beeping:
		return
	audio_is_beeping = true
	var sample_rate = audio_generator.mix_rate
	var total_samples = int(duration * sample_rate)
	
	if audio_playback == null:
		return
	# Push the whole tone into the generator buffer, but yield if buffer is full.
	var i : int = 0
	while i < total_samples:
		var space := audio_playback.get_frames_available()
		if space <= 0:
			await get_tree().process_frame
			continue
		var chunk := min(space, total_samples - i) as int
		for j in range(chunk):
			var t := float(i + j) / sample_rate as float
			var s := sin(TAU * frequency * t) * 0.2 as float
			audio_playback.push_frame(Vector2(s, s))
		i += chunk

	# Wait roughly for playback to finish before allowing a new beep
	await get_tree().create_timer(duration, false).timeout
	audio_is_beeping = false
	
	
	


func _logging(_level, msg: String):
	print("Debug: "+msg)
