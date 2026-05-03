class_name Achievement
extends Resource
## An achievement in SV Achievements.
##
## Resource that contains data about an achievement in SV Achievements. Create
## instances of this resource and configure using the exported variables.

## A unique string representing the achievement. This is used for certain functionality
## such as saving the list of unlocked achievements. Using the same name as another
## achievement may result in undefined behaviour. It is recommended to name this
## in hyphen-separated lowercase, for example "earn-1000-points" or "win-game-hardcore".
##
## Modders are advised to use longer strings with e.g. the mod name and/or author
## name to make ID clashes less likely. For example: "speedyvelcro-ultimate-overhaul-kill-30-enemies"
@export var achievement_id: String = ""

## Human-readable name of the achievement. This will be displayed in UIs.
@export var name: String = ""

## When this objective completes, the achievement will be unlocked.
@export var objective: AchievementObjective = AchievementObjective.new():
	set(value):
		_disconnect_objective()
		objective = value
		_connect_objective()
	get:
		return objective

## Human-readable description of how to achieve the achievement. This will be
## displayed in UIs.
@export_multiline var description: String = ""

## Human-readable desccription of the reward - if any - that will be unlocked
## when this achievement is unlocked. This will be displayed in UIs only if
## it is set to a non-empty string.
##
## Note that rewards need to be implemented yourself by hooking into the signals
## that emit when an achievement is unlocked.
@export var reward_description: String = ""

## Icon to display when unlocked (or greyed out when locked if the icon isn't
## secret). This will be displayed in UIs.
@export var icon: Texture2D

## If true, this achievement will not be shown at all in UIs if it hasn't been
## unlocked yet. Players will not even be shown that there is a secret
## achievement.
@export var invisible: bool = false

## If true, the name will not be shown in UIs if the achievement has not been
## unlocked yet, and a default secret name will be used instead.
##
## If [member invisible] is true, this property has no effect as the
## achievement will not be visible anyway.
@export var secret_name: bool = false

## If true, the description will not be shown in UIs if the achievement has not
## been unlocked yet, and a default secret description will be used instead.
##
## If [member invisible] is true, this property has no effect as the
## achievement will not be visible anyway.
@export var secret_description: bool = false

## If true and [member reward_description] is set, the reward text will not
## be displayed in UIs before this achievement unlocks. If there is no
## reward description, this property has no effect.
##
## If [member invisible] is true, this property has no effect as the
## achievement will not be visible anyway.
@export var secret_reward: bool = false

## If true, the icon will not be shown in UIs if the achievement has not been
## unlocked yet, and a default "locked" icon will be used instead.
##
## If [member invisible] is true, this property has no effect as the
## achievement will not be visible anyway.
@export var secret_icon: bool = false

## If this is true, the player has completed the achievement. You may force-unlock
## the achievement by setting this to true, or using [method unlock]
var unlock_state: bool = false:
	set(value):
		var previous_value = value
		unlock_state = value
		if value and not previous_value:
			unlocked.emit()
	get:
		return unlock_state

## Emitted when the achievement is unlocked (i.e. completed)
signal unlocked


## Completes the achievement. Equivalent to setting [member unlock_state] to
## true.
func unlock() -> void:
	unlock_state = true


## Returns the completion state of the achievement as a JSON-serializable
## dictionary.
func serialize_completion() -> Dictionary:
	return {} # TODO


## Restores the completion status of the achievement from a dictionary in
## the format created by [method serialize_completion]
func deserialize_completion(dict: Dictionary):
	pass # TODO


func _connect_objective() -> void:
	if objective == null:
		return
	
	if objective.completed.is_connected(_on_objective_completed):
		return
	
	objective.completed.connect(_on_objective_completed)


func _disconnect_objective() -> void:
	if objective == null:
		return
	
	if not objective.completed.is_connected(_on_objective_completed):
		return
	
	objective.completed.disconnect(_on_objective_completed)


# Signal connection
func _on_objective_completed() -> void:
	unlock()
