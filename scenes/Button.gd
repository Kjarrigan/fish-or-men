extends TextureButton

export var label = ""

func _ready():
	get_node("Label").text = label
