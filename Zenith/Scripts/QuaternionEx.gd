@tool

extends Node3D

@export var cube : MeshInstance3D 
@export var pointer : MeshInstance3D

func _process(delta):
	if Engine.is_editor_hint():
		DebugDraw3D.draw_line(cube.position,cube.position + cube.basis.x,Color.RED)
		DebugDraw3D.draw_line(cube.position,cube.position + cube.basis.y,Color.GREEN)
		DebugDraw3D.draw_line(cube.position,cube.position + cube.basis.z,Color.BLUE)
		
		print("\n\n\n\n\n\n\n\n\n\n\n")
		print(cube.rotation_degrees)
		
		pass
		#cube.look_at(pointer.position,Vector3.UP)
	
