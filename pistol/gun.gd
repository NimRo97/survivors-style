extends Area2D

const MAX_ROTATION_PER_SECOND = 2 * PI


func _physics_process(delta: float) -> void:
	track_target(delta)


func shoot() -> void:
	var bullet = preload("res://pistol/bullet.tscn").instantiate()
	bullet.global_position = %ShootingPoint.global_position
	bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(bullet)
	
	var flash = preload("res://pistol/muzzle_flash/muzzle_flash.tscn").instantiate()
	%ShootingPoint.add_child(flash)


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
		if global_rotation > 0.5 * PI or global_rotation < - 0.5 * PI:
			%Pistol.scale.y = -1
		else:
			%Pistol.scale.y = 1


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
