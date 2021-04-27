extends Node2D

var textures = [
	preload("res://assets/water-1.png"),
	preload("res://assets/water-2.png"),
]

func _ready():
	add_to_group("Tiles");

func place_token(token):
	get_node("Water").add_child(token);

func set_tile_index(idx):
	get_node("Sprite").texture = textures[idx % textures.size()];

func width():
	return 50;
