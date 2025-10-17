extends Node
class_name Bread3D

var col: CollisionObject3D
var mesh: MeshInstance3D

var currentImage: Image
var texture: Texture2D
var mat: StandardMaterial3D
var imgTex: ImageTexture

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	
	mesh = $MeshInstance3D
	
	var mat: StandardMaterial3D = mesh.material_override
	currentImage = mat.albedo_texture.get_image()
	currentImage.decompress()
	texture = mat.albedo_texture
	imgTex = ImageTexture.new()
	imgTex = ImageTexture.create_from_image(currentImage)
	mat.albedo_texture = imgTex
	pass

func write_around_point(pos: Vector2i, color:Color):
	currentImage.set_pixelv(pos, color)
	imgTex.update(currentImage)
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if(event.is_action_pressed("left_click")):
		write_around_point(Vector2i(event_position.x,event_position.z), GM.cursor.curColor)
	pass
