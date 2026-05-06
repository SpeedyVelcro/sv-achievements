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
		progress_changed.emit(value)
		if value >= target:
			complete()
	get:
		return progress

## Target to complete the objective. When [member progress] reaches this value,
## the objective will complete.
@export var target: float = 0.0

## Set to true to indicate that this objective should show a progress bar
## when displayed in a UI.
@export var show_progress_bar: bool = true


## Increases the [progress] by the given value. This is equivalent to setting
## progress directly.
func increase(value: float) -> void:
	progress += value


# Override
func should_show_progress_bar() -> bool:
	return show_progress_bar


# Override
func get_progress() -> float:
	return progress


# Override
func get_progress_target() -> float:
	return target


# Override
func is_progress_type() -> bool:
	return true
