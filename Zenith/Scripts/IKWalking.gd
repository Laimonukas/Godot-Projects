extends CharacterBody3D

@export var legTargets : Array[Marker3D] = []
@export var skeletonIKArray : Array[SkeletonIK3D] = []

var passedTimeFrac : float = 0.0
var passedTime : float = 0.0

var legDelta : float = 0.0

func _ready():
	for ik in skeletonIKArray:
		ik.start()

func _process(delta):
	HandleLegMovement(delta)
	pass
	
	
func HandleInputAndVelocity(delta):
	if Input.is_action_pressed("Forward"):
		velocity += Vector3.FORWARD
	if Input.is_action_pressed("Backward"):
		velocity += Vector3.BACK

func HandleLegMovement(delta):
	legDelta += delta
	legTargets[0].position.z = 0.4 * sin(legDelta)
	legTargets[1].position.z = 0.4 * sin(legDelta + 3.14)
	
	legTargets[0].position.y = 0.4 * clamp(sin(legDelta),0.0,1.0)
	legTargets[1].position.y = 0.4 * clamp(sin(legDelta + 3.14),0.0,1.0)
	pass

func Fract(x : float):
	return x - floor(x)

func HandleTime(delta):
	passedTime += delta
	if passedTime >= 10.0:
		passedTime = 0.0
	passedTimeFrac = Fract(passedTime)
