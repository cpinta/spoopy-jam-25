extends Node3D
class_name Bread3D

enum BreadState {Stack = 0, OnTable=1, OnSandwich=2}

var state: BreadState

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

var movingToDest: bool = false
var dest:Vector3
const DEST_LERP: float = 10
const DEST_MIN_DIST: float = 0.1

var jamAmountsApplied: = {}

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

func _process(delta):
	if movingToDest:
		if dest.distance_to(self.global_position) < DEST_MIN_DIST:
			global_position = dest
			movingToDest = false
			pass
		else:
			global_position = global_position.lerp(dest, DEST_LERP * delta)
	pass

func set_destination(pos:Vector3):
	movingToDest = true
	dest = pos
	pass

func write_pixel(pos: Vector2i, color:Color, update:bool = true):
	var corrected_pos: Vector2i = Vector2i(min(max(pos.x, 0), 255), min(max(pos.y, 0),255))
	
	var testcolor:Color = currentImage.get_pixelv(corrected_pos)
	if testcolor != color:
		currentImage.set_pixelv(corrected_pos, color)
		if update:
			imgTex.update(currentImage)
		return 1
	return 0

func write_line(start_pos:Vector2i, end_pos:Vector2i, color:Color):
	var slope = Vector2(end_pos.x - start_pos.x, end_pos.y - start_pos.y)
	var stepCount = max(abs(slope.x), abs(slope.y))
	var stepSlope = Vector2(slope.x/stepCount, slope.y/stepCount)
	var curPoint: Vector2 = start_pos
	
	var sum: int = 0
	
	sum += write_circle(curPoint, 10, color)
	for i in range(0, stepCount):
		curPoint += stepSlope
		sum += write_circle(curPoint, 10, color)
		pass
	return sum


func write_circle(center: Vector2i, radius:int, color: Color):
	var x:int = 0
	var y:int = radius
	var d:int = 3 - (2 * radius)
	var sum: int = 0
	while x <= y:
		sum += write_pixel(Vector2i(center.x + x, center.y + y), color);
		sum += write_pixel(Vector2i(center.x - x, center.y + y), color);
		sum += write_pixel(Vector2i(center.x + x, center.y - y), color);
		sum += write_pixel(Vector2i(center.x - x, center.y - y), color);
		sum += write_pixel(Vector2i(center.x + y, center.y + x), color);
		sum += write_pixel(Vector2i(center.x - y, center.y + x), color);
		sum += write_pixel(Vector2i(center.x + y, center.y - x), color);
		sum += write_pixel(Vector2i(center.x - y, center.y - x), color);

		if (d < 0):
			d = d + (4 * x) + 6
		else:
			d = d + (4 * (x - y)) + 10
			y -= 1
		x += 1
	return sum

func write_pixel_plus(pos: Vector2i, color:Color):
	var sum: int = 0
	sum += write_pixel(pos, color)
	sum += write_pixel(pos + Vector2i(1,0), color)
	sum += write_pixel(pos + Vector2i(-1,0), color)
	sum += write_pixel(pos + Vector2i(0,1), color)
	sum += write_pixel(pos + Vector2i(0,-1), color)
	return sum

func lifted_up(pos: Vector2):
	usePrevPos = false
	pass

func add_jam_to_map(topping:GM.Toppings, amt:int):
	if not jamAmountsApplied.has(topping):
		jamAmountsApplied[topping] = amt
	else:
		jamAmountsApplied[topping] += amt
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	match GM.cursor.mode:
		GM.CursorMode.NONE:
			pass
		GM.CursorMode.KNIFE:
			if GM.input.leftClickCurrentlyPressed:
				if not GM.cursor.has_jam_left_on_it():
					return
				
				var finalpos:Vector2i = Vector2i(((event_position.x - minMaxX.x) / (minMaxX.y - minMaxX.x)) * imgTex.get_width(), ((event_position.z - minMaxZ.x) / (minMaxZ.y - minMaxZ.x)) * imgTex.get_height())
				var pxChanged: int = 0
				if usePrevPos:
					pxChanged = write_line(prevImagePos, finalpos, GM.cursor.curColor)
				else:
					pxChanged = write_pixel(finalpos, GM.cursor.curColor)
				prevImagePos = finalpos
				usePrevPos = true
				
				add_jam_to_map(GM.cursor.get_current_jam(), pxChanged)
				GM.cursor.apply_jam_pixels(pxChanged)
				
				print("frame:")
				var keys = jamAmountsApplied.keys()
				for i in range(0, keys.size()):
					print("\t",keys[i], ": ", jamAmountsApplied[keys[i]])
					pass
		
	pass
