extends RigidBody3D

var constant_speed := 90000.0
var _velocity := 0.0
var vLinear #linear velicoty (Vector3)

var turn := 0.0
var tilt := 0.0

var pos := Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	
	turn += Input.get_axis("move_left", "move_right")
	if turn == 0:
		turn = 0.01
	if turn > 180:
		turn = -180
	if turn < -180:
		turn = 180
	
	input.x = Input.get_axis("move_back", "move_forward") * sin(deg_to_rad(turn))
	input.z = Input.get_axis("move_forward", "move_back") * cos(deg_to_rad(turn))
	
	_velocity = constant_speed

	apply_central_force(input * _velocity * delta)
	
	vLinear = self.linear_velocity 
	
	
	
	if Input.is_action_pressed("move_back"):
		
		if $Mesh.rotation.x > deg_to_rad(0.0):
			tilt = lerp_angle($Mesh.rotation.x, 0, delta * 9)
			if $Mesh.rotation.x < 0.01:
					tilt = 0.0
		elif $Mesh.rotation.x <= 0.0:
			tilt = lerp_angle($Mesh.rotation.x,-deg_to_rad(sqrt(
				pow(vLinear.x, 2) +
				pow(vLinear.y, 2) + 
				pow(vLinear.z, 2)) / 10), delta * 36)
				
	elif Input.is_action_pressed("move_forward"):
		if $Mesh.rotation.x < deg_to_rad(0.0):
			tilt = lerp_angle($Mesh.rotation.x, 0, delta * 9)
			if $Mesh.rotation.x > -0.01:
					tilt = 0.0
		elif $Mesh.rotation.x >= 0.0:
			tilt = lerp_angle($Mesh.rotation.x,deg_to_rad(sqrt(
				pow(vLinear.x, 2) +
				pow(vLinear.y, 2) + 
				pow(vLinear.z, 2)) / 10), delta * 36)
	else:
			tilt = lerp_angle($Mesh.rotation.x, 0, delta * 1)
	
	#if input.x != 0 || input.z != 0:
	$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, 110.0 - deg_to_rad(turn), delta * 12)
	$Mesh.rotation.x = tilt
	$Mesh.rotation.x = clamp($Mesh.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	pos = self.global_position
	
	if pos.x < -800 || pos.x > 800:
		self.global_position.x = clamp(self.global_position.x, -800.0, 800.0)
		self.linear_velocity.x = 0
	if pos.z < -602 || pos.z > 602:
		self.global_position.z = clamp(self.global_position.z, -602.0, 602.0)
		self.linear_velocity.z = 0
	if pos.y < 200 || pos.y > 201:
		self.global_position.y = clamp(self.global_position.y, 200.0, 201.0)
		self.linear_velocity.y = 0
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
