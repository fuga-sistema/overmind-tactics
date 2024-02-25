extends Node3D

const currentDeckPath = "res://assets/Xanxao's/Resources/CurrentSessionDeck.tres"
# The list of scenes (prefabs) to choose from. Replace these paths with your actual scene file paths.
var scenes_to_instance = preload(currentDeckPath)

var current_heroes = []

var chosen_heroes = []

var gold = 20

# Customizable parameters
var number_of_instances: int = 5
var base_height: float = 1.0
var spacing: float = 2.0

# Function to create a material with a custom color hue
func create_material_with_hue(hue: float) -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.from_hsv(hue, 1, 1) # Full saturation and value for vivid color
	return material

# Recursive function to find the first MeshInstance in the hierarchy
func apply_material_to_first_mesh_instance(node: Node, material: Material) -> bool:
	
	if node is MeshInstance3D:
		node.material_override = material
		return true
	for child in node.get_children():
		for child2 in child.get_children():
			if apply_material_to_first_mesh_instance(child2, material):
				return true

	return false

 
func reroll():
	if gold > 3:
		gold -= 3
		get_node("../CanvasLayer/reroll_button").text = "Here lies the capability
of redoing the process 
of summoning the heroes
to your choosing in the 
dedicated space and
alloted time
			  " + str(gold)
		
		for hero in current_heroes:
			if (hero != null):
				hero.queue_free()
			
		current_heroes = []
		
		randomize() # Ensure different random sequences each run
		spawn_instances()

func pick_hero(index):
	if current_heroes[index] != null:
		chosen_heroes.append(scenes_to_instance.deck[index])
		scenes_to_instance.deck.remove_at(index)
		ResourceSaver.save(scenes_to_instance, currentDeckPath)
		current_heroes[index].queue_free()
		current_heroes[index] = null
		
	

func _ready():
	randomize() # Ensure different random sequences each run
	spawn_instances()

func spawn_instances():
	if (scenes_to_instance.deck.size() <= 0):
		return
	var number_of_spawns = number_of_instances
	if number_of_spawns > scenes_to_instance.deck.size():
		number_of_spawns = scenes_to_instance.deck.size()
	
	var current_position: Vector3 = Vector3.ZERO # Starting position
	for i in range(number_of_instances):
		await get_tree().create_timer(0.5).timeout
		# Select a random scene from the list
		var scene_index: int = randi() % scenes_to_instance.deck.size()
		var scene_to_instance: PackedScene = load(scenes_to_instance.deck[scene_index])
		
		
		
		
		# Instantiate the scene
		var instance: Node3D = scene_to_instance.instantiate() as Node3D

		
		var material = create_material_with_hue(randf()) # Create a material with a random hue
		var success = apply_material_to_first_mesh_instance(instance, material)
		if not success:
			print("No MeshInstance found in the hierarchy.")
		
		# Position the instance by setting transform.origin
		instance.transform.origin = current_position + Vector3(0, base_height, 0)
		
		# Add the instance to the scene tree
		add_child(instance)
		
		# Update the position for the next instance
		current_position.x += spacing
		current_heroes.append(instance)
		
		
		


func _on_button_button_up():
	reroll()


func _on_button_3_button_up():
	pick_hero(0)


func _on_button_4_button_up():
	pick_hero(1)


func _on_button_5_button_up():
	pick_hero(2)


func _on_button_6_button_up():
	pick_hero(3)


func _on_button_7_button_up():
	pick_hero(4)
