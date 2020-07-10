extends CanvasLayer

onready var parent_container: Control = $Control
onready var input_box: LineEdit = $Control/LineEdit
onready var text_box: TextEdit = $Control/TextEdit
onready var command_handler: Node2D = $CommandHandler

func _ready() -> void:
	input_box.grab_focus()


func output_text(text: String) -> void:
	text_box.set_text(str(text_box.text, "\n", text))


func process_command(text: String) -> void:
	var words = text.split(" ")
	words = Array(words)

	for _i in range(words.count("")):
		words.erase("")

	if words.size() == 0:
		return

	var command_word: String = words.pop_front()

	for i in command_handler.command_list:
		var command_item = command_handler.command_list[i]
		if command_item.command == command_word:
			if words.size() != command_item.arguments.size():
				output_text(str("Wrong number of arguments for '", command_word, "' command. Expected ",  command_item.arguments.size()))
				return
			for word_item in range(words.size()):
				if not _check_type(words[word_item], command_item.arguments[word_item]):
					output_text(str("Execution of '", command_word, "' failed. Parameter (", words[word_item], ") is of the wrong type."))
					return
			command_handler.callv(command_word, words)
			return
	output_text(str("Command ", command_word, " doesn't exist"))


func _check_type(argument: String, type: int):
	match type:
		command_handler.ARG_BOOL:
			return (argument == "true" or argument == "false")
		command_handler.ARG_INT:
			return argument.is_valid_integer()
		command_handler.ARG_STRING:
			return true
		command_handler.ARG_FLOAT:
			return argument.is_valid_float()


func _on_LineEdit_text_entered(new_text: String) -> void:
	process_command(new_text)
	input_box.clear()


func _on_LineEdit_text_changed(new_text) -> void:
	if new_text == "~" or new_text == "`":
		input_box.clear()
	
