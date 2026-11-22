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

func _ready() -> void:
	for shits: Node2D in positions.keys():
		var sprite = Sprite2D.new()
		if shits is Marker2D:
			shits.add_child(sprite)
		else:
			shits.get_children()[0].add_child(sprite)
		sprite.texture = DICE_EMPTY
		#sprite.hide()
	print(positions.get(inner_pos_1))

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
			if sprite.global_position.distance_squared_to(tap_pos) < 900.0: # 50px radius (50*50)
				print("Tapped: ", sprite.name + " " + str(count))
				count+=1
				
				#debug
				if sprite.name == "dice":
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

func show_moves():
	pass
