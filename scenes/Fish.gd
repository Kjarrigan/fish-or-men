extends TextureRect

var textures = [
	preload("res://assets/fish-1.png"),
	preload("res://assets/fish-2.png"),
	preload("res://assets/fish-3.png"),
	preload("res://assets/fish-4.png"),
]

func _ready():
	add_to_group("Token")

func _on_Fish_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var game = get_node("/root/Game");
		game.move_token_manual(self);

func set_token_index(idx):
	texture = textures[idx % textures.size()];

func is_fish():
	return true;
	
func is_boat():
	return false;

func is_catched():
	return get_parent().name == "Net"
	
func is_free():
	return get_parent().get_parent().name == "OceanTile"
