extends Node

#general
signal Death
signal ResetPos

#misc
signal ScreenShaderChange(value,type)

signal SetHudMessage(message,type,time)

#combat
signal TriggerBoss(Type)
signal BossDead(Type)
signal GetWeapon(Type)
signal EnemyKilled(Type)

signal Save(Type)

signal GetItem(Type)

signal ShotgunUse(Vel)

signal LaunchPlayer(Vel)

signal FOrbUse

signal ShowDialogue(TextArr,OnBottom,ID,IsPaused,Skippable,OptionalTimer)
signal DialStop
signal DialFinish(Early,ID)

signal SetPlayerPosition(Pos)

signal GetInDial(State,Type,Early)

signal ShotgunTimerHudUpdate(TimeRemaining,MaxTime)

signal SettingChanged()

signal BossHeartDamage(Dmg)

signal KillPlayer

signal PlaySoundEffect(SoundID)
