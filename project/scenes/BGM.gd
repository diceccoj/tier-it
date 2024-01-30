extends AudioStreamPlayer




func play_normal():
	self.stream = load("res://sounds/bgm.mp3")
	self.play()

func play_ranking():
	self.stream = load("res://sounds/bgm_ranking.mp3")
	self.play()
