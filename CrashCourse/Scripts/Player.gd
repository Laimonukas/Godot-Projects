extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var HEALTH_POINTS = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum baseStates {inAir, grounded}
enum airMoveStates {jump, fall}
enum groundMoveStates {run, idle, crouch}
@onready var sprite = $AnimatedSprite2D
@onready var label = $Camera2D/UI/Label
var baseState = baseStates.grounded
var hurt = false

func _ready():
	label.text = "HP: " + str(HEALTH_POINTS)

func _physics_process(delta):
	var airState
	var runState
	var isCrouched = false
	
	if HEALTH_POINTS <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://Maps/Main.tscn")
		return
		
	if not is_on_floor():
		baseState = baseStates.inAir
		velocity.y += gravity * delta
	else:
		baseState = baseStates.grounded
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if baseState == baseStates.inAir:
		if velocity.y < 0:
			airState = airMoveStates.jump
		else:
			airState = airMoveStates.fall
	else:
		if velocity.x == 0:
			runState = groundMoveStates.idle
		else:
			runState = groundMoveStates.run
			if isCrouched:
				runState = groundMoveStates.crouch
		
		
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	if hurt == true:
		return
		
	match baseState:
		baseStates.inAir:
			match airState:
				airMoveStates.jump:
					sprite.play("jump")
				airMoveStates.fall:
					sprite.play("fall")
		baseStates.grounded:
			match runState:
				groundMoveStates.idle:
					sprite.play("idle")
				groundMoveStates.run:
					sprite.play("run")
				groundMoveStates.crouch:
					sprite.play("crouch")
	
	
	
func TakeDamage():
	if !hurt:
		HEALTH_POINTS -= 1

		label.text = "HP: " + str(HEALTH_POINTS)
		hurt = true
		sprite.play("death")
		await sprite.animation_finished
		hurt = false

	
