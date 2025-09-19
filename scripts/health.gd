extends Area2D

var used := false

func _on_body_entered(body: Node2D) -> void:
    if used:
        return
    if body is Player:
        if body.health < body.max_health:
            body.add_health(1)
            used = true
            queue_free()

