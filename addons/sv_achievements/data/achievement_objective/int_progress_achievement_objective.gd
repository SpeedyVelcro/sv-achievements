class_name IntProgressAchievementObjective
extends AchievementObjective
## Objective to meet an integer target
##
## This [AchievementObjective] completes when an int [member target] is reached.

## Current progress to the objective. Setting this to a value greater than
## or equal to [member target] will complete the objective.
var progress: int = 0:
	set(value):
		progress = value
		if value >= target:
			complete()
	get:
		return progress

## Target to complete the objective. When [member progress] reaches this value,
## the objective will complete.
@export var target: int = 0


## Increase the progress by 1. Just a convenience function - equivalent to
## incrementing [member progress] manually.
func increment() -> void:
	progress += 1
