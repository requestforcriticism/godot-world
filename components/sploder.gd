extends RigidBody2D

signal splode

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("fly")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

#freeze
func _on_timer_timeout():
	linear_velocity = Vector2.ZERO
	$SplodeTimer.start()

func _splode():
	splode.emit(position)
	queue_free()
	pass
