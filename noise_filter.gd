extends Resource

export(OpenSimplexNoise) var generator = OpenSimplexNoise.new();
export(float) var strength = 1;
export(float) var height = 0;
export(bool) var enabled = true
export(bool) var ridged = false
export(bool) var mask = false
var seeded = false

func get_noise(point):
	if (!seeded):
		seeded = true
		generator.seed = randi()
	if (!enabled):
		return 0
	var noise = generator.get_noise_3d(point.x * 512, point.y * 512, point.z * 512) - height
	if ridged:
		return max(0, (1 - abs(noise)) * strength)
	else:
		return max(0, noise * strength)