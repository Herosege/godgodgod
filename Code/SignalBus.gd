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
signal EnemyKilled(Type)

signal Save(Type)

signal GetItem(Type)

signal LaunchPlayer(Vel)
