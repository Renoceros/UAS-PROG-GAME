extends RigidBody3D

var mouse_sensitivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.z = Input.get_axis("move_left","move_right")
	input.x = Input.get_axis("move_backwards","move_forward")
	
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	twist_pivot.rotate_y(twist_input)
	$TwistPivot/PitchPivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x
		,deg_to_rad(-90)
		,deg_to_rad(90)
	)
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
