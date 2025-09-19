class_name EnemyManagerStars
extends Node

@onready var manager: EnemyManager = get_parent()

@export var stars_widget: Stars

@export var enemy_scenes: Array[PackedScene] = []

@export var probabilities := [
    [1.0, 0.0, 0.0, 0.0], # 0 estrela: 100% gangster
    [0.0, 1.0, 0.0, 0.0], # 1 estrela: 100% policia
    [0.0, 1.0, 0.0, 0.0], # 2 estrela: 100% policia
    [0.0, 0.5, 0.5, 0.0], # 3 estrela: 50% policia, 50% swat
    [0.0, 0.3, 0.7, 0.0], # 4 estrela: 30% policia, 70% swat
    [0.0, 0.2, 0.8, 0.0], # 5 estrela: 20% policia, 80% swat
    [0.0, 0.2, 0.2, 0.6], # 6 estrela: 20% policia, 20% swat, 60% soldado
]

@export var budgets := [
     7, # 0 estrela: 7 inimigos
    12, # 1 estrela: 12 inimigos
    24, # 2 estrela: 24 inimigos
    30, # 3 estrela: 30 inimigos
    36, # 4 estrela: 36 inimigos
    45, # 5 estrela: 45 inimigos
    60, # 6 estrela: 60 inimigos
]

@export var spawn_points_node: Node

var spawn_points: Array[Vector2] = []

var stars := 0
var num_enemies := 0

func _ready() -> void:
    for child in spawn_points_node.get_children():
        var marker: Marker2D = child
        spawn_points.push_back(marker.global_position)

func _on_enemy_die() -> void:
    num_enemies -= 1

func set_stars(n: int) -> void:
    stars_widget.stop_flashing()
    stars_widget.set_stars(n)
    stars = n

func set_stars_flashing() -> void:
    stars_widget.start_flashing()
    stars = -1

func can_spawn_at(point: Vector2) -> bool:
    return point.distance_to(manager.player.global_position) > 50.0

func pick_weighted(prob: Array) -> int:
    var r := randf()
    var cum := 0.0
    for i in prob.size():
        if r <= prob[i] + cum:
            return i
        cum += prob[i]
    return prob.back()

func pick_point() -> Vector2:
    for i in 16:
        var point: Vector2 = spawn_points.pick_random()
        if can_spawn_at(point):
            return point

    # caso nao conseguir spawnar em nenhum ponto, escolhe
    # algum lugar em volta do player mesmo
    var random_offset := Vector2.RIGHT * randf_range(50.0, 80.0)
    random_offset = random_offset.rotated(randf_range(0.0, 2.0 * PI))

    return manager.player.global_position + random_offset

func _timer_tick() -> void:
    if stars < 0:
        return
    if num_enemies < budgets[stars] and randf() < 0.25:
        var enemy_scene: PackedScene = enemy_scenes[pick_weighted(probabilities[stars])]
        var enemy_pos := pick_point()
        var enemy := manager.spawner.spawn_enemy(enemy_scene, enemy_pos)
        enemy.die.connect(_on_enemy_die)
        num_enemies += 1
