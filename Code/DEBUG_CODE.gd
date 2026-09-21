extends Node

@onready var DebugSaveLoc = [
	Vector2(109,206), #Coords
	0 #Area
]

func _ready():
	if OS.is_debug_build():
		pass
		#BeerRoom - Curse
		#DebugSaveLoc[0] = Vector2(-600,1290)
		#DebugSaveLoc[1] = 1
		#SpecialItem = true
		#Start - Curse
		
		
		#onen - main
		#DebugSaveLoc[0] = Vector2(4200,-100)
		
		#Bridge - main
		#DebugSaveLoc[0] = Vector2(5200,-220)
		
		#henryk - main
		#DebugSaveLoc[0] = Vector2(3600,800)
		#
		#SecretMilk - main
		#DebugSaveLoc[0] = Vector2(1664,-96)
		
		#connector - main
		#DebugSaveLoc[0] = Vector2(1860,290)
		
		#Boss - curse
		#DebugSaveLoc[0] = Vector2(1480,380)
		#DebugSaveLoc[1] = 1
		
		#UnderBridge - main
		#DebugSaveLoc[0] = Vector2(7700,400)
		
		#UnderBridge2 - main
		#DebugSaveLoc[0] = Vector2(8400,320)
		
		#SECRET BRIDGE - main
		#DebugSaveLoc[0] = Vector2(7050,-125)
		
		
		#start - village
		#DebugSaveLoc[0] = Vector2(60,400)
		#DebugSaveLoc[1] = 2
		
		#tower clouds - village
		#DebugSaveLoc[0] = Vector2(935,-632)
		#DebugSaveLoc[1] = 2
		
		#first island - village
		#DebugSaveLoc[0] = Vector2(570,-1624)
		#DebugSaveLoc[1] = 2
		
		#back to tower after island - village
		#DebugSaveLoc[0] = Vector2(980,-2010)
		#DebugSaveLoc[1] = 2
		
		#Tower after chain jumping - villagze
		#DebugSaveLoc[0] = Vector2(790,-3495)
		#DebugSaveLoc[1] = 2
		
		#tower moving objects start - village
		#DebugSaveLoc[0] = Vector2(662,-4053)
		#DebugSaveLoc[1] = 2
		
		#tower last challenge - village
		#DebugSaveLoc[0] = Vector2(101,-4863)
		#DebugSaveLoc[1] = 2
		
		#village - village 
		#DebugSaveLoc[0] = Vector2(1101,-5883)
		#DebugSaveLoc[1] = 2
		
		#FakeHall - start
		#DebugSaveLoc[0] = Vector2(530,-440)
		#DebugSaveLoc[1] = 4
		
		#FakeHall - third obstacle
		#DebugSaveLoc[0] = Vector2(1980,375)
		#DebugSaveLoc[1] = 4
		
		#FakeHall - sixth obstacle
		#DebugSaveLoc[0] = Vector2(3880+640,375)
		#DebugSaveLoc[1] = 4
		
		#village - EXTRA
		#DebugSaveLoc[0] = Vector2(9043,-26)
		#DebugSaveLoc[1] = 2
		
		#village - EXTRA2
		#DebugSaveLoc[0] = Vector2(9146,-97)
		#DebugSaveLoc[1] = 2
		
		#village - EXTRA3
		#DebugSaveLoc[0] = Vector2(9080,-194)
		#DebugSaveLoc[1] = 2
		
		#Bog - start
		#DebugSaveLoc[0] = Vector2(120,400)
		#DebugSaveLoc[1] = 5
		
		#main - traveling - past moving spikes
		#DebugSaveLoc[0] = Vector2(1664,-96)
		#DebugSaveLoc[1] = 6
		
		###main - traveling - new stuff start
		#DebugSaveLoc[0] = Vector2(2030,444)
		#DebugSaveLoc[1] = 6
		
		#main - traveling - new stuff 2
		#DebugSaveLoc[0] = Vector2(2630,-80)
		#DebugSaveLoc[1] = 6
		
		#Curse world - traveling - past balls
		#DebugSaveLoc[0] = Vector2(2000,1160)
		#DebugSaveLoc[1] = 7
		
		#Curse world - traveling - past exjumps
		#DebugSaveLoc[0] = Vector2(2600,940)
		#DebugSaveLoc[1] = 7
		
		#Curse world - traveling - past gate
		#DebugSaveLoc[0] = Vector2(-126,908)
		#DebugSaveLoc[1] = 7
		
		#Curse world - traveling - boss
		#DebugSaveLoc[0] = Vector2(-1696,540)
		#DebugSaveLoc[1] = 7
		
		#Temple - start 
		#DebugSaveLoc[0] = Vector2(319,-560)
		#DebugSaveLoc[1] = 8
		
		#Temple - secret right
		#DebugSaveLoc[0] = Vector2(1590,-980)
		#DebugSaveLoc[1] = 8
		
		#Temple - right 4 room
		#DebugSaveLoc[0] = Vector2(2330,-1024)
		#DebugSaveLoc[1] = 8
		#DebugSaveLoc[0] = Vector2(2177,-1490)
		#DebugSaveLoc[1] = 8
		
		#Temple - left upper start 
		#DebugSaveLoc[0] = Vector2(-1840,-1040)
		#DebugSaveLoc[1] = 8
		
		#Temple - left roof 
		#DebugSaveLoc[0] = Vector2(-720,-1610)
		#DebugSaveLoc[1] = 8
		
		#Temple - upper tower 
		#DebugSaveLoc[0] = Vector2(670,-2920)
		#DebugSaveLoc[1] = 8
		
		#Temple - half pyramid tip
		#DebugSaveLoc[0] = Vector2(2446,-2990)
		#DebugSaveLoc[1] = 8
		
		#Temple - gungungun
		#DebugSaveLoc[0] = Vector2(4065,-2100)
		#DebugSaveLoc[1] = 8
		
		#Temple - horse boss 
		#DebugSaveLoc[0] = Vector2(1350,-3400)
		#DebugSaveLoc[1] = 8
		
		#Village - World's edge
		DebugSaveLoc[0] = Vector2(11600,700)
		DebugSaveLoc[1] = 8
		STEvents.EventArray[STEvents.Enums.FakeHallEndCutscene] = true
