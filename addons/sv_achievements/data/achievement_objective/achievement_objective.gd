class_name AchievementObjective
extends Resource
## Base class for achievement objectives.
##
## Domain object that represents an achievement objective. This base class,
## when used on its own, is a simple boolean flag.

## True if the objective has been completed. When this is set to true, it will
## emit [signal completed]
var completion_state: bool = false:
	set(value):
		var previous_value = completion_state
		completion_state = value
		if value and not previous_value:
			completed.emit()
	get:
		return completion_state

## Emitted when the objective is completed.
signal completed


## Complete the objective. This is equivalent to setting [member completion_state]
## to true.
func complete():
	completion_state = true
