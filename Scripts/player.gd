extends CharacterBody2D
@onready var sleep: Timer = $"../sleep"
@onready var timer: Timer = $"../UI/Timer"
@onready var umbrellaSound: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var deathSound: AudioStreamPlayer = $AudioStreamPlayer
@export var deadP : PackedScene
@onready var player: AnimatedSprite2D = $player
@export var umbrellas: int
var falling = false
var canSleep = false
var SPEED = 500.0
var alr_win = false
var canmove = true
var alreadyDead = false
var timer_allowed = true
var freeze = false
var JUMP_VELOCITY = -500.0
var gravity = Vector2(980, 980)
var canPlayMusic = true
func _ready() -> void:
	timer.start(0.5)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if $"../UI/CanvasLayer/ProgressBar".value == 100:
		$"../rain".emitting = true
		get_tree().reload_current_scene()
	if timer_allowed:
		if !freeze:
			if timer.time_left <= 0.1:
				timer.start(0.7)
				$"../UI/CanvasLayer/ProgressBar".value += 1
	if not is_on_floor():
		
		velocity += gravity * delta
	$"../UI/CanvasLayer/RichTextLabel".text = "Umbrellas: " + str(umbrellas)
	if $"../rain".emitting == true and alr_win:
		alr_win = false
		$"../AudioStreamPlayer2D".playing = true
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	if canmove == true:
		
		if direction != 0:
			velocity.x = direction * SPEED
			if !falling:
				player.play("runRight")
				player.scale.x = direction * 5
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			if is_on_floor() and canSleep == false:
				player.play("idle")
	else:
		direction = 0
	# MIRROR SPRITE FOR PLAYER
	if direction == -1:
		player.scale.x = -5
	if direction == 1:
		player.scale.x = 5
	if umbrellas >= 1:
		if is_on_floor() and freeze == false:
			falling = false
			gravity = Vector2(980, 980)
		if velocity.y >= 70 and Input.is_action_pressed("plane"):
			if direction == 1 and freeze == false:
				falling = true
				gravity = Vector2(980, 100)
				player.play("falling")
				player.offset.y + 50
			if direction == -1 and freeze == false:
				player.scale.x = -5
				falling = true
				gravity = Vector2(980, 100)
				player.play("falling")
				player.offset.y + 50
	if canmove:
		move_and_slide()
func _on_col_body_entered(body: CharacterBody2D) -> void:
	umbrellas += 1
	$"../umbrella".play("pickup")
	$"../umbrella".queue_free()
	umbrellaSound.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if alreadyDead == false:
		alreadyDead = true
		var _part : GPUParticles2D = deadP.instantiate()
		canmove = false
		player.pause()
		var camera_pos = player.position
		SPEED = 0
		JUMP_VELOCITY = 0
		freeze = true
		$Camera2D.position = camera_pos
		await get_tree().create_timer(0.1).timeout
		var zoomT = create_tween()
		canmove = false
		zoomT.tween_property($Camera2D, "zoom", Vector2(1.7, 1.7), 0.3)
		await get_tree().create_timer(0.3).timeout
		_part.z_index = 999999999999999
		canmove = false
		player.play("idle")
		player.pause()
		canmove = false
		player.z_index = -99
		$AudioStreamPlayer.play()
		_part.position = player.global_position
		_part.emitting = true
		player.pause()
		get_tree().current_scene.add_child(_part)
		await get_tree().create_timer(1.5).timeout
		get_tree().reload_current_scene()


func _on_trampoline_body_entered(body: Node2D) -> void:
	$"../trampoline/AnimatedSprite2D".play("default")
	gravity = Vector2(980, 980)
	velocity.y = -1000

func _on_die_in_void_body_entered(body: Node2D) -> void:
	if alreadyDead == false:
		alreadyDead = true
		var _part : GPUParticles2D = deadP.instantiate()
		canmove = false
		player.pause()
		var camera_pos = player.position
		SPEED = 0
		JUMP_VELOCITY = 0
		freeze = true
		$Camera2D.position = camera_pos
		await get_tree().create_timer(0.1).timeout
		var zoomT = create_tween()
		canmove = false
		zoomT.tween_property($Camera2D, "zoom", Vector2(1.7, 1.7), 0.3)
		await get_tree().create_timer(0.3).timeout
		_part.z_index = 999999999999999
		canmove = false
		player.play("idle")
		player.pause()
		canmove = false
		player.z_index = -99
		$AudioStreamPlayer.play()
		_part.position = player.global_position
		_part.emitting = true
		player.pause()
		get_tree().current_scene.add_child(_part)
		await get_tree().create_timer(1.5).timeout
		get_tree().reload_current_scene()

func _on_col2_body_entered(body: Node2D) -> void:
	umbrellas += 1
	$"../umbrella2".play("pickup")
	$"../umbrella2".queue_free()
	umbrellaSound.play()
func _on_col3_body_entered(body: Node2D) -> void:
	umbrellas += 1
	$"../umbrella3".play("pickup")
	$"../umbrella3".queue_free()
	umbrellaSound.play()

func _on_lock_camera_limit_body_entered(body: Node2D) -> void:
	$Camera2D.limit_left = 5120


func _on_trampoline_2_body_entered(body: Node2D) -> void:
	$"../trampoline2/AnimatedSprite2D".play("default")
	gravity = Vector2(980, 980)
	velocity.y = -1000


func _on_trampoline_3_body_entered(body: Node2D) -> void:
	$"../trampoline3/AnimatedSprite2D".play("default")
	gravity = Vector2(980, 980)
	velocity.y = -1000
