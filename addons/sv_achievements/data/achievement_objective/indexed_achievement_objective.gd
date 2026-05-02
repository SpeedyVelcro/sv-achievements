class_name IndexedAchievementObjective
extends AchievementObjective
## Objective containing an array of child objectives.
##
## An [AchievementObjective] that collates a number of child AchievementObjectives
## that can be accessed by index. The objective is completed when all child
## objectives have been completed.

## Array of objectives for this objective to contain. Assign this at creation. Do not add
## or remove objectives at runtime as this will mess up the internal signalling.
@export var objectives: Array[AchievementObjective]:
	set(value):
		_disconnect_children()
		objectives = value
		_connect_children()
	get:
		return objectives


## Returns the number of objectives in the collection
func count() -> int:
	if objectives == null:
		return 0
	
	return objectives.size()


## Returns the number of completed objectives in the collection
func count_complete() -> int:
	if objectives == null:
		return 0
	
	return objectives.filter(func (o: AchievementObjective) -> bool: return o.completion_state).size()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			_destructor()


func _connect_children() -> void:
	for objective: AchievementObjective in objectives:
		objective.completed.connect(_on_child_objective_completed)


func _disconnect_children() -> void:
	if objectives == null:
		return
	
	for objective: AchievementObjective in objectives:
		if objective.completed.is_connected(_on_child_objective_completed):
			objective.completed.connect(_on_child_objective_completed)


func _destructor() -> void:
	_disconnect_children()


# Signal connection
func _on_child_objective_completed() -> void:
	if objectives.all(func (o: AchievementObjective) -> bool: return o.completion_state):
		complete()
