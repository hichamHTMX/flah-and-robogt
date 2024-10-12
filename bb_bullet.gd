extends Node2D
 
@export var speed = 2000
var damage = 50
var direction = 1

func _ready():
	add_to_group('destroyer')
	add_to_group('playershot')

func _process(delta):
	position.x += speed * direction * delta


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group('destroyer'):
		area.get_parent().queue_free()
		queue_free()


func _on_area_2d_body_entered(body):
	if not body.is_in_group('player'):
		queue_free()
	
