extends Area2D

var rng = RandomNumberGenerator.new()

var falling_speed = 100
var exit_speed = 250
var acceleration = 8.5
var is_hit = false

var exit_direction = 0

var directions = [-1, 1]
var dir_weights = [1, 1]

signal fed
signal hit_ground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_direction = directions[rng.rand_weighted(dir_weights)]
	if exit_direction == 1:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_hit == true:
		position += transform.x * exit_speed * delta * exit_direction
	else:
		position += transform.y * falling_speed * delta
		falling_speed += acceleration

	if position.y >= 650:
		emit_signal("hit_ground")


func _on_area_entered(area: Area2D) -> void:
	if is_hit == false:
		emit_signal("fed")
		print_debug("hit")
		is_hit = true
		set_collision_mask_value(1, false)
		set_collision_layer_value(1, false)
		$Sprite2D.hide()
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play("default")
		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
