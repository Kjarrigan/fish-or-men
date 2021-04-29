extends TextureRect

func _ready():
	pass # Replace with function body.

func is_fish():
	return false;
	
func is_boat():
	return true;
	
func catch_fish():
	for token in get_parent().get_children():
		if token.is_fish():
			get_parent().remove_child(token)
			get_node("Net").add_child(token)

func is_catched():
	return false;
