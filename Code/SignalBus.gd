extends Node

#general
signal Death
signal ResetPos

#misc
signal ScreenShaderChange(value,type)

signal HudMessage(message)

#combat
signal TriggerBoss(Type)
signal BossDead(Type)
signal GetWeapon(Type)

signal Save(Type)

signal GetItem(Type)
