extends Area2D

const MAX_ROTATION_PER_SECOND = 2 * PI


func _physics_process(delta: float) -> void:
	track_target(delta)


func shoot() -> void:
	const BULLET = preload("res://bullet.tscn")
	var bullet = BULLET.instantiate()
	bullet.global_position = %ShootingPoint.global_position
	bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(bullet)


func _on_timer_timeout() -> void:
	shoot()


func track_target(delta) -> void:
	var enemies_in_range := get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = get_closest(enemies_in_range)
		var angle = get_angle_to(target_enemy.global_position)
		if abs(angle) > MAX_ROTATION_PER_SECOND * delta:
			angle = sign(angle) * MAX_ROTATION_PER_SECOND * delta
		rotation += angle
		%Pistol.flip_v = global_rotation > 0.5 * PI or global_rotation < - 0.5 * PI


func get_closest(enemies: Array) -> Node2D:

	var closest = null
	var min_dist = INF
	
	for enemy in enemies:
		if enemy is Node2D:
			var dist = global_position.distance_to(enemy.global_position)
			if dist < min_dist:
				min_dist = dist
				closest = enemy
	return closest
