extends TextureButton

var faces = [
	preload("res://assets/fish-1.png"),
	preload("res://assets/fish-2.png"),
	preload("res://assets/fish-3.png"),
	preload("res://assets/fish-4.png"),
	preload("res://assets/men-1.png"),
	preload("res://assets/men-2.png"),
]
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize();

func roll():
	return rng.randi_range(0, faces.size()-1);

func _on_Die_pressed():
	var token_index = roll();
	
	var game = get_node("/root/Game");
	if (game.move_token_index(token_index)):
		get_node("Face").texture = faces[token_index];
