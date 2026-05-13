extends Node
## Autoloaded service for interacting with achievements in the SV Achievements addon.
##
## Service (autoloaded as AchievementService) that tracks achievements and completion,
## and allows interacting with and persisting achievement completion.

## Achievements array. Once it is set, you should treat the array as immutable.
## Do not add or remove elements after setting it, as this will break internal
## signal connections.
var achievements: Array[Achievement] = []

signal achievement_unlocked(achievement: Achievement)


## Gets the achievement with the given ID. If there is no achievement with that
## ID, returns null.
func get_achievement(id: String) -> Achievement:
	var index := achievements.find_custom(func (a: Achievement) -> bool: return a.achievement_id == id)
	
	if index < 0:
		push_error("No achievement exists with ID \"%s\"" % id)
		return null
	
	return achievements[index]


func unlock(id: String) -> void:
	var achievement := get_achievement(id)
	
	if achievement == null:
		return # get_achievement() already pushed an error to the console
	
	achievement.unlock()


# Override
func _ready() -> void:
	_load_achievements()
	_connect_achievements()


func _load_achievements() -> void:
	var achievements_setting = ProjectSettings.get_setting_with_override(SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH)
	
	if achievements_setting is not String:
		push_error("Setting %s is wrong type (not a string)" % SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH)
		return
	
	if achievements_setting == "":
		push_error("Achievement list was not set. This is a required setting. See \"SV Achievements\" under Project Settings.")
		assert("Breaking execution because achievement list was not set. Release build will not break here, so make sure you set the achievement list before you export!")
		return
	
	# Despite what the documentation says, it seems load() can read this .tres even if
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


func _connect_achievements() -> void:
	for achievement in achievements:
		achievement.unlocked.connect(_on_achievement_unlocked.bind(achievement))


func _disconnect_achievements() -> void:
	# Don't ask me how it works but apparently get_incoming_connections() also
	# returns connections to callables created using .bind() on this object's
	# methods.
	for connection in get_incoming_connections():
		connection["signal"].disconnect(connection["callable"])


func _on_achievement_unlocked(achievement: Achievement) -> void:
	achievement_unlocked.emit(achievement)

# Override
func _exit_tree() -> void:
	_disconnect_achievements()
