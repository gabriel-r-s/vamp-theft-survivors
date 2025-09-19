class_name Stars
extends Control

@export var icon_scene: PackedScene
@export var container: HBoxContainer

const FLASH_DELAY := 0.6

var stars: Array[Control] = []
var flash_state := true
var flashing := false
var flash_tween: Tween

func add_star() -> void:
    var star := icon_scene.instantiate()
    stars.push_back(star)
    container.add_child(star)

func remove_star() -> void:
    var popped: Node = stars.pop_back()
    if popped != null:
        popped.queue_free()

func set_stars(n: int) -> void:
    while stars.size() > n:
        remove_star()
    while stars.size() < n:
        add_star()

func flash_on() -> void:
    flash_state = true
    for star: CanvasItem in stars:
        star.visible = true

func flash_off() -> void:
    flash_state = false
    for star: CanvasItem in stars:
        star.visible = false

func start_flashing() -> void:
    if flashing:
        return
    flash_off()
    flashing = true
    keep_flashing_tween()

func keep_flashing_tween() -> void:
    if flash_tween:
        flash_tween.kill()

    if not flashing:
        flash_tween = create_tween()
        flash_tween.tween_callback(flash_on).set_delay(FLASH_DELAY)
        flash_tween.play()
    else:
        flash_tween = create_tween()
        flash_tween.tween_callback(flash_on).set_delay(FLASH_DELAY)
        flash_tween.tween_callback(flash_off).set_delay(FLASH_DELAY)
        flash_tween.play()
        flash_tween.finished.connect(func(): keep_flashing_tween())


func stop_flashing() -> void:
    flashing = false
