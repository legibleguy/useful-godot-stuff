
extends KinematicBody
class_name Character
#references
var capsule : CollisionShape
var floorTrace : RayCast
var controller = null
#rotation
export var InheritControllerRotX = false
export var InheritControllerRotY = false
export var InheritControllerRotZ = false
#movement input
var inputVelocity : Vector3
export var maxInputVel = 300.0
export var InputAccel = 20.0
#velocity related variables
var charVelocity : Vector3
var currentVelocity : Vector3
var lastPos : Vector3
#gravityy stuff
export var enableGravity = true
export var gravityDirection = Vector3(0,-1,0)
export var gravityAccel = 9.8
export var mass = 0.35
#closest point on the floor
func getCharFloorPos():
	floorTrace.force_raycast_update()
	return floorTrace.get_collision_point()

func getCharFloorNormal():
	floorTrace.force_raycast_update()
	return floorTrace.get_collision_normal()

func processGravity(var delta):
	if !is_on_floor():
		charVelocity += Vector3(charVelocity.x,abs(gravityAccel * mass * delta),charVelocity.z) * gravityDirection
	else: charVelocity = Vector3(charVelocity.x,0,charVelocity.z)

func setInputVel(var vel : Vector3):
	inputVelocity = vel

func addVel(var delta : Vector3):
	charVelocity += delta

# Called when the node enters the scene tree for the first time.
func _ready(): #gathering references
	capsule = get_child(0)
	lastPos = translation
	floorTrace = get_child(1)
	floorTrace.cast_to = gravityDirection * (capsule.shape as CapsuleShape).radius

func _physics_process(delta):
	#processing gravity
	if enableGravity: processGravity(delta)
	
	var localInput = to_global(inputVelocity) - translation
	
	move_and_slide_with_snap(charVelocity + localInput, Vector3(0,1,0))
	
	currentVelocity = translation - lastPos
