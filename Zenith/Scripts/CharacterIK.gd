@tool

extends CharacterBody3D

class_name CharacterIK

@export var skeleton : Skeleton3D

@export var boneLength : float = 10.0

@export var leftUpperLeg : Marker3D
@export var leftKnee : Marker3D
@export var leftFoot : Marker3D
@export var helper : Marker3D

@export var leftLeg : Array[BoneAttachment3D]

func _ready():
	if Engine.is_editor_hint():
		pass

func _process(delta):
	if Engine.is_editor_hint():
		#RotateBone(leftLeg,leftFoot)
		RotateMarkers()
		pass

func RotateMarkers():
	leftKnee.look_at(leftFoot.global_position,Vector3.FORWARD)



func RotateBone(boneRange : Array[BoneAttachment3D], target :Marker3D):
	
	## IK follow
	var bPoint = leftFoot.global_position
	var aPoint = leftKnee.global_position
	var dirToBpoint = (aPoint - bPoint).normalized()
	var dirToHelper = (helper.global_position - aPoint).normalized()
	#DebugDraw3D.draw_line(aPoint,aPoint+ dirToHelper,Color.GREEN)
	#leftKnee.look_at(bPoint,Vector3.FORWARD)
	
	
	aPoint = bPoint + (dirToHelper * 0.01) +  dirToBpoint * boneLength 
	leftKnee.global_position = aPoint
	#DebugDraw3D.draw_line(aPoint,bPoint)
	
	bPoint = aPoint
	aPoint = leftUpperLeg.global_position
	dirToBpoint = (aPoint - bPoint).normalized()
	#leftUpperLeg.look_at(leftKnee.global_position,Vector3.FORWARD)
	
	aPoint = bPoint + dirToBpoint * boneLength
	leftUpperLeg.global_position = aPoint
	#DebugDraw3D.draw_line(aPoint,bPoint,Color.RED)
	
	## Rebase IK to a fixed Point
	
	bPoint = leftKnee.global_position
	aPoint = leftLeg[0].global_position
	dirToBpoint = (bPoint - aPoint).normalized()
	#leftUpperLeg.look_at(bPoint,Vector3.FORWARD)
	bPoint = aPoint + dirToBpoint * boneLength
	leftUpperLeg.global_position = aPoint
	DebugDraw3D.draw_line(aPoint,bPoint,Color.BLUE)
	
	aPoint = bPoint
	bPoint = leftFoot.global_position
	dirToBpoint = (bPoint - aPoint).normalized()
	#leftKnee.look_at(bPoint,Vector3.FORWARD)
	leftKnee.global_position = aPoint
	bPoint = aPoint + dirToBpoint * boneLength
	DebugDraw3D.draw_line(aPoint,bPoint,Color.BLUE)
	
	
	#rotation
	# damn euler, damn quaternion


	leftLeg[0].position = leftUpperLeg.position
	leftLeg[1].position = leftKnee.position
	
	
	#Upper leg
	var v1 = Vector2(leftLeg[0].global_position.y,leftLeg[0].global_position.z)
	var v2 = Vector2(leftKnee.global_position.y,leftKnee.global_position.z)
	var xRot = v2.angle_to_point(v1)
	v1 = Vector2(leftLeg[0].global_position.z,leftLeg[0].global_position.x)
	v2 = Vector2(leftKnee.global_position.z,leftKnee.global_position.x)
	var yRot = v1.angle_to_point(v2)
	
	
	var oldAngle = leftLeg[0].rotation.y
	if leftKnee.position.z <= 0.1:
		
		leftLeg[0].rotation.y = clampf(lerp_angle(oldAngle,v2.angle_to_point(v1),\
			clampf(leftKnee.position.z*-1,0.0,1.0)),deg_to_rad(-45.0),deg_to_rad(45.0))
	else:
		
		leftLeg[0].rotation.y = lerp_angle(oldAngle,yRot,clampf(leftKnee.position.z * 3,0.0,1.0))
		
	leftLeg[0].rotation.x = xRot
	
	#lower leg
	v1 = Vector2(leftLeg[1].global_position.y,leftLeg[1].global_position.z)
	v2 = Vector2(leftFoot.global_position.y,leftFoot.global_position.z)
	xRot = v2.angle_to_point(v1)
	v1 = Vector2(leftLeg[1].global_position.z,leftLeg[1].global_position.x)
	v2 = Vector2(leftFoot.global_position.z,leftFoot.global_position.x)

	
	
	oldAngle = leftLeg[1].rotation.y
	if leftFoot.position.z < leftKnee.position.z:
		leftLeg[1].rotation.y = lerp_angle(oldAngle,v1.angle_to_point(v2),0.9)
	else:
		leftLeg[1].rotation.y = lerp_angle(oldAngle,v2.angle_to_point(v1),0.9)
		
	leftLeg[1].rotation.x = xRot * -1.0
	
	
	
	
	pass
	

# 0 xy , 1 yz , 2 xz
func GetV2FromV3(v3 : Vector3,pair : int = 0):
	match pair:
		0:
			return Vector2(v3.x,v3.y)
		1:
			return Vector2(v3.y,v3.z)
		2: 
			return Vector2(v3.x,v3.z)
		
