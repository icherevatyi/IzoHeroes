extends HBoxContainer

var param_id: int

func init(title: String, value: String, id: int) -> void:
	get_node("ParamTitle").text = title
	get_node("ParamValue").text = value
	param_id = id
