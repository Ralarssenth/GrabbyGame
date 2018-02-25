extends Area2D

onready var sprite = get_node("sprite")
onready var move_tween = get_node("move_tween")
onready var points = get_node("points")
onready var time = get_node("time")
onready var points_effect = get_node("points/points_effect")
onready var time_effect = get_node("time/time_effect")
var screensize
var extents
var tile_size = 40
var can_move = true
var facing  = 'right'
var moves = {'right': Vector2(1, 0),
			'left': Vector2(-1, 0),
			'up': Vector2(0, -1),
			'down': Vector2(0, 1)}

signal damage

func _ready():
	randomize()
	screensize = get_viewport().size
	extents = sprite.get_sprite_frames().get_frame("horizontal", 0).get_size() * sprite.get_scale() / 2
	facing = moves.keys()[randi() % 4]	
	points_effect.interpolate_property(points, "rect_position", Vector2(points.get_position()), Vector2(points.get_position() + Vector2(0, -60)), 
									0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	points_effect.interpolate_property(points, "modulate", Color(1,1,1,1), Color(1,1,1,0), 
									0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	time_effect.interpolate_property(time, "rect_position", Vector2(time.get_position()), Vector2(time.get_position() + Vector2(0, -60)), 
									0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	time_effect.interpolate_property(time, "modulate", Color(1,1,1,1), Color(1,1,1,0), 
									0.3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _process(delta):
	if can_move:
		move(facing)
		facing = moves.keys()[randi() % 4]

func move(dir):
	facing = dir
	can_move = false
	var end = position + moves[facing] * tile_size
	end.x = clamp(end.x, extents.x, screensize.x - extents.x)
	end.y = clamp(end.y, extents.y, screensize.y - extents.y)
	move_tween.interpolate_property(self, "position", position, end,
									0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	move_tween.start()
	if facing == "left":
		sprite.set_flip_h(true)
	elif facing == "right":
		sprite.set_flip_h(false)
	return true

func _on_move_tween_tween_completed( object, key ):
	can_move = true

func _on_enemy_area_entered( area ):
	if area.get_name() == "player":
		emit_signal("damage")
		points.set_visible(true)
		time.set_visible(true)
		shape_owner_clear_shapes(0)
		points_effect.start()
		time_effect.start()

func _on_points_effect_tween_completed( object, key ):
		queue_free()
