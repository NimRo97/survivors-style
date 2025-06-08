extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()
	%HealthBar.max_value = health
	%HealthBar.value = health
	%HealthBar.visible = false

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	%HealthBar.value = health
	%HealthBar.visible = true
	
	if health <= 0:
		die()

func die():
	if (randf() < 0.05):
		var gun_item = preload("res://pistol/pistol_item.tscn").instantiate()
		gun_item.global_position = global_position
		get_parent().add_child(gun_item)
	queue_free()
	const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE.instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)
