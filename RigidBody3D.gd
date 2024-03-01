extends RigidBody3D

var collision_force = Vector3.ZERO
var prev_linear_velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_punch(force: Vector3) -> void:
	apply_central_impulse(force)
	print("auch")

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	collision_force = Vector3.ZERO
	
	if state.get_contact_count() > 0:
		var dv = state.linear_velocity - prev_linear_velocity
		collision_force = dv / (state.inverse_mass * state.step)
	
	var dmg = collision_force.length() / 2000 - 2
	if dmg > 0:
		print("apply some dmg", dmg)
	prev_linear_velocity = state.linear_velocity
