extends Control


@onready var debug_label: Label = $DebugLabel

func update_debug(text: String) -> void:
	debug_label.text = text
