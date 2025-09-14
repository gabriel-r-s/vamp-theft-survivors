class_name EnemyGun
extends Node

@export var fire_interval: float = 1.0
@export var dmg: float = 1.0
@export var speed: float = 150.0

var enemy: Enemy
var tween: Tween

@export_group("Scene")
@export var timer: Timer
@export var bullet_scene: PackedScene

var is_shooting := false

func _ready() -> void:
    enemy = get_parent()
    timer.wait_time = fire_interval

func shoot() -> void:
    var player_pos = enemy.player_pos
    if player_pos != null:
        var dir := enemy.global_position.direction_to(player_pos)
        var bullet: Bullet = bullet_scene.instantiate()
        bullet = bullet.dmg(dmg).dir(dir, speed).dont_collide_with_enemies()
        add_sibling(bullet)

func _physics_process(_delta: float) -> void:
    if not is_shooting and enemy.state == Enemy.State.Shooting:
        timer.start()
        is_shooting = true
    elif enemy.state != Enemy.State.Shooting:
        timer.stop()
        is_shooting = false
