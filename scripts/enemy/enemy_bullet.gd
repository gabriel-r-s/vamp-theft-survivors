class_name Bullet
extends RigidBody2D

@export var timer: Timer

var damage := 1.0

func pos(pos_: Vector2) -> Bullet:
	self.global_position = pos_
	return self

func dir(dir_: Vector2, speed: float = 1.0) -> Bullet:
	self.linear_velocity = dir_ * speed
	return self

func dmg(dmg_: float) -> Bullet:
	self.damage = dmg_
	return self

func timeout(secs: float) -> Bullet:
	self.timer.wait_time = secs
	return self

func _ready() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("get_hit"):
		body.get_hit(self.dmg)
	queue_free()
