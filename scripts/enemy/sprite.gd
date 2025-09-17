extends AnimatedSprite2D

@onready var enemy: Enemy = get_parent()

func _process(_delta: float) -> void:
    if enemy.state == Enemy.State.Shooting:
        flip_h = enemy.player_pos != null \
                and enemy.position.x > enemy.player_pos.x
        play("stop")
    else:
        flip_h = enemy.linear_velocity.x < 0.0
        play("walk")
