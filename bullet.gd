extends Area2D

var total_distance = 0

func _physics_process(delta: float) -> void:
	
	const SPEED = 1000
	const MAX_DISTANCE = 1200
	
	var distance = SPEED * delta
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * distance
	total_distance += distance
	
	if total_distance > MAX_DISTANCE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
