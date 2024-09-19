extends Node

@export var mob_scene: PackedScene
@export var sploder_scene: PackedScene
@export var splosion_scene: PackedScene

@export var start_health : int

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over(health):
	$HUD.set_hp(health)
	if health <= 0:
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		$Music.stop()
		$DeathSound.play()
	
func new_game():
	score = 0
	$HUD.set_hp(start_health)
	$Player.start($StartPosition.position, start_health)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout():
	var mob
	var d10 = randi_range(6, 10)
	if d10 <= 4:
		return
	elif d10 <= 8:
		mob = mob_scene.instantiate()
	else:
		mob = sploder_scene.instantiate()
		mob.connect("splode", splode)
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func splode(pos):
	
	var num_balls = randi_range(4, 6)
	var splosion_angle = (2 * PI) / num_balls
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	
	for i in range(num_balls):
		var splosion = splosion_scene.instantiate()
		splosion.position = pos
		var direction = (i * splosion_angle)
		splosion.linear_velocity = velocity.rotated(direction)
		add_child(splosion)
