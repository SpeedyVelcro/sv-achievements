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
## Path to the setting in [ProjectSettings] for allowing synchronization of locked
## achievements as well as unlocked ones.
const SETTINGS_ALLOW_LOCKED_SYNC_PATH := _SETTINGS_GENERAL_PATH + "/allow_locked_sync"
## Path to the setting in [ProjectSettings] for allowing two-way sync where the
## side with the greatest progress gets priority. This may be limited for
## certain kinds of achievements where the backend can't fully represent the
## achievement objectives (collection and indexed objectives are particularly
## uncommon on achievement backends.)
const SETTINGS_TWO_WAY_SYNC_PATH := _SETTINGS_GENERAL_PATH + "/two_way_sync"
## Path to the setting in [ProjectSettings] that stores the file path for the
## user's achievement completion save file.
const SETTINGS_COMPLETION_SAVE_FILE_PATH_PATH := _SETTINGS_GENERAL_PATH + "/completion_save_file_path"

## Default value for the path to the file that stores the user's achievement
## progress.
const SETTINGS_DEFAULT_COMPLETION_SAVE_FILE_PATH := "user://achievements.json"
