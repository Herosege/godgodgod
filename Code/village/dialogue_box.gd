extends Control

var AwaitInput = false
var TextArray : Array
var ArrayIndex = 0

var AreaActive

var WaitTime = 0.15
var WaitTimeAfter = 0.04

@export var BoxSize = Vector2(960,240)
@export var ConstVisible = false

@onready var DTimer = $DialogueTimer
@onready var DTimerAfter = $DialogueTimerAfter
@onready var DisTimer = $DisappearTimer
@onready var BoxCont = $MarginContainer

var OnBottom = true

var AnimTween

#TextAnimation
const TEXTSCROLLTIME = 0.015

var TextTime = 0.0
var TextIndex = 0
var CharTime = TEXTSCROLLTIME
var LettersAtTime = 0.0

var CurText = ""

func _ready():
	BoxCont.set_deferred("size",BoxSize)
	BoxCont.pivot_offset = BoxCont.size / 2
	
	BoxCont.scale.y = 0.0
	if ConstVisible:
		AnimateBox(true)
	visible = ConstVisible
	SignalBus.DialStop.connect(EndDialogue)
	SignalBus.ShowDialogue.connect(ShowDialogue)

func _process(delta):
	#TextAnimation
	#Works accounting for your fps so you don't get faster scroll when vsync is off or when having a really shit pc
	if !CurText.is_empty():
		
		TextTime += delta
		if TextTime > CharTime:
			LettersAtTime = floor(TextTime / CharTime)
			TextTime = 0
			if LettersAtTime >= CurText.length():
				LettersAtTime = CurText.length()
			if LettersAtTime + TextIndex >= CurText.length():
				LettersAtTime = CurText.length() - TextIndex 
			for i in range(TextIndex,TextIndex + LettersAtTime):
				TextLabel.text += CurText[i] 
			TextIndex += LettersAtTime
			if TextIndex >= CurText.length():
				CurText = ""
			
	#Skips text if the text animation hasn't finished 
	if AwaitInput and Input.is_action_just_pressed("Confirm") and DTimer.is_stopped() and DTimerAfter.is_stopped():
		if CurText:
			TextLabel.text = CurText
			CurText = ""
		else:
			TextLabel.text = ""
			TextTime = 0.0
			TextIndex = 0
			CharTime = TEXTSCROLLTIME
			LettersAtTime = 0.0
			if TextArray.size() > ArrayIndex + 1:
				ArrayIndex += 1
				DTimerAfter.start(WaitTimeAfter)
				SetText(TextArray[ArrayIndex])
			else:
				EndDialogue(false)

@onready var TextLabel = $MarginContainer/Panel/MarginContainer/Label

var SenderID

#IsPaused is true if your game is paused when in dialogue
#Skippable is true when you can skip dialogue by pressing accept button
#OptionalTimer doesn't have to be passed but it counts down to when window disappears, best used when skippable is false 
func ShowDialogue(TextArr,OnBottom := true,ID = 0,IsPaused : bool = true,Skippable : bool = true,OptionalTimer : float = 0.0):
	$MarginContainer.position = Vector2(0.0,320.0) if OnBottom else Vector2.ZERO
	TextLabel.text = ""
	TextTime = 0.0
	TextIndex = 0
	SenderID = ID
	CharTime = TEXTSCROLLTIME
	LettersAtTime = 0.0
	AnimateBox(true)
	SetText("")
	if !TextArr: 
		return
	Globals.InDialogue = IsPaused
	visible = true
	ArrayIndex = 0
	TextArray = TextArr
	SetText(TextArray[0])
	AwaitInput = Skippable
	if Skippable:
		DTimer.start(WaitTime)
	if OptionalTimer:
		DisTimer.start(OptionalTimer)

func SetText(text):
	CurText = text
	#TextLabel.text = text

func EndDialogue(Early:bool):
	SetText("")
	AwaitInput = false
	Globals.InDialogue = false
	AnimateBox(false)
	SignalBus.emit_signal("DialFinish",Early,SenderID)

func _on_disappear_timer_timeout():
	EndDialogue(false)

func AnimateBox(In):
	if AnimTween:
		AnimTween.kill()
	AnimTween = create_tween()
	
	if In:
		AnimTween.tween_property(BoxCont,"scale",Vector2(1.0,1.0),0.2).set_trans(Tween.TRANS_QUAD)
	else:
		AnimTween.tween_property(BoxCont,"scale",Vector2(1.0,0.0),0.2).set_trans(Tween.TRANS_QUAD)
		AnimTween.tween_callback(self.hide)
