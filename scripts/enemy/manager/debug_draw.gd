extends Node2D

@export var manager: EnemyManager

func _process(_delta: float) -> void:
    queue_redraw()

func _draw() -> void:
    var player_pos := manager.navigation.player_global_pos()
    for point in manager.navigation.points:
        draw_line(point, player_pos, Color.WHITE)
        draw_string(ThemeDB.fallback_font, Vector2(50.0, 50.0), "FPS: %d" % [Engine.get_frames_per_second()])
