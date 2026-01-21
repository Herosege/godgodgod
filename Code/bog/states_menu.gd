extends Control



func _on_exit_btn_pressed():
	visible = false


func _on_hm_check_box_toggled(toggled_on):
	Globals.TravelingBack = toggled_on
