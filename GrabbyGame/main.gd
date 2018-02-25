extends Node

onready var coin = preload("res://coin.tscn")
onready var enemy = preload("res://enemy.tscn")
onready var coin_container = get_node("coin_container")
onready var enemies = get_node("enemies")
onready var score_label = get_node("HUD/score_label")
onready var time_label = get_node("HUD/time_label")
onready var game_timer = get_node("game_timer")
onready var extents = get_node("player/sprite").get_sprite_frames().get_frame("down", 0).get_size() * get_node("player/sprite").get_scale() / 2
onready var effect = get_node("HUD/game_over/effect")
onready var game_over = get_node("HUD/game_over")
onready var player = get_node("player")
var screensize
var score = 0
var level = 0

func _ready():
	randomize()
	screensize = get_viewport().size
	set_process(true)
	effect.interpolate_property(game_over, "rect_rotation", 0, 360, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	effect.interpolate_property(game_over, "rect_scale", Vector2(1,1), Vector2(10,10), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)

func _process(delta):
	time_label.set_text(str("Time Left: ", int(game_timer.get_time_left())))
	if coin_container.get_child_count() == 0:
		level += 1
		spawn_coins(level)
		spawn_enemies(level - 1)

func spawn_coins(num):
	for i in range(num):
		var c = coin.instance()
		coin_container.add_child(c)
		c.connect("coin_collected", self, "_on_coin_collected")

func spawn_enemies(num):
	for i in range(num):
		var e = enemy.instance()
		enemies.add_child(e)
		e.connect("damage", player, "_on_damage")
		e.connect("damage", self, "_on_damage")
		e.set_position(Vector2(rand_range(extents.x, screensize.x - extents.x),
								rand_range(extents.y, screensize.y - extents.y)))

func _on_game_timer_timeout():
	set_process(false)
	player.set_physics_process(false)
	player.shape_owner_clear_shapes(0)
	effect.start()
	game_over.set_visible(true)
	time_label.set_text(str("Time Left: 0"))
	
func _on_coin_collected():
	score += 10
	score_label.set_text(str("Score: ", score))
	game_timer.set_wait_time(game_timer.get_time_left() + 1.0)
	game_timer.start()

func _on_damage():
	score -= 2
	score_label.set_text(str("Score: ", score))
	var t = game_timer.get_time_left() - 2.0
	if t <=0:
		game_timer.emit_signal("timeout")
	else:
		game_timer.set_wait_time(t)
		game_timer.start()