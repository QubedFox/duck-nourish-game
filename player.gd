extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var projectile_scene: PackedScene

var screen_size # Size of the game window.
var can_shoot = true

var projectile_start_pos_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	projectile_start_pos_offset = $ProjectileStartPosition.position
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProjectileStartPosition.position = position + projectile_start_pos_offset
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move-left"):
		velocity.x -= 1
		$AnimatedSprite2D.flip_h = true
		projectile_start_pos_offset.x = abs(projectile_start_pos_offset.x) * -1
	elif Input.is_action_pressed("move-right"):
		velocity.x += 1
		$AnimatedSprite2D.flip_h = false
		projectile_start_pos_offset.x = abs(projectile_start_pos_offset.x)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("standing")

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if Input.is_action_pressed("shoot"):
		if can_shoot:
			#$ShootTimer.start()
			can_shoot = false
			var projectile = projectile_scene.instantiate()
			projectile.position = $ProjectileStartPosition.position
			get_parent().add_child(projectile)
	else:
		can_shoot = true

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_timer_timeout() -> void:
	can_shoot = true
