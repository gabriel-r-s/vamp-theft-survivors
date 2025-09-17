class_name EnemyManagerSpawner
extends Node

@export_range(1, 32) var num_slices := 16

class TimeSliceSignal:
    var sig: Signal
    var last_update: float

    func _init(sig_: Signal) -> void:
        sig = sig_
        last_update = Time.get_unix_time_from_system()


var slices: Array[TimeSliceSignal] = []


func _ready() -> void:
    for i in num_slices:
        var signal_name := "update_%d" % [i]
        add_user_signal(signal_name, [
            {"name": "delta", "type": TYPE_FLOAT}
        ])
        var sig := Signal(self, signal_name)
        slices.push_back(TimeSliceSignal.new(sig))

func spawn_enemy(scene: PackedScene, position: Vector2 = Vector2(20.0, 20.0)) -> Enemy:
    var enemy: Enemy = scene.instantiate()
    var sig := least_used_signal()
    sig.connect(Callable(enemy, "update"))
    enemy.manager = get_parent()
    enemy.global_position = position
    add_child(enemy)
    return enemy


func least_used_signal() -> Signal:
    var slice_index := Engine.get_physics_frames() % num_slices
    var slice: TimeSliceSignal = slices[slice_index]
    return slice.sig

func _physics_process(_delta: float) -> void:
    var slice_index := Engine.get_physics_frames() % num_slices
    var slice: TimeSliceSignal = slices[slice_index]

    var now := Time.get_unix_time_from_system()
    slice.sig.emit(now - slice.last_update)
    slice.last_update = now
