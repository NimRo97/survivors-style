extends CharacterBody2D

const MOVE_SPEED := 600.0
const DAMAGE_RATE := 10.0
const ITEM_PULL_SPEED := 300.0
const GUN_SCENE := preload("res://pistol/gun.tscn")

var health: float = 100.0

signal health_depleted

func _ready() -> void:
	%HealthBar.max_value = health
	%HealthBar.value = health

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * MOVE_SPEED
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	get_damaged(_delta)
	pick_items(_delta)

func get_damaged(_delta: float) -> void:
	var damaging_enemies = %HurtBox.get_overlapping_bodies().size()
	if damaging_enemies <= 0:
		return
		
	health -= damaging_enemies * DAMAGE_RATE * _delta
	%HealthBar.value = health
	if health <= 0:
		health_depleted.emit()

func pick_items(_delta: float) -> void:
	for item: RigidBody2D in %MagnetBox.get_overlapping_bodies():
		var direction = item.global_position.direction_to(global_position)
		item.move_and_collide(direction * _delta * ITEM_PULL_SPEED)
	
	for item: RigidBody2D in %PickBox.get_overlapping_bodies():
		item.queue_free()
		var new_gun = GUN_SCENE.instantiate()
		new_gun.global_position = global_position
		get_parent().add_child(new_gun)
