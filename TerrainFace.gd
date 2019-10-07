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
	st.set_material(material)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_color(Color(1, 255, 0, 1));
	
	for y in range(resolution):
		for x in range(resolution):
			var i = x + y * resolution;
			var percent = Vector2(x,y) / (resolution - 1);
			var pointOnUnitCube = localUp + (percent.x - 0.5) * 2 * axisA + (percent.y - 0.5) * 2 * axisB;
			var pointOnUnitSphere = pointOnUnitCube.normalized();
			st.add_color(Color(1, 0, 0));
			st.add_uv(Vector2(0, 0))
			st.add_vertex(parent.calculate_point_on_planet(pointOnUnitSphere));
			
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
