tool
extends MeshInstance

var resolution;
var localUp;
var radius;
var axisA;
var axisB;
var parent;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	axisA = Vector3(localUp.y, localUp.z, localUp.x)
	axisB = localUp.cross(axisA)
	construct_mesh()

func construct_mesh():
	var st = SurfaceTool.new()
	var material = SpatialMaterial.new()
	material.vertex_color_use_as_albedo = true
	set_material_override(material);
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for y in range(resolution):
		for x in range(resolution):
			var i = x + y * resolution;
			var percent = Vector2(x,y) / (resolution - 1);
			var pointOnUnitCube = localUp + (percent.x - 0.5) * 2 * axisA + (percent.y - 0.5) * 2 * axisB;
			var pointOnUnitSphere = pointOnUnitCube.normalized();
			st.add_uv(Vector2(0, 0))
			var elevation = parent.calculate_elevation_on_planet(pointOnUnitSphere);
			st.add_color(parent.get_color_from_elevation(elevation));
			st.add_vertex(pointOnUnitSphere * elevation);
			
			if (x != resolution - 1 && y != resolution - 1):
				st.add_index(i + resolution + 1);
				st.add_index(i + 1);
				st.add_index(i);
				
				st.add_index(i + resolution);
				st.add_index(i + resolution + 1);
				st.add_index(i);
				
	st.generate_normals(false)
	mesh = st.commit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
