@tool
extends EditorPlugin

const _ACHIEVEMENT_SERVICE_AUTOLOAD_NAME := "AchievementService"


# Override
func _enter_tree() -> void:
	if not ProjectSettings.has_setting(SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH):
		ProjectSettings.set_setting(SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH, "")
	ProjectSettings.set_initial_value(SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH, "")
	ProjectSettings.add_property_info({
		"name": SVAchievementsConstants.SETTINGS_ACHIEVEMENTS_PATH,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tres,*.res"
	})
	
	if not ProjectSettings.has_setting(SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH):
		ProjectSettings.set_setting(SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH, false)
	ProjectSettings.set_initial_value(SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH, false)
	ProjectSettings.add_property_info({
		"name": SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH,
		"type": TYPE_BOOL
	})
	
	add_autoload_singleton(_ACHIEVEMENT_SERVICE_AUTOLOAD_NAME, "res://addons/sv_achievements/autoload/achievement_service.gd")


# Override
func _exit_tree() -> void:
	remove_autoload_singleton(_ACHIEVEMENT_SERVICE_AUTOLOAD_NAME)
