extends Sprite2D

@onready var player: Player = get_parent()

func _physics_process(_delta: float) -> void:
    if not player.is_moving:
        visible = false
        return

    visible = true
    global_position = player.move_pos

