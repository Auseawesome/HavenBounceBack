shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	int x = int(UV.x / TEXTURE_PIXEL_SIZE.x);
	int y = int(UV.y / TEXTURE_PIXEL_SIZE.y);
	
	if ((x + y) % 2 == 0) {
		COLOR = vec4(0.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
