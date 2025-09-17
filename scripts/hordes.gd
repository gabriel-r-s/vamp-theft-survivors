extends Node

@export var stars: EnemyManagerStars

func _ready() -> void:
    start.call_deferred()

func start() -> void:
    # Primeira horda
    stars.set_stars(0)
    await get_tree().create_timer(30).timeout

    stars.set_stars(1)
    await get_tree().create_timer(20).timeout

    stars.set_stars(2)
    await get_tree().create_timer(20).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(20).timeout

    # Segunda horda
    stars.set_stars(2)
    await get_tree().create_timer(15).timeout

    stars.set_stars(3)
    await get_tree().create_timer(30).timeout

    stars.set_stars(4)
    await get_tree().create_timer(30).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(40).timeout

    # Terceira horda
    stars.set_stars(4)
    await get_tree().create_timer(40).timeout

    stars.set_stars(5)
    await get_tree().create_timer(40).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(40).timeout

    # Quarta horda
    stars.set_stars(5)
    await get_tree().create_timer(10).timeout

    stars.set_stars(6)
    await get_tree().create_timer(60).timeout

    stars.set_stars_flashing()
    await get_tree().create_timer(40).timeout

    # Infinito
    stars.set_stars(6)
