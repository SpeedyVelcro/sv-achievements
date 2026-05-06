class_name SVAchievementsConstants
extends Object
## SV Achievement Constants
##
## Contains several constants for the SV Achievements plugin.

const _SETTINGS_PLUGIN_PATH := "sv_achievements"
const _SETTINGS_GENERAL_PATH := _SETTINGS_PLUGIN_PATH + "/general"

## Path to the setting in [ProjectSettings] that stores the game's achievements.
const SETTINGS_ACHIEVEMENTS_PATH := _SETTINGS_GENERAL_PATH + "/achievements"
## Path to the setting in [ProjectSettings] for whether sync buttons should be
## shown on achievements (these are for pushing unlock status to e.g. Steam
## or Newgrounds if it failed to unlock before).
const SETTINGS_ENABLE_SYNC_PATH := _SETTINGS_GENERAL_PATH + "/enable_sync"
