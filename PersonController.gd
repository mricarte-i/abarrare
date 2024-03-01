extends RigidBody3D

@export var target: Node3D
@export var SPEED = 10.0

@onready var skin = $skin
@onready var anim = $AnimationPlayer
@onready var coll = $CollisionShape3D

var isDead = false
@export var isAberrant = false

var collision_force = Vector3.ZERO
var prev_linear_velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skin.walk()

func look_follow(state, current_transform, target_pos) -> void:
	var forward_local_axis = Vector3(1,0,0)
	var forward_dir = (current_transform.basis * forward_local_axis).normalized()
	var target_dir = (target_pos - current_transform.origin).normalized()
	var local_speed = clampf(SPEED, 0, acos(forward_dir.dot(target_dir)))
	look_at(target_pos)
	apply_central_impulse(SPEED * target_dir)
	#if forward_dir.dot(target_dir) > 1e-4:
	#	state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func apply_punch(force: Vector3) -> void:
	apply_central_impulse(force)
	print("auch")
	skin.apply_physics()
	isDead = true
	coll.disabled = true
	anim.play("death")
	
func death():
	print("death to me")
	if isAberrant:
		print("-1 EVIL")
	else:
		print("oops")
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	collision_force = Vector3.ZERO
	
	if state.get_contact_count() > 0:
		var dv = state.linear_velocity - prev_linear_velocity
		collision_force = dv / (state.inverse_mass * state.step)
	
	var dmg = collision_force.length() / 2000 - 2
	if dmg > 0:
		print("apply some dmg", dmg)
	prev_linear_velocity = state.linear_velocity
	
	if !isDead and target != null:
		look_follow(state, global_transform, target.global_transform.origin)
