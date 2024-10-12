extends Node2D

@export var range: float = 1000
@export var speed = 100
@onready var target = $"../Wire"
@onready var timer = $Timer
@onready var bullet = preload("res://t_bullet.tscn")
@onready var sprite = $Sprite2D
var health = 100
var can_shoot = false

var original_color = Color(1, 1, 1, 1)
var damage_color = Color(1, 0, 0, 1)
var flash_duration = 0.2


func _ready():
	if target.position.x < position.x:
		sprite.scale.x *= -1
		
	timer.start()

func _process(delta):
	if target.position.x - position.x > range or position.x - target.position.x > range:
		position.x = move_toward(position.x , target.position.x , speed * delta)
	else:
		shoot()
		
func shoot():
	if can_shoot:
		var new_bullet = bullet.instantiate()
		new_bullet.position = global_position
		get_parent().add_child(new_bullet)
		
		if sprite.scale.x > 0:
			new_bullet.direction = 1
		else:
			new_bullet.direction = -1
		can_shoot = false
		timer.start()

func _on_timer_timeout():
	can_shoot = true

func take_damage(damage):
	health -= damage
	flash_red()
	if health <= 0:
		queue_free()

func flash_red():
	sprite.modulate = damage_color
	await get_tree().create_timer(flash_duration).timeout
	sprite.modulate = original_color


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group('playershot'):
		area.get_parent().queue_free()
		take_damage(50)
