class_name Enemy
extends RigidBody2D

@export_group("Attrs")
@export var max_speed := 30.0
@export var accel := 30.0

@export_group("Scene")
@export var nav: NavigationAgent2D
@export var bored_timer: Timer
@export var unbored_timer: Timer

enum State {
	Manouvering,
	Bored,
	Shooting,
}

var manager: EnemyManager
var state := State.Shooting
var nav_target := Vector2.ZERO
var player_pos = Vector2.ZERO

func can_see_player() -> bool:
	return manager.navigation.point_can_see_player(self.global_position)

func _ready() -> void:
	state = State.Bored
	set_state(State.Manouvering)

func set_state(next_state: State) -> void:
	if state == next_state:
		return

	match next_state:
		State.Manouvering:
			var target := manager.navigation.random_point()
			nav.target_position = target
			nav_target = target

		State.Bored:
			var target := manager.navigation.random_point()
			nav.target_position = target
			nav_target = target
			unbored_timer.start()

		State.Shooting:
			bored_timer.start()

	state = next_state

func move_toward_nav_target(delta: float) -> void:
	var next_path_position := nav.get_next_path_position()
	var wish_velocity := max_speed * global_position.direction_to(next_path_position)
	linear_velocity = linear_velocity.move_toward(wish_velocity, delta * accel)


func update(delta: float) -> void:
	var next_state := state
	player_pos = null

	match state:
		State.Manouvering:
			if not nav.is_navigation_finished():
				move_toward_nav_target(delta)

			if can_see_player():
				next_state = State.Shooting

		State.Bored:
			move_toward_nav_target(delta)

			if unbored_timer.is_stopped():
				next_state = State.Shooting

		State.Shooting:
			player_pos = manager.navigation.player_global_pos()
			if bored_timer.is_stopped():
				next_state = State.Bored
			elif not can_see_player():
				next_state = State.Manouvering

			linear_velocity = linear_velocity.move_toward(Vector2.ZERO, delta * accel)

	set_state(next_state)
