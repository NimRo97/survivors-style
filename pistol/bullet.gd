extends Area2D

const SPEED := 1000
const MAX_DISTANCE := 1200
const IMPACT_SCENE := preload("res://pistol/impact/impact.tscn")

var total_distance: float = 0.0

func _physics_process(delta: float) -> void:
	var distance = SPEED * delta
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * distance
	total_distance += distance
	
	if total_distance > MAX_DISTANCE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	var impact = IMPACT_SCENE.instantiate()
	impact.global_position = global_position
	get_parent().add_child(impact)
	queue_free()
