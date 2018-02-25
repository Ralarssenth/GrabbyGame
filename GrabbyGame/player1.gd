extends Area2D

export var speed = 500

var screensize
var extents
var vel = Vector2()

onready var slow = get_node("slow")
onready var sprite = get_node("sprite")

func _ready():
	set_physics_process(true)
	screensize = get_viewport().size
	extents = sprite.get_sprite_frames().get_frame("down", 0).get_size() * sprite.get_scale() / 2 
	set_position(screensize / 2)

func _physics_process(delta):
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	vel = input.normalized() * speed
	var pos = get_position() + vel * delta
	pos.x = clamp(pos.x, extents.x, screensize.x - extents.x)
	pos.y = clamp(pos.y, extents.y, screensize.y - extents.y)
	set_position(pos)
	if vel == Vector2(0, 0):
		sprite.set_animation("down")
		sprite._set_playing(false)
	elif vel.x > 0 and vel.y == 0:
		sprite.set_animation("left_right")
		sprite.set_flip_h(false)
		sprite._set_playing(true)
	elif vel.x < 0 and vel.y == 0:
		sprite.set_animation("left_right")
		sprite.set_flip_h(true)
		sprite._set_playing(true)
	elif vel.y < 0:
		sprite.set_animation("up")
		sprite._set_playing(true)
	elif vel.y > 0:
		sprite.set_animation("down")
		sprite._set_playing(true)
	
func _on_damage():
	slow.interpolate_property(self, "speed", 0, 500, 1.5, Tween.TRANS_SINE, Tween.EASE_IN)
	slow.start()

