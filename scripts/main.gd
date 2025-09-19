extends Node

@export var game_scene: PackedScene

var game: Node = null

func _ready() -> void:
    game = game_scene.instantiate()
    var player: Player = game.get_node("Player")
    player.die.connect(reset)
    add_child(game)

func reset() -> void:
    var new_game := game_scene.instantiate()
    game.queue_free()
    game = new_game
    var player: Player = game.get_node("Player")
    player.die.connect(reset)
    add_child(game)
