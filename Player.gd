extends RigidBody3D

var constant_speed := 6000.0
var _velocity := 0.0
var vLinear #linear velicoty (Vector3)

#@onready var $Mesh.rotation = $Mesh.rotation

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	if input.x != 0 && input.z != 0:
		_velocity = constant_speed / sqrt(2)
	else: 
		_velocity = constant_speed

	apply_central_force(input * _velocity * delta)
	
	vLinear = self.linear_velocity 
	
	if input.x != 0 || input.z != 0:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(vLinear.x, vLinear.z), delta * 12)
		$Mesh.rotation.x = lerp_angle($Mesh.rotation.x, 
			deg_to_rad(sqrt(
				pow(vLinear.x, 2) +
				pow(vLinear.y, 2) + 
				pow(vLinear.z, 2)
				)
			), delta * 36)
		$Mesh.rotation.x = clamp($Mesh.rotation.x, deg_to_rad(0), deg_to_rad(90))
		print("tilting")
	else:
		$Mesh.rotation.x = lerp_angle($Mesh.rotation.x, 0, delta * 2)
		print("standing")
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
