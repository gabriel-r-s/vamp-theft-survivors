class_name Player
extends CharacterBody2D

@export var rot_dir: PlayerDirection
@export var move_speed: float = 50.0
@export var rot_speed: float = 10.0
@export var player_bullet_scene: PackedScene
@export var damage: float = 1.0

var velocity_dir: Vector2 = Vector2.ZERO
var move_pos: Vector2 = Vector2.ZERO
var rot_pos: Vector2 = Vector2.ZERO
var velocity_rot: float = 0.0
var target_node: WeakRef

var is_moving: bool = false
var is_rotating: bool = false
var is_attacking: bool = false

func _ready() -> void:
    rot_dir.set_radius(self.global_position.y - rot_dir.global_position.y)

func _physics_process(_delta: float) -> void:
    velocity.x = move_toward(velocity.x, 0.0, move_speed)
    velocity.y = move_toward(velocity.y, 0.0, move_speed)
    if is_rotating:
        if check_vector_threshold(
            Vector2(rot_pos - global_position).normalized(),
            Vector2(rot_dir.global_position - global_position).normalized(),
            0.1
        ):
            velocity_rot = 0.0
            is_rotating = false
        rot_dir.rotate_around_point(self.global_position, velocity_rot)
    elif is_attacking:
        velocity_dir = Vector2.ZERO
        fire_bullet(target_node)
        is_attacking = false
    elif is_moving:
        if check_vector_threshold(move_pos, global_position, 1.0) and velocity_dir != Vector2.ZERO:
            velocity_dir = Vector2.ZERO
            is_moving = false
        velocity = velocity_dir * move_speed
    move_and_slide()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_pos: Vector2 = get_viewport().get_canvas_transform().affine_inverse() * event.global_position
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            var targets: Array[Dictionary] = find_targets(mouse_pos)
            if targets.size() > 0:
                var collider: CollisionObject2D = targets[0]['collider']
                if collider.get_collision_layer_value(3) and collider.get_collision_layer_value(5):
                    var target := collider as Node2D
                    rot_pos = target.position
                    target_node = weakref(target)
                    rotate_pov()
                    is_attacking = true
            else:
                move_pos = mouse_pos
                rot_pos = move_pos
                velocity_dir = Vector2(move_pos - global_position).normalized()
                rotate_pov()
                is_moving = true

func check_vector_threshold(pos1: Vector2, pos2: Vector2, limit: float) -> bool:
    var mod: Vector2 = pos1 - pos2
    var x: bool = mod.x < limit and mod.x > -limit
    var y: bool = mod.y < limit and mod.y > -limit
    return x and y
    
func rotate_pov():
    var rot_angle: float = get_rotation_angle(global_position, rot_dir.global_position, rot_pos)
    velocity_rot = rot_angle / rot_speed
    is_rotating = true
    
func find_targets(mouse_pos: Vector2) -> Array[Dictionary]:
    var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
    var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
    query.position = mouse_pos
    query.collide_with_areas = true
    query.collide_with_bodies = true
    
    return space_state.intersect_point(query)
    
func fire_bullet(node: WeakRef):
    var player_bullet: PlayerBullet = player_bullet_scene.instantiate()
    player_bullet = player_bullet.dmg(damage).set_target(node).set_start_position(self.global_position).timeout(4.0)
    add_sibling(player_bullet)

func get_rotation_angle(vA: Vector2, vB: Vector2, vC: Vector2) -> float:
    var vAB: Vector2 = vB - vA
    var vAC: Vector2 = vC - vA
    return vAB.angle_to(vAC)
