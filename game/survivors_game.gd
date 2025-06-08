extends Node2D

const MOB_SCENE := preload("res://characters/mob.tscn")

func _ready() -> void:
	for i in range(5):
		spawn_mob()

func _on_timer_timeout() -> void:
	spawn_mob()

func spawn_mob() -> void:
	%SpawnPoint.progress_ratio = randf()
	var new_mob = MOB_SCENE.instantiate()
	new_mob.global_position = %SpawnPoint.global_position
	add_child(new_mob)


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
