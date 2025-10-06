extends CanvasLayer

func EndGame(EndType):
	
	Globals.stoptime = true
	
	Globals.Endings[EndType] = true
	Globals.NumTimesBeatGame += 1
	if Globals.SaveTime < Globals.BestTime or !Globals.BestTime:
		Globals.BestTime = Globals.SaveTime
	if Globals.NumDeaths < Globals.LDeaths or Globals.LDeaths == -1:
		Globals.LDeaths = Globals.NumDeaths
	
	var time = Globals.sec_to_time(Globals.SaveTime)
	var hrs = "" if !time[2] else str(time[2]) + " hours "
	var min = "" if !time[1] else str(time[1]) + " minutes "
	
	$Label2.text = "Final time: " + hrs + min + str(time[0]) + " seconds"
	$Label2.visible = true
	$Label.visible = true
	
	$Label3.text = "You died " + str(int(Globals.NumDeaths)) + " times"
	$Label3.visible = true
	
	Globals.SavePerma()
	Globals.SaveData(666)
