extends Node



func _on_vertex_time_time_multplier_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("TimeMultiplier",value)


func _on_vertex_time_uv_float_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("UVFloat",value)


func _on_vertex_time_sway_amount_value_changed(value):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("SwayAmount",value)


func _on_vertex_time_sway_on_y_toggled(toggled_on):
	$"TabContainer/2D/2DContainer/VertexTime/VertexTimeSprite".material.set_shader_parameter("SwayOnY",toggled_on)



func _on_voronoi_color_picker_color_changed(color):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("VectorNoiseAmount",Vector2(color.r,color.g))



func _on_voronoi_noise_offset_value_changed(value):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("Offset",value)



func _on_voronoi_collumn_value_changed(value):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("ColumnAmount",value)


func _on_voronoi_row_value_changed(value):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("RowAmount",value)


func _on_voronoi_use_time_toggled(toggled_on):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("UseTime",toggled_on)


func _on_voronoi_time_speed_value_changed(value):
	$"TabContainer/2D/2DContainer/VoronoiNoise/NoiseSprite".material.set_shader_parameter("TimeSpeed",value)

