extends Node2D


func ChWallVis(body,opacity,wallnode):
	if body.is_in_group("player"):
		wallnode.modulate.a = opacity

#1-bottle

func _on_in_body_entered(body):
	ChWallVis(body,0.3,$SecretTilemap)

func _on_out_body_entered(body):
	ChWallVis(body,1.0,$SecretTilemap)

#2-the cold patch exit

func _on_in_2_body_entered(body):
	ChWallVis(body,0.3,$sw2/SecretTilemap)

func _on_out_2_body_entered(body):
	ChWallVis(body,1.0,$sw2/SecretTilemap)


func _on_in_3_body_entered(body):
	ChWallVis(body,0.4,$sw4/PassBridge)

func _on_out_3_body_entered(body):
	ChWallVis(body,1.0,$sw4/PassBridge)
