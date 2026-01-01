extends Resource
class_name TextRes

@export var TextArr : Array[MSArray]

func ConvertToString():
	var TempArr = []
	for i in TextArr.size():
		TempArr.append(TextArr[i].MStr)
	return TempArr
