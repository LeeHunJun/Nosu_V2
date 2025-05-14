extends Control

#perfect ffdb62
#Great 2ad7a8
#Good 0017e1
#Ok 33c9dc
#miss bf0000

func SetTextInfo(text: String):
	$ScoreLevelText.text = "[center]" + text
	
	match text:
		"PERFECT!":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("ffdb62"))
		"Great":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("2ad7a8"))
		"Good":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("0017e1"))
		"Ok":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("33c9dc"))
		_:
			$ScoreLevelText.set("theme_override_colors/default_color", Color("bf0000"))
			
