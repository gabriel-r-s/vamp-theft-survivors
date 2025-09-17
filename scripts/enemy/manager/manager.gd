class_name EnemyManager
extends Node

@export var player: Node2D

@export var spawn_points: Array[Marker2D] = []

@export_group("Scene")
@export var spawner: EnemyManagerSpawner
@export var navigation: EnemyManagerNavigation
@export var stars: EnemyManagerStars
