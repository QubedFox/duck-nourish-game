extends Node

@export var projectile_scene: PackedScene
@export var duckling_scene: PackedScene

var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_game():
	$Player.start($StartPosition.position)
	score = 0
	$DucklingTimer.wait_time = 2
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	#await $HUD/MessageTimer.timeout
	$DucklingTimer.start()
	$WaveTimer.start()
	$HUD/NoAIWatermark.hide()


func game_over():
	$DucklingTimer.stop()
	$WaveTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("ducklings", "queue_free")



func _on_duckling_timer_timeout() -> void:
	var duckling = duckling_scene.instantiate()
	
	var duckling_spawn_location = $DucklingPath/DucklingSpawnLocation
	duckling_spawn_location.progress_ratio = randf()

	duckling.position = duckling_spawn_location.position
	duckling.connect("fed", _on_point_scored)
	duckling.connect("hit_ground", game_over)
	add_child(duckling)


func _on_point_scored() -> void:
	print_debug("point scored")
	score += 1
	$HUD.update_score(score)


func _on_wave_timer_timeout() -> void:
	if $DucklingTimer.wait_time >= 1:
		$DucklingTimer.wait_time -= 0.25
