extends Node

@export var manager: EnemyManager
@export var enemy_scene: PackedScene

func _on_spawn_timeout() -> void:
    manager.spawner.spawn_enemy(enemy_scene)
