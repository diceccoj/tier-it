extends Control

@onready var volume_value = $VolumeValue
@onready var volume_slider = $VolumeSlider
@onready var volume_value_se = $VolumeValueSE
@onready var volume_slider_se = $VolumeSliderSE
@onready var screen_mode = $ScreenMode


const autosave_dir : String = "user://autosave/"
const autosave_path : String = autosave_dir + "autosave.tres"
var autosave = AutoSave.new()
#checks autosave resource for volume information
func _ready():
	#verify save directory and load volume and screenmode
	DirAccess.make_dir_absolute(autosave_dir)
	if(!ResourceLoader.exists(autosave_path)):
		ResourceSaver.save(autosave, autosave_path)
	autosave = ResourceLoader.load(autosave_path)
	volume_slider.value = autosave.volume
	volume_value.text = str(autosave.volume)
	AudioServer.set_bus_volume_db(2, linear_to_db(volume_slider.value/100))
	volume_slider_se.value = autosave.se_volume
	volume_value_se.text = str(autosave.se_volume)
	AudioServer.set_bus_volume_db(1, linear_to_db(volume_slider_se.value/25))
	
	if (autosave.fullscreen):
		screen_mode.text = "Fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		screen_mode.text = "Windowed"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_quit_pressed():
	get_tree().quit()

#updates main audio channel volume
func _on_volume_slider_value_changed(value):
	volume_value.text = str(value)
	AudioServer.set_bus_volume_db(2, linear_to_db(value/100))
	autosave.volume = value
	ResourceSaver.save(autosave, autosave_path)




func _on_volume_slider_se_value_changed(value):
	volume_value_se.text = str(value)
	AudioServer.set_bus_volume_db(1, linear_to_db(value/25))
	autosave.se_volume = value
	ResourceSaver.save(autosave, autosave_path)
	

#sets fullscreen or windowed mode
func _on_screen_mode_pressed():
	autosave.fullscreen = !autosave.fullscreen
	ResourceSaver.save(autosave, autosave_path)
	if (autosave.fullscreen):
		screen_mode.text = "Fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		screen_mode.text = "Windowed"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func _on_blank_button_pressed():
	OS.shell_open("https://www.buymeacoffee.com/diceccoj")
