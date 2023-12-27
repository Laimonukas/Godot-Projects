extends Node



func _on_vertex_time_time_multplier_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("TimeMultiplier",value)


func _on_vertex_time_uv_float_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("UVFloat",value)


func _on_vertex_time_sway_amount_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("SwayAmount",value)


func _on_vertex_time_sway_on_y_toggled(toggled_on):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("SwayOnY",toggled_on)
