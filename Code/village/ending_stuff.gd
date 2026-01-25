extends CanvasLayer

func EndGame(EndType,Traveling:=true,ExState:=-1):
	
	Globals.stoptime = true
	
	Globals.Endings[EndType] = true
	if ExState==-1:
		Globals.NumTimesBeatGame += 1
		if Globals.SaveTime < Globals.BestTime or !Globals.BestTime:
			Globals.BestTime = Globals.SaveTime
		if Globals.NumDeaths < Globals.LDeaths or Globals.LDeaths == -1:
			Globals.LDeaths = Globals.NumDeaths
	else:
		
		Globals.ExStatesRecords[ExState][Globals.StateRec.NumTimesBeat] += 1
		if Globals.SaveTime < Globals.ExStatesRecords[ExState][Globals.StateRec.BTime] or !Globals.ExStatesRecords[ExState][Globals.StateRec.BTime]:
			Globals.ExStatesRecords[ExState][Globals.StateRec.BTime] = Globals.SaveTime
		if Globals.NumDeaths < Globals.ExStatesRecords[ExState][Globals.StateRec.BDeath] or Globals.ExStatesRecords[ExState][Globals.StateRec.BDeath] == -1:
			Globals.ExStatesRecords[ExState][Globals.StateRec.BDeath] = Globals.NumDeaths
		print(Globals.ExStatesRecords[ExState][Globals.StateRec.NumTimesBeat])
		print(Globals.ExStatesRecords[ExState][Globals.StateRec.BDeath])
		print(Globals.ExStatesRecords[ExState][Globals.StateRec.BTime])
	
	
	var time = Globals.sec_to_time(Globals.SaveTime)
	var hrs = "" if !time[2] else str(time[2]) + " hours "
	var min = "" if !time[1] else str(time[1]) + " minutes "
	
	if Traveling:
		$Label.text = "You won!"
	else:
		$Label.text = "PERMANENT MEMORY ATTAINED"
	
	$Label2.text = "Final time: " + hrs + min + str(time[0]) + " seconds"
	$Label2.visible = true
	$Label.visible = true
	
	$Label3.text = "You died " + str(int(Globals.NumDeaths)) + " times"
	$Label3.visible = true
	
	Globals.SavePerma()
	Globals.SaveData(666)
	if Traveling:
		Globals.TravelBack()
