extends Node
class_name Bread3D

var col: CollisionObject3D
var mesh: MeshInstance3D

var currentImage: Image
var texture: Texture2D
var mat: StandardMaterial3D
var imgTex: ImageTexture

var minMaxZ: Vector2 = Vector2(1000, -1000)
var minMaxX: Vector2 = Vector2(1000, -1000)

var prevImagePos: Vector2i = Vector2i.ONE
var usePrevPos: bool = false

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	
	mesh = $jam
	var verts: PackedVector3Array = mesh.mesh.get_faces()
	for i in range(0, verts.size()):
		var fullpos: Vector3 = mesh.global_position
		verts[i] = verts[i] * mesh.scale + mesh.global_position
		
		if verts[i].z < minMaxZ.x:
			minMaxZ.x = verts[i].z
		if verts[i].z > minMaxZ.y:
			minMaxZ.y = verts[i].z
			
		if verts[i].x < minMaxX.x:
			minMaxX.x = verts[i].x
		if verts[i].x > minMaxX.y:
			minMaxX.y = verts[i].x
		pass
	
	var mat: StandardMaterial3D = mesh.material_override
	currentImage = mat.albedo_texture.get_image()
	currentImage.decompress()
	texture = mat.albedo_texture
	imgTex = ImageTexture.new()
	imgTex = ImageTexture.create_from_image(currentImage)
	mat.albedo_texture = imgTex
	
	
	GM.input.inputLeftClickReleased.connect(lifted_up)
	pass

func write_pixel(pos: Vector2i, color:Color, update:bool = true):
	var corrected_pos: Vector2i = Vector2i(max(pos.x, 0), max(pos.y, 0))
	var testcolor:Color = currentImage.get_pixelv(corrected_pos)
	if testcolor != color:
		currentImage.set_pixelv(corrected_pos, color)
		if update:
			imgTex.update(currentImage)
	pass

func write_line(start_pos:Vector2i, end_pos:Vector2i, color:Color):
	var slope = Vector2(end_pos.x - start_pos.x, end_pos.y - start_pos.y)
	var stepCount = max(abs(slope.x), abs(slope.y))
	var stepSlope = Vector2(slope.x/stepCount, slope.y/stepCount)
	var curPoint: Vector2 = start_pos
	write_pixel_plus(curPoint, color)
	for i in range(0, stepCount):
		curPoint += stepSlope
		write_pixel_plus(curPoint, color)
		pass
	pass

func write_pixel_plus(pos: Vector2i, color:Color):
	write_pixel(pos, color)
	write_pixel(pos + Vector2i(1,0), color)
	write_pixel(pos + Vector2i(-1,0), color)
	write_pixel(pos + Vector2i(0,1), color)
	write_pixel(pos + Vector2i(0,-1), color)
	pass

func _process(delta):
	pass


func lifted_up(pos: Vector2):
	usePrevPos = false
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if(GM.input.leftClickCurrentlyPressed):
		var finalpos:Vector2i = Vector2i(((event_position.x - minMaxX.x) / (minMaxX.y - minMaxX.x)) * imgTex.get_width(), ((event_position.z - minMaxZ.x) / (minMaxZ.y - minMaxZ.x)) * imgTex.get_height())
		if usePrevPos:
			write_line(prevImagePos, finalpos, GM.cursor.curColor)
		else:
			write_pixel(finalpos, GM.cursor.curColor)
		prevImagePos = finalpos
		usePrevPos = true
	pass
