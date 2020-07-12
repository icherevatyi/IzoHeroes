extends HBoxContainer

func init(title: String, value: float) -> void:
	get_node("ParamTitle").text = title
	get_node("ParamValue").text = str(value)
