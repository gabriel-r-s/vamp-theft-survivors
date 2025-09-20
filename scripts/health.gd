extends Area2D

@export var animation_player: AnimationPlayer

var used := false

func _ready() -> void:
    animation_player.play("bob")

func _on_body_entered(body: Node2D) -> void:
    if used:
        return
    if body is Player:
        body.add_health(1)
        used = true
        queue_free()

