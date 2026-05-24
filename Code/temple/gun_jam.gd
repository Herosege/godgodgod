extends Node2D

@export var PermaDeactivate := true
@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var Shotgun = PNode.get_node("AnimatedSprite2D/Weapons/Shotgun")

var ID : String

var CRoomPos := Vector2.ZERO

var InJamRoom := false

var Active := true

func _enter_tree():
	ID = get_path()
	if PermaDeactivate:
		if STEvents.OneTimeJammers.has(ID):
			Active = false
			queue_free()

func _ready():
	
	if !PermaDeactivate:
		modulate = Color.hex(0xfffb00ff)
	
	CRoomPos.x = floor(global_position.x / Globals.VPort.x)
	CRoomPos.y = floor(global_position.y / Globals.VPort.y)

func _physics_process(delta):
	if Active:
		if PNode.CRoomPos == CRoomPos:
			Shotgun.Jammed = true
		if PNode.CRoomPos == CRoomPos and InJamRoom == false:
			InJamRoom = true
		if !(PNode.CRoomPos == CRoomPos) and InJamRoom == true:
			InJamRoom = false
			Shotgun.Jammed = false

func Die():
	Active = false
	Shotgun.Jammed = false
	$AnimatedSprite2D.visible = false
	$Sprite2D.visible = false
	if PermaDeactivate:
		STEvents.OneTimeJammers.append(ID)
	else:
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
	$CPUParticles2D.emitting = true
	await $CPUParticles2D.finished
	if PermaDeactivate:
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("damage"):
		Die()

func RESET():
	if !PermaDeactivate:
		$Area2D/CollisionShape2D.set_deferred("disabled",false)
		Shotgun.Jammed = false
		InJamRoom = false
		$CPUParticles2D.emitting = false
		Active = true
		$AnimatedSprite2D.visible = true
		$Sprite2D.visible = true
