extends CharacterBody2D

const MOVE_SPEED := 300.0
const DROP_CHANCE := 0.05
const GUN_ITEM_SCENE := preload("res://pistol/pistol_item.tscn")
const SMOKE_SCENE := preload("res://smoke_explosion/smoke_explosion.tscn")

var health: int = 3

@onready var player: Node2D = get_node("/root/Game/Player")

func _ready() -> void:
	%Slime.play_walk()
	%HealthBar.max_value = health
	%HealthBar.value = health
	%HealthBar.visible = false

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * MOVE_SPEED
	move_and_slide()

func take_damage() -> void:
	health -= 1
	%Slime.play_hurt()
	%HealthBar.value = health
	%HealthBar.visible = true
	
	if health <= 0:
		die()

func die() -> void:
	if randf() < DROP_CHANCE:
		var gun_item = GUN_ITEM_SCENE.instantiate()
		gun_item.global_position = global_position
		get_parent().add_child(gun_item)
	queue_free()
	var smoke = SMOKE_SCENE.instantiate()
	smoke.global_position = global_position
	get_parent().add_child(smoke)
