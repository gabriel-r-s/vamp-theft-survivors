extends Sprite2D

@onready var enemy: Enemy = get_parent()

@export var on_screen: VisibleOnScreenNotifier2D

func _on_screen_exited() -> void:
    set_physics_process(true)
    visible = true

func _on_screen_entered() -> void:
    set_physics_process(false)
    visible = false

func _ready() -> void:
    if not on_screen.is_on_screen():
        _on_screen_exited()

func _physics_process(_delta: float) -> void:
    var viewport_transform := get_viewport().get_canvas_transform()
    var viewport_rect := get_viewport().get_visible_rect()
    var viewport_center := viewport_rect.get_center()

    var enemy_position = viewport_transform * enemy.global_position

    enemy_position = enemy_position.clamp(viewport_rect.position, viewport_rect.end)

    enemy_position += enemy_position.direction_to(viewport_center) * 5.0

    global_position = viewport_transform.affine_inverse() * enemy_position

