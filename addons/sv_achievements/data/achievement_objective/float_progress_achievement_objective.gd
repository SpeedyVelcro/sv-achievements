class_name FloatProgressAchievementObjective
extends AchievementObjective
## Objective to meet a float target
##
## This [AchievementObjective] completes when a float [member target] is reached.

## Current progress to the objective. Setting this to a value greater than
## or equal to [member target] will complete the objective.
var progress: float = 0.0:
	set(value):
		progress = value
		if value >= target:
			complete()
	get:
		return progress

## Target to complete the objective. When [member progress] reaches this value,
## the objective will complete.
@export var target: float = 0.0
