extends Node2D

var tiles : Array
var token : Array

var tile_size = 50.0
var tile_height = 600.0
var start_position = 10

var tile = preload("res://scenes/Tile.tscn")
var fish = preload("res://scenes/Fish.tscn")
var boat = preload("res://scenes/Boat.tscn")
var boat_token
var end_tile = preload("res://scenes/OceanTile.tscn")
var fisher_tile = preload("res://scenes/FisherTile.tscn")

var wait_for_input = false

func _ready():
	new_game()
	
func new_game():
	tiles = []
	token = []
	
	var ocean = end_tile.instance()
	for idx in range(11):
		var t = tile.instance()
		t.set_tile_index(idx)
		tiles.append(t)

	# Shuffle the tiles so the map looks slightly different every time
	tiles.shuffle()
	
	# Start of the fishing boat
	var t = fisher_tile.instance()
	tiles.append(t)
	tiles = [ocean] + tiles
	
	var x = 30
	
	for tile in tiles:
		tile.position = Vector2(x, tile_height / 2 + 6)
		x += tile.width()
		
	# Loop backwards for the z-ordering because control nodes to not have
	# a z-index param
	for idx in tiles.size():
		get_node("Board").add_child(tiles[-idx-1])
		
	for idx in range(4):
		var f = fish.instance()
		f.set_token_index(idx)
		token.append(f)
		
	for f in token:
		tiles[start_position].place_token(f)
		
	boat_token = boat.instance()
	tiles[tiles.size()-1].place_token(boat_token)
	token.append(boat_token)
	token.append(boat_token)

	get_node("UI/ActionLabel").text = "Fish or Men - who will win? Click on a fish or the boat to start."

func move_token_index(i):
	if wait_for_input:
		get_node("UI/ActionLabel").text = "You have to choose a fish before rolling again!"
		return false
	else:
		var t = token[i]
		
		# if a catched fish would move, the boat moves instead
		if t.is_catched():
			t = boat_token
			
		move_token(t)
		return true
		
func move_token_manual(t):
	if wait_for_input:
		move_token(t)
		wait_for_input = false
		get_node("UI/ActionLabel").text = ""
	else:
		get_node("UI/ActionLabel").text = "Click the die!"
		
func end_game(msg):
	get_node("UI/ActionLabel").text = msg
	
func check_victory_conditions():
	var rescued = tiles[0].get_node("Water").get_children().size()
	var catched = boat_token.get_node("Net").get_children().size()
	
	if catched >= 3:
		end_game('Team Boat wins!')
	if rescued >= 3:
		end_game('Team Fish wins!')
	if rescued == 2 and catched == 2:
		end_game('Tie!')
	

func move_token(f):
	var current_tile = f.get_parent().get_parent()
	var next_tile = tiles.find(current_tile) - 1
	if next_tile >= 0:
		var box = f.get_parent()
		box.remove_child(f)
		tiles[next_tile].place_token(f)
		
		if f.is_boat():
			f.catch_fish()
	else:
		if f.is_fish():
			get_node("UI/ActionLabel").text = "Choose a fish!"
			wait_for_input = true
	check_victory_conditions()
