extends CharacterBody3D

@export var legTargets : Array[Marker3D] = []
@export var skeletonIKArray : Array[SkeletonIK3D] = []
@export var hipsBone : BoneAttachment3D

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
	legTargets[0].position.z = 0.4 * sin(deg_to_rad(90.0 * legDelta))
	legTargets[1].position.z = 0.4 * sin(deg_to_rad(90.0 * legDelta + 180.0))
	
	legTargets[0].position.y = 0.4 * cos(deg_to_rad(90.0 * legDelta))
	legTargets[1].position.y = 0.4 * cos(deg_to_rad(90.0 * legDelta + 180.0))
	
	hipsBone.position.y = lerp(0.890,0.700,cos(deg_to_rad(90.0 * legDelta)))
	
	pass

func Fract(x : float):
	return x - floor(x)

func HandleTime(delta):
	passedTime += delta
	if passedTime >= 10.0:
		passedTime = 0.0
	passedTimeFrac = Fract(passedTime)
