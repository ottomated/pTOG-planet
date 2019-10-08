tool
extends Node

var TerrainFace;
var NoiseFilter = preload("res://scripts/noise_filter.gd")

export(float) var radius = 1;
export(int) var resolution = 10;
export(Gradient) var gradient = Gradient.new()
export(Array, Resource) var noise_filters = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var TerrainFace = load("res://scripts/TerrainFace.gd");
	var directions = [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK];
	for direction in directions:
		var node = TerrainFace.new()
		node.resolution = resolution;
		node.localUp = direction;
		node.radius = radius;
		node.parent = self;
		add_child(node);

func get_noise(point):
	var elevation = 1;
	for noise in noise_filters:
		if not noise.mask or elevation > 1:
			elevation += noise.get_noise(point)
	return elevation

func calculate_elevation_on_planet(pointOnUnitSphere):
	return get_noise(pointOnUnitSphere) * radius;
	
func get_color_from_elevation(elevation):
	return gradient.interpolate(elevation / radius - 1)