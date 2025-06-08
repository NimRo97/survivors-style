extends CharacterBody2D

var health = 100.0

signal health_depleted

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	get_damaged(_delta)

func get_damaged(_delta) -> void:
	
	const DAMAGE_RATE = 10.0
	
	var damaging_enemies = %HurtBox.get_overlapping_bodies().size()
	if damaging_enemies <= 0:
		return
		
	health -= damaging_enemies * DAMAGE_RATE * _delta
	%HealthBar.value = health
	if health <= 0:
		health_depleted.emit()

func _ready() -> void:
	%HealthBar.max_value = health
	%HealthBar.value
