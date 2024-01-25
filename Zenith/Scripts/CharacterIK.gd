@tool

extends CharacterBody3D

class_name CharacterIK

@export var skeleton : Skeleton3D

@export var boneLength : float = 10.0

@export var leftUpperLeg : Marker3D
@export var leftKnee : Marker3D
@export var leftFoot : Marker3D

@export var leftLeg : Array[BoneAttachment3D]


func _ready():
	if Engine.is_editor_hint():
		pass

func _process(delta):
	if Engine.is_editor_hint():
		RotateBone(leftLeg,leftFoot)
		pass

func RotateBone(boneRange : Array[BoneAttachment3D], target :Marker3D):
	
	## IK follow
	var bPoint = leftFoot.global_position
	var aPoint = leftKnee.global_position
	var dirToBpoint = (aPoint - bPoint).normalized()
	leftKnee.look_at(bPoint,Vector3.FORWARD)
	
	
	aPoint = bPoint + dirToBpoint * boneLength
	leftKnee.global_position = aPoint
	DebugDraw3D.draw_line(aPoint,bPoint)
	
	bPoint = aPoint
	aPoint = leftUpperLeg.global_position
	dirToBpoint = (aPoint - bPoint).normalized()
	leftUpperLeg.look_at(leftKnee.global_position,Vector3.FORWARD)
	
	aPoint = bPoint + dirToBpoint * boneLength
	leftUpperLeg.global_position = aPoint
	DebugDraw3D.draw_line(aPoint,bPoint,Color.RED)
	
	## Rebase IK to a fixed Point
	
	bPoint = leftKnee.global_position
	aPoint = leftLeg[0].global_position
	dirToBpoint = (bPoint - aPoint).normalized()
	leftUpperLeg.look_at(bPoint,Vector3.FORWARD)
	bPoint = aPoint + dirToBpoint * boneLength
	leftUpperLeg.global_position = aPoint
	DebugDraw3D.draw_line(aPoint,bPoint,Color.BLUE)
	
	aPoint = bPoint
	bPoint = leftFoot.global_position
	dirToBpoint = (bPoint - aPoint).normalized()
	leftKnee.look_at(bPoint,Vector3.FORWARD)
	leftKnee.global_position = aPoint
	bPoint = aPoint + dirToBpoint * boneLength
	DebugDraw3D.draw_line(aPoint,bPoint,Color.BLUE)
	pass


