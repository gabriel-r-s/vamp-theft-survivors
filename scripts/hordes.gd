extends Node

@export var stars: EnemyManagerStars
@export var player: Player

func _ready() -> void:
    start.call_deferred()

func start() -> void:
    player.reset_health()
    # Primeira horda
    stars.set_stars(0)
    await get_tree().create_timer(30).timeout

    stars.set_stars(1)
    await get_tree().create_timer(20).timeout

    stars.set_stars(2)
    await get_tree().create_timer(20).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(20).timeout

    player.reset_health()

    # Segunda horda
    stars.set_stars(2)
    await get_tree().create_timer(15).timeout

    stars.set_stars(3)
    await get_tree().create_timer(30).timeout

    stars.set_stars(4)
    await get_tree().create_timer(30).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(30).timeout

    player.reset_health()

    # Terceira horda
    stars.set_stars(4)
    await get_tree().create_timer(40).timeout

    stars.set_stars(5)
    await get_tree().create_timer(40).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(40).timeout

    player.reset_health()

    # Quarta horda
    stars.set_stars(5)
    await get_tree().create_timer(10).timeout

    stars.set_stars(6)
    await get_tree().create_timer(60).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(40).timeout

    player.reset_health()

    # Infinito
    stars.set_stars(6)
