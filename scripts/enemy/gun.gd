class_name EnemyGun
extends Node2D

@export var fire_interval: float = 1.0
@export var dmg: float = 1.0
@export var speed: float = 150.0
@export var burst_max_time: float = 3.0
@export var burst_recover_time: float = 3.0
@export var full_auto_audio: bool = false
@export var sound: AudioStream


var enemy: Enemy
var tween: Tween

@export_group("Scene")
@export var fire_timer: Timer
@export var burst_timer: Timer
@export var burst_recover_timer: Timer
@export var bullet_scene: PackedScene
@export var audio_stream_player: AudioStreamPlayer2D

var is_shooting := false

func _ready() -> void:
    enemy = get_parent()
    fire_timer.wait_time = fire_interval
    burst_timer.wait_time = burst_max_time
    burst_recover_timer.wait_time = burst_recover_time
    audio_stream_player.stream = sound

func shoot() -> void:
    var player_pos = enemy.player_pos
    if player_pos != null:
        var dir := enemy.global_position.direction_to(player_pos)
        var bullet: Bullet = bullet_scene.instantiate()
        bullet = bullet.dmg(dmg).pos(enemy.global_position).dir(dir, speed)
        enemy.add_sibling(bullet)
        if not full_auto_audio:
            audio_stream_player.play()

func _physics_process(_delta: float) -> void:
    if not is_shooting and burst_recover_timer.is_stopped() and enemy.state == Enemy.State.Shooting:
        fire_timer.start()
        burst_timer.start()
        is_shooting = true
        if full_auto_audio:
            audio_stream_player.play()
    elif is_shooting and burst_timer.is_stopped():
        fire_timer.stop()
        burst_recover_timer.start()
        is_shooting = false
    elif enemy.state != Enemy.State.Shooting:
        fire_timer.stop()
        is_shooting = false
