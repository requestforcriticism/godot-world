extends Area2D

signal hit

@export var speed = 400
var screen_size

var health = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if velocity.length() > 0:
		velocity *= speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	health -= 1
	hit.emit(health)
	
	if(health <= 0):
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos, hp):
	position = pos
	health = hp
	show()
	$CollisionShape2D.disabled = false
