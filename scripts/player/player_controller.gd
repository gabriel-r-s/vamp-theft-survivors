extends CharacterBody2D

@export var rot_dir: Node2D
@export var move_speed: float = 50.0
@export var rot_speed: float = 10.0

var velocity_dir: Vector2 = Vector2.ZERO
var move_pos: Vector2 = Vector2.ZERO
var velocity_rot: float = 0.0
var is_moving: bool = false
var is_rotating: bool = false

func _physics_process(delta: float) -> void:
	if (is_rotating):
		if check_vector_threshold(
			Vector2(move_pos - global_position).normalized(),
			Vector2(rot_dir.global_position - global_position).normalized(),
			0.1
		):
			velocity_rot = 0.0
			is_rotating = false
			is_moving = true
		rotate(velocity_rot)
	if (is_moving):
		if check_vector_threshold(move_pos, global_position, 1.0) and velocity_dir != Vector2.ZERO:
			velocity_dir = Vector2.ZERO
			is_moving = false
		velocity = velocity_dir * move_speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			move_pos = event.global_position
			velocity_dir = Vector2(move_pos - global_position).normalized()
			rotate_pov()

func check_vector_threshold(pos1: Vector2, pos2: Vector2, limit: float) -> bool:
	var mod: Vector2 = pos1 - pos2
	var x: bool = mod.x < limit and mod.x > -limit
	var y: bool = mod.y < limit and mod.y > -limit
	return x and y
	
func rotate_pov():
	var rot_angle: float = get_rotation_angle(global_position, rot_dir.global_position, move_pos)
	velocity_rot = rot_angle / rot_speed
	is_rotating = true
	
func get_rotation_angle(vA: Vector2, vB: Vector2, vC: Vector2) -> float:
	var vAB: Vector2 = vB - vA
	var vAC: Vector2 = vC - vA
	return vAB.angle_to(vAC)
