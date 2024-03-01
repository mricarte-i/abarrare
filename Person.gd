extends Node3D

@onready var skeleton = $HumanArmature/Skeleton3D
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#physical_bones_start_simulation()
	pass

func walk() -> void:
	anim.play("Man_Walk")


func apply_physics(force: Vector3) -> void:
	skeleton.physical_bones_start_simulation()
	for phybone in skeleton.get_children():
		if phybone is PhysicalBone3D:
			phybone.apply_central_impulse(force)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
