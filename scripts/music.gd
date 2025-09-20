extends AudioStreamPlayer


@export var stars: EnemyManagerStars
@onready var num_stars := stars.stars

func _process(_delta: float) -> void:
    if stars.stars != num_stars and stars.stars >= 0:
        num_stars = stars.stars
        get_stream_playback().switch_to_clip(num_stars)
