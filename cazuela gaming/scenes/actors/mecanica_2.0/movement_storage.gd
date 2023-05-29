class_name MovementStorage
extends Object

## Clase abstracta para almacenar movimientos

enum MOVEMENT_TYPE {STANDING,WALK,JUMP}
var type : MOVEMENT_TYPE

## Clase para almacenar cuanto tiempo estuvo quieto el jugador
class Standing extends MovementStorage:
	var position : Vector2:
		set(value):
			position = value
			duration = (Time.get_ticks_msec() - _start_timestamp) / 1000.0
	var _start_timestamp : int
	var duration : float = 0.0
	
	func _init():
		type = MOVEMENT_TYPE.STANDING
		_start_timestamp = Time.get_ticks_msec()

## Para almacenar el movimiento hacia una dirección específica
## se asume velocidad constante
class Walking extends MovementStorage:
	var initial_position : Vector2
	var final_position : Vector2:
		set(value):
			duration = (Time.get_ticks_msec() - _start_timestamp) / 1000.0
			final_position = value
	var _start_timestamp : int
	var duration : float = 0.0
	
	func _init(position:Vector2):
		type = MOVEMENT_TYPE.WALK
		initial_position = position
		_start_timestamp = Time.get_ticks_msec()

## Para almacenar un salto
## se asume velocidad horizontal constante
class Jumping extends MovementStorage:
	var initial_position : Vector2
	var max_height_position : Vector2:
		set(value):
			max_height_position = value
			_max_height_timestamp = Time.get_ticks_msec()
			jump_duration = (_max_height_timestamp - _start_timestamp) / 1000.0
	var final_position : Vector2:
		set(value):
			final_position = value
			fall_duration = (Time.get_ticks_msec() - _max_height_timestamp) / 1000.0
	var _start_timestamp : int
	var _max_height_timestamp : int
	var jump_duration : float = 0.0
	var fall_duration : float = 0.0
	
	func _init(position:Vector2):
		type = MOVEMENT_TYPE.JUMP
		initial_position = position
		_start_timestamp = Time.get_ticks_msec()
