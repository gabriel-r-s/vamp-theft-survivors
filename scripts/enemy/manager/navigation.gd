class_name EnemyManagerNavigation
extends Node

@export_group("Config")
@export var min_choose_dist := 150.0
@export var max_choose_dist := 250.0
@export var min_choose_angle := deg_to_rad(1.0)
@export var max_choose_angle := deg_to_rad(10.0)
@export var num_choose_points := 8

@export_group("Scene")
@export var find_player_timer: Timer
@export var raycast: RayCast2D

var player: Node2D = null
var points: Array[Vector2] = []

func _ready() -> void:
    var parent := get_parent()
    parent.ready.connect(_on_parent_ready.bind(parent))

func _on_parent_ready(parent: Node) -> void:
    player = parent.player
    find_player_timer.timeout.connect(find_player)

func player_global_pos() -> Vector2:
    return player.global_position

func random_point() -> Vector2:
    return points.pick_random()

func point_can_see_player(point: Vector2) -> bool:
    raycast.global_position = point
    raycast.target_position = player_global_pos() - point
    raycast.force_raycast_update()
    return raycast.is_colliding() and raycast.get_collider() == player

func find_player() -> void:
    # escolher `num_choose_points` pontos ao redor do player,
    # manter apenas os que enxergam o player
    points.clear()
    var angle := 0.0
    var delta_angle := 2.0 * PI / float(num_choose_points)

    for i in num_choose_points:
        var player_pos := player_global_pos()
        var dist := randf_range(min_choose_dist, max_choose_dist)
        var offset := randf_range(min_choose_angle, max_choose_angle)
        var point := player_pos + dist*Vector2(cos(angle + offset), sin(angle + offset))
        if point_can_see_player(point):
            points.push_back(point)
        angle += delta_angle

        await get_tree().physics_frame

    # se nenhum enxerga o player, escolhe a própria
    # posição do player como fallback
    if points.is_empty():
        points.push_back(player_global_pos())
