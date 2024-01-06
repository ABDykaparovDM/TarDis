extends RigidBody3D
"""var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0"""

var constant_speed := 6000.0
var _velocity := 0.0
var initVelocity 

"""@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot"""

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	if input.x != 0 && input.z != 0:
		_velocity = constant_speed / sqrt(2)
	else: 
		_velocity = constant_speed
	#twist_pivot.basis *
	apply_central_force( input * _velocity * delta)
	
	initVelocity = self.linear_velocity 
	
	if input.x != 0 || input.z != 0:
		$MeshInstance3D.rotation.y = lerp_angle($MeshInstance3D.rotation.y, atan2(initVelocity.x, initVelocity.z), delta * 12)
		
		$MeshInstance3D.rotation.x = lerp_angle($MeshInstance3D.rotation.x, deg_to_rad(
			sqrt(
				pow(initVelocity.x, 2) +
				pow(initVelocity.y, 2) + 
				pow(initVelocity.z, 2)
				)
			), 
		delta * 36)
			
		$MeshInstance3D.rotation.x = clamp($MeshInstance3D.rotation.x, deg_to_rad(0), deg_to_rad(90))
	else:
		$MeshInstance3D.rotation.x = lerp_angle($MeshInstance3D.rotation.x, 0, delta * 2)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	"""twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(-90))
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity"""
