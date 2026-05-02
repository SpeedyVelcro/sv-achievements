extends Node
## Autoloaded service for interacting with achievements in the SV Achievements addon.
##
## Service (autoloaded as AchievementService) that tracks achievements and completion,
## and allows interacting with and persisting achievement completion.

## Achievements
var achievements: Array[Achievement] = []


# Override
func _ready() -> void:
	_load_achievements()


func _load_achievements() -> void:
	var achievements_setting = ProjectSettings.get_setting_with_override(SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH)
	
	if achievements_setting is not String:
		push_error("Setting %s is wrong type (not a string)" % SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH)
		return
	
	if achievements_setting == "":
		push_error("Achievement list was not set. This is a required setting. See \"SV Achievements\" under Project Settings.")
		assert("Breaking execution because achievement list was not set. Release build will not break here, so make sure you set the achievement list before you export!")
		return
	
	# Despite what the documentation says, it seems load() can read this .tres even though
	# ProjectSettings.editor/export/convert_text_resources_to_binary is true. See
	# https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#class-gdscript-method-load
	# TODO: I should make a minimal example and raise this as a docs issue. (also verify
	# because it might just be because the type hint we're using does UIDs instead)
	var achievement_list = load(achievements_setting)
	
	if achievement_list == null:
		push_error("Achievement list at path \"%s\" failed to load." % achievements_setting)
		return
	
	if achievement_list is not AchievementList:
		push_error("Achievement list at path \"%s\" was wrong type." % achievements_setting)
		return
	
	achievements = achievement_list.achievements
	
	print("Loaded %d achievement(s)." % achievements.size())
