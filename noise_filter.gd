extends Resource

export(OpenSimplexNoise) var generator = OpenSimplexNoise.new();
export(float) var strength = 1;
export(float) var height = 0;
export(bool) var enabled = true
export(bool) var ridged = false

func get_noise(point):
	if (!enabled):
		return 0
	var noise = max(-10, generator.get_noise_3d(point.x, point.y, point.z) * strength - height)
	if ridged:
		return 1 - abs(noise)
	else:
		return noise