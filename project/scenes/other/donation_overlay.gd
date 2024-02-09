extends Panel

@onready var parent = $".."

func _on_yes_pressed():
	await OS.shell_open("https://www.buymeacoffee.com/diceccoj")
	parent.queue_free()
