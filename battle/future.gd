extends Control

@onready var rich_text_label = $RichTextLabel
@export var max_line = 40

var texts = []

var text_times = []

func add_text(text):
	rich_text_label.text = ""
	if texts.size() > 1 and text == texts[-1]:
		text_times[-1] += 1
	else:
		texts.append(text)
		text_times.append(1)
	if texts.size() > max_line:
		texts = ["..."]+texts.slice(texts.size()-max_line, texts.size())
	for i in texts.size():
		if text_times[i] == 1:
			rich_text_label.text += texts[i]
		else:
			rich_text_label.text += texts[i]+"x"+str(text_times[i])
		rich_text_label.text += "\n"
