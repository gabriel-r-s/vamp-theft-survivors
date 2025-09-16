extends CharacterBody2D
class_name PlayerBullet

@export var timer: Timer
@export var area2D: Area2D

var target: Node2D
var damage: float = 1.0
var speed: float = 200.0

func dmg(dmg_: float) -> PlayerBullet:
	self.damage = dmg_
	return self

func set_target(tgt_: Node2D) -> PlayerBullet:
	self.target = tgt_
	return self

func set_start_position(pos_: Vector2) -> PlayerBullet:
	self.global_position = pos_
	return self

func dont_collide_with(body: Node) -> PlayerBullet:
	self.add_collision_exception_with(body)
	return self

func dont_collide_with_player() -> PlayerBullet:
	set_collision_mask_value(4, false)
	return self

func timeout(secs: float) -> PlayerBullet:
	self.timer.wait_time = secs
	return self

func _ready() -> void:
	timer.start()

func _physics_process(_delta: float) -> void:
	var dir: Vector2 = Vector2(target.position - self.position).normalized()
	velocity = dir * speed
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit(self)
	queue_free()
