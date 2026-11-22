extends Node2D
# debug
@onready var dice: Label = $UI/dice
var dice_val = 0
# debug over

const DICE_EMPTY = preload("uid://donf3db2sm0bp")

@onready var pos_1: Marker2D = $outer_places/pos_1
@onready var pos_2: Marker2D = $outer_places/pos_2
@onready var pos_3: Marker2D = $outer_places/pos_3
@onready var pos_4: Marker2D = $outer_places/pos_4
@onready var pos_5: Marker2D = $outer_places/pos_5
@onready var pos_6: Marker2D = $outer_places/pos_6
@onready var pos_7: Marker2D = $outer_places/pos_7
@onready var pos_8: Marker2D = $outer_places/pos_8
@onready var pos_9: Marker2D = $outer_places/pos_9
@onready var pos_10: Marker2D = $outer_places/pos_10
@onready var pos_11: Marker2D = $outer_places/pos_11
@onready var pos_12: Marker2D = $outer_places/pos_12

@onready var player_1_base: Node2D = $player1_base
@onready var player_2_base: Node2D = $player2_base
@onready var player_3_base: Node2D = $player3_base
@onready var player_4_base: Node2D = $player4_base
@onready var win: Node2D = $win

@onready var inner_pos_1: Marker2D = $inner_places/inner_pos_1
@onready var inner_pos_2: Marker2D = $inner_places/inner_pos_2
@onready var inner_pos_3: Marker2D = $inner_places/inner_pos_3
@onready var inner_pos_4: Marker2D = $inner_places/inner_pos_4
@onready var inner_pos_5: Marker2D = $inner_places/inner_pos_5
@onready var inner_pos_6: Marker2D = $inner_places/inner_pos_6
@onready var inner_pos_7: Marker2D = $inner_places/inner_pos_7
@onready var inner_pos_8: Marker2D = $inner_places/inner_pos_8

@onready var clickables: Node2D = $Clickables

@onready var positions : Dictionary = {
	pos_1 : [pos_2, inner_pos_3],
	pos_2 : [pos_3],
	pos_3 : [player_2_base],
	player_2_base : [pos_4],
	pos_4 : [pos_5, inner_pos_5],
	pos_5 : [pos_6],
	pos_6 : [player_3_base],
	player_3_base : [pos_7],
	pos_7 : [pos_8, inner_pos_7],
	pos_8 : [pos_9],
	pos_9 : [player_4_base],
	player_4_base: [pos_10],
	pos_10 : [pos_11, inner_pos_1],
	pos_11: [pos_12],
	pos_12 : [player_1_base],
	player_1_base : [pos_1],
	inner_pos_1: [inner_pos_2],
	inner_pos_3: [inner_pos_4],
	inner_pos_5: [inner_pos_6],
	inner_pos_7: [inner_pos_8],
	inner_pos_2: [inner_pos_3, win],
	inner_pos_4: [inner_pos_5, win],
	inner_pos_6: [inner_pos_7, win],
	inner_pos_8: [inner_pos_1, win]
	}


func all_player_starting_position():
	pass

func add_visual(shits):
	var sprite = Sprite2D.new()
	shits.add_child(sprite)
	sprite.texture = DICE_EMPTY
	sprite.modulate = "009e3b5d"
	sprite.hide()
	sprite.name = "highlight"

func _ready() -> void:
	for shits: Node2D in positions.keys():
		add_visual(shits)
	add_visual(win)
	#print(positions.get(inner_pos_1))

var count = 0
#
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tap_pos = get_global_mouse_position()
		
		# Loop backwards so topmost sprites are checked first
		var items = clickables.get_children()
		for i in range(items.size() - 1, -1, -1):
			#var sprite: Sprite2D = items[i]
			var sprite = items[i]
			# For circular/radius check (fastest):
			if sprite.global_position.distance_squared_to(tap_pos) < 900.0:
				
				if sprite is Pawn:
					print("Pawn")
					show_moves(sprite)
				
				#print("Tapped: ", sprite.name + " " + str(count))
				#count+=1
				
				#debug
				elif sprite.name == "dice":
					dice_val = randi_range(1,6)
					dice.text = str(dice_val)
				
				#debug over
				break
			# OR for exact sprite rectangle bounds:
			# if sprite.get_rect().has_point(sprite.to_local(tap_pos)):

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		##var tap_pos = get_global_mouse_position()
		#var items = clickables.get_children()
		#
		#for i in range(items.size() - 1, -1, -1):
			#var item = items[i]
			#
			## Fast C++ pointer check (no string comparison!)
			#if item is Pawn:
				#print("pawn")
				##dice_val
				#pass
			#elif item.name == "dice":
				#print("true")
				#dice_val = randi_range(1,6)
				#dice.text = str(dice_val)

func show_moves(pawn: Pawn) -> void:
	# Start DFS from the pawn's current position with dice_val steps left
	_dfs_moves(pawn.current_pos, dice_val, pawn.player_no)

func _dfs_moves(current_pos: Variant, steps_left: int, player_no : int) -> void:
	# Base case: stop when we run out of dice steps
	if steps_left <= 0:
		return

	# Get all possible next positions (branches) from the current tile
	var next_positions: Array = positions.get(current_pos,[])
	
	for marker: Marker2D in next_positions:
		# Highlight this tile
		#marker.name == "player%d_base" % player_no or 
		if marker.name.begins_with("pos_") or marker.name.begins_with("player"):
			marker.get_child(0).show()
		
		# Recursively explore down this specific branch with 1 fewer step
		_dfs_moves(marker, steps_left - 1, player_no)


#func show_moves(pawn: Pawn):
	#var mark = pawn.current_pos
	#for i in dice_val:
		#var mark_arr = positions.get(mark)
		#for marker: Marker2D in mark_arr:
			#marker.get_child(0).show()
		#mark = mark_arr[0]
