extends Area2D

const ANIM_TIME = 0.3

onready var effect = get_node("effect")
onready var sprite = get_node("sprite")
onready var points = get_node("points")
onready var time = get_node("time")
onready var points_effect = get_node("points/points_effect")
onready var time_effect = get_node("time/time_effect")
onready var spawn_effect = get_node("spawn_effect")

var screensize
var extents
var pos_x
var pos_y

signal coin_collected

func _ready():
	randomize()
	extents = sprite.get_texture().get_size() * sprite.get_scale() / 2 
	screensize = get_viewport().size
	pos_x = rand_range(0 + extents.x, screensize.x - extents.x)
	pos_y = rand_range(0 + extents.y, screensize.y - extents.y)
	var pts_pos = points.get_position()
	var time_pos = time.get_position()
	var vis = Color(1,1,1,1)
	var invis = Color(1,1,1,0)
	
	
	spawn_effect.interpolate_property(self, "position", Vector2(pos_x, pos_y - 100), Vector2(pos_x, pos_y), 
								1, Tween.TRANS_BOUNCE, Tween.EASE_OUT) 
	spawn_effect.start()
	effect.interpolate_property(sprite, "scale", sprite.get_scale(), Vector2(1.5, 1.5), 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	effect.interpolate_property(sprite, "modulate", vis, invis, 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	points_effect.interpolate_property(points, "rect_position", Vector2(pts_pos), Vector2(pts_pos + Vector2(0, -60)), 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	points_effect.interpolate_property(points, "modulate", vis, invis, 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	time_effect.interpolate_property(time, "rect_position", Vector2(time_pos), Vector2(time_pos + Vector2(0, -60)), 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	time_effect.interpolate_property(time, "modulate", vis, invis, 
								ANIM_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _on_coin_area_entered( area ):
	if area.get_name() == "player":
		emit_signal("coin_collected")
		points.set_visible(true)
		time.set_visible(true)
		shape_owner_clear_shapes(0)
		effect.start()
		points_effect.start()
		time_effect.start()

func _on_effect_tween_completed( object, key ):
	queue_free()
