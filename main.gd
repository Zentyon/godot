extends TileMap

var x1 = 0
var y1 = 0
var x2 = 4
var y2 = 0

var current_pos = Vector2(0,0)

var player_pos = Vector2(x1,y1)
var enemy_pos = Vector2(x2,y2)
var grid_positions = {}


@export var grid_size_x = 6
@export var grid_size_y = 5
@export var group = 2
@export var enemys = 5

var tile_size = Vector2(128, 128)
@export var team : Array[PackedScene] = []
@export var enemy : PackedScene
@export var panel : PackedScene

func _ready():
	initialize_grid()
	initialize_grid_positions()
	define_initial_positions()
	
	print(grid_positions)
	
func _process(_delta):
	
	pass

func define_initial_positions():
	

	for i in range(group):
		# Calcula las posiciones del mundo basadas en las coordenadas del grid y el tamaño de la celda
		var p1_world_pos = Vector2(x1 * tile_size.x + tile_size.x / 2, y1 * tile_size.y + tile_size.y / 2)
 
		# Carga las escenas de los personajes
		var player_scene = team[i]
 
		# Instancia las escenas de los personajes
		var player_instance = player_scene.instantiate()
	
		# Añade los personajes como hijos del nodo TileMap
		add_child(player_instance)
 
		# Posiciona los personajes en el mundo en las posiciones iniciales
		player_instance.position = p1_world_pos
 
		grid_positions[player_pos]["occupied"] = true
 
		y1 += 1
 
		player_pos = Vector2(x1,y1)
	for i in range(enemys):
		var enemy_world_position = Vector2(x2 * tile_size.x + tile_size.x / 2, y2 * tile_size.y + tile_size.y / 2)
		var enemy_scene = enemy
		var enemy_instance = enemy_scene.instantiate()
		add_child(enemy_instance)
		grid_positions[enemy_pos]["occupied"] = true
		enemy_instance.position = enemy_world_position
		var randp = randi_range(-1, 1)
		if x2 >= 5 && randp >=1:
			randp = randp*-1
		elif x2 <=3 && randp <=-1:
			randp = randp*-1
		x2 += randp
		y2 += 1
		enemy_pos = Vector2(x2,y2)

func initialize_grid_positions():
	# Llena el diccionario grid_positions con las posiciones del grid
	for x in range(grid_size_x):
		for y in range(grid_size_y):
			var pos = Vector2(x, y)
			grid_positions[pos] = {
				"occupied": false
			}

func initialize_grid():
	for x in range(grid_size_x):
		for y in range(grid_size_y):
			set_cell(0, Vector2i(x,y), 1, Vector2i(0,0) ,0)

func highlight():
	for x in range(grid_size_x):
		for y in range(grid_size_y):
			var pos = Vector2(x, y)
			if (grid_positions[pos]["occupied"] == false):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,0) ,0)
			else:
				set_cell(0, Vector2i(x,y), 1, Vector2i(0,0) ,0)

func move_character(player_pos: Vector2):
	# Resalta las celdas válidas del grid
	highlight()
	
	
	
	var new_position = Vector2(2,2)
	if is_valid_position(new_position) and not is_occupied(new_position):
		# Mueve al personaje a la nueva posición
		var character = get_child(0) # Cambia "Character" por el nombre de tu nodo de personaje
		# Actualiza el estado del diccionario grid_positions
		grid_positions[current_pos]["occupied"] = false
		character.position = new_position
		# Actualiza la posición del jugador
		player_pos = new_position
		current_pos = new_position
 
		var world_pos = Vector2(new_position.x * tile_size.x + tile_size.x / 2, new_position.y * tile_size.y + tile_size.y / 2)
		character.position = world_pos
		grid_positions[new_position]["occupied"] = true
		highlight()
 

func is_valid_position(pos: Vector2) -> bool:
	# Verifica si la posición está dentro del rango válido del grid
	return pos.x >= 0 and pos.x < grid_size_x and pos.y >= 0 and pos.y < grid_size_y

func is_occupied(pos: Vector2) -> bool: 
	# Verifica si la posición está ocupada por otro personaje
	return grid_positions[pos]["occupied"]


func _on_move_pressed():
	
	move_character(current_pos)
	pass # Replace with function body.
