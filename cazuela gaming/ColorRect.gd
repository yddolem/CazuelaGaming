extends ColorRect

var playerInverted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_inverted(isInverted):
	playerInverted = true
	update_shader()
	

func update_shader():
	if playerInverted:
		# Crea el efecto de tono azulado utilizando un VisualShade
		var visualShader = VisualShader.new()
		visualShader.set_code("""
			shader_type canvas_item;
			uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
			
			void fragment() {
				COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * vec4(0.0, 0.5, 1.0, 1.0);
			}
		""")

		# Aplica el VisualShader al material del ColorRect
		material = ShaderMaterial.new()
		material.set_shader(visualShader)

		# Carga y asigna la textura de la viñet

		# Aplica el material al ColorRect
		self.material = material
	else:
		material = null
		self.material = null
