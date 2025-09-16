extends Node

@export var manager: EnemyManager

@export var gangster_scene: PackedScene
@export var police_scene: PackedScene
@export var swat_scene: PackedScene
@export var army_scene: PackedScene

@onready var scenes = [gangster_scene, police_scene, swat_scene, army_scene]

func _on_spawn_timeout() -> void:
    var scene: PackedScene = scenes.pick_random()
    assert(scene != null)
    manager.spawner.spawn_enemy(scene)
