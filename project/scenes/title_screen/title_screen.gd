extends Control

@onready var volume_value = $VolumeValue
@onready var volume_slider = $VolumeSlider

const autosave_dir : String = "user://autosave/"
const autosave_path : String = autosave_dir + "autosave.tres"
var autosave = AutoSave.new()
#checks autosave resource for volume information
func _ready():
	#verify save directory and load volume
	DirAccess.make_dir_absolute(autosave_dir)
	if(!ResourceLoader.exists(autosave_path)):
		ResourceSaver.save(autosave, autosave_path)
	autosave = ResourceLoader.load(autosave_path)
	volume_slider.value = autosave.volume
	volume_value.text = str(autosave.volume)
	AudioServer.set_bus_volume_db(0, linear_to_db(volume_slider.value/100))
	


func _on_quit_pressed():
	get_tree().quit()

#updates main audio channel volume
func _on_volume_slider_value_changed(value):
	volume_value.text = str(value)
	AudioServer.set_bus_volume_db(0, linear_to_db(value/100))
	autosave.volume = value
	ResourceSaver.save(autosave, autosave_path)
