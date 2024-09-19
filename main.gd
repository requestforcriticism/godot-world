extends Node

@export var mob_scene: PackedScene
@export var sploder_scene: PackedScene
@export var splosion_scene: PackedScene

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func _on_mob_timer_timeout():
	var mob
	var d10 = randi_range(1, 10)
	if d10 <= 2:
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
	
	var splosion_angle = (2 * PI) / 6
	
	for i in range(6):
		var splosion = splosion_scene.instantiate()
		splosion.position = pos
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		var direction = (i * splosion_angle)
		splosion.linear_velocity = velocity.rotated(direction)
		add_child(splosion)
