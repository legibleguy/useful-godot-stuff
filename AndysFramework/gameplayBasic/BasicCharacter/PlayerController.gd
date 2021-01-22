
extends Camera
class_name PlayerController

var charClassRef = load("res://gameplayBasic/BasicCharacter/Character.gd")

var controlledChar : Character = null
var springArmRef : SpringArm = null

export var showMouse = false

export var InvertHorizontalInput = true
export var InvertVerticalInput = false
export var mouse_sensitivityX = -0.001
export var mouse_sensitivityY = -0.004

var controllerRotation : Vector3

const INPUT_F = "moveF"
const INPUT_B = "moveB"
const INPUT_L = "moveL"
const INPUT_R = "moveR"
const INPUT_JUMP = "jump"
const INPUT_LOOKX = ""
const INPUT_LOOKY = ""

func _input(event):
	if event is InputEventMouseMotion:
		if springArmRef: springArmRef.rotate_object_local(Vector3.RIGHT, event.relative.y * mouse_sensitivityY)
		if controlledChar: controlledChar.rotate_object_local(Vector3.UP, event.relative.x * mouse_sensitivityX)

func processInput(var delta):
	var f = Input.is_action_pressed(INPUT_F)
	var b = Input.is_action_pressed(INPUT_B)
	var r = Input.is_action_pressed(INPUT_R)
	var l = Input.is_action_pressed(INPUT_L)
	
	var totalVel = Vector3(0,0,0)
	
	if f and !b: totalVel = Vector3(0,0,1)
	elif !f and b: totalVel = Vector3(0,0,-1)
	
	if r and !l: totalVel += Vector3(1,0,0)
	elif !r and l: totalVel += Vector3(-1,0,0)
	
	if InvertHorizontalInput: totalVel *= Vector3(-1, 1, 1)
	if InvertVerticalInput: totalVel *= Vector3(1, 1, -1)
	
	controlledChar.setInputVel(totalVel)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if showMouse: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if get_parent() as Character:
		controlledChar = get_parent() as Character
	elif get_parent() as SpringArm:
		springArmRef = get_parent()
		controlledChar = get_parent().get_parent()
	if controlledChar: controlledChar.controller = self
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	processInput(delta)
