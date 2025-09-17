extends Node2D
class_name PlayerDirection

var radius: float = 1.0
var angle: float = 0.0

func set_radius(r_: float) -> PlayerDirection:
	radius = r_
	return self
	
func rotate_around_point(point: Vector2, rot_speed: float) -> void:
	angle += rot_speed
	
	var n_x: float = point.x + cos(angle) * radius
	var n_y: float = point.y + sin(angle) * radius
	
	global_position = Vector2(n_x, n_y)
	rotation = angle
