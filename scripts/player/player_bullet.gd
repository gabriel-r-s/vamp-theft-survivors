extends CharacterBody2D
class_name PlayerBullet

@export var timer: Timer
@export var area2D: Area2D

var target: WeakRef
var damage: float = 6.0
var speed: float = 200.0

func dmg(dmg_: float) -> PlayerBullet:
    self.damage = dmg_
    return self

func set_target(tgt_: WeakRef) -> PlayerBullet:
    self.target = tgt_
    return self

func set_start_position(pos_: Vector2) -> PlayerBullet:
    self.global_position = pos_
    return self

func timeout(secs: float) -> PlayerBullet:
    self.timer.wait_time = secs
    return self

func _ready() -> void:
    prints(self, "new bullet")
    timer.start()

func _physics_process(_delta: float) -> void:
    var target_ref = target.get_ref()
    if target_ref == null:
        queue_free()
        return
    var dir: Vector2 = Vector2(target_ref.position - self.position).normalized()
    velocity = dir * speed
    move_and_slide()

func _on_timer_timeout() -> void:
    queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
    if is_queued_for_deletion():
        return
    if body.has_method("get_hit"):
        body.get_hit(self.damage)
    queue_free()
