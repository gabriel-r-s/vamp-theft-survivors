class_name HealthWidget
extends Control

@export var icon_scene: PackedScene
@export var container: HBoxContainer

var health := 0

func add_health() -> void:
    health += 1
    container.add_child(icon_scene.instantiate())

func rm_health() -> void:
    if health == 0:
        return
    health -= 1
    container.remove_child(container.get_child(0))

func set_health(n: int) -> void:
    while health < n:
        add_health()
    while health > n:
        rm_health()
