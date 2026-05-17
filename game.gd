extends Node

@onready var _game_container: Control = $MarginContainer/GameVBoxContainer
@onready var _achievement_container: Control = $MarginContainer/AchievementListVBoxContainer

var _ascending_progress: int = 0
var _descending_progress: int = 0

# Signal connection
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_1_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[0].complete()
	
	_ascending_progress = 1
	AchievementService.get_achievement("click-ascending").objective.increase_to(1)
	
	if _descending_progress == 5:
		_descending_progress = 6
		AchievementService.get_achievement("click-descending").objective.increase_to(6)
	else:
		_descending_progress = 0


func _on_button_2_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[1].complete()
	
	if _ascending_progress == 1:
		_ascending_progress = 2
		AchievementService.get_achievement("click-ascending").objective.increase_to(2)
	else:
		_ascending_progress = 0
	
	if _descending_progress == 4:
		_descending_progress = 5
		AchievementService.get_achievement("click-descending").objective.increase_to(5)
	else:
		_descending_progress = 0


func _on_button_3_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[2].complete()
	
	if _ascending_progress == 2:
		_ascending_progress = 3
		AchievementService.get_achievement("click-ascending").objective.increase_to(3)
	else:
		_ascending_progress = 0
	
	if _descending_progress == 3:
		_descending_progress = 4
		AchievementService.get_achievement("click-descending").objective.increase_to(4)
	else:
		_descending_progress = 0


func _on_button_4_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[3].complete()
	
	if _ascending_progress == 3:
		_ascending_progress = 4
		AchievementService.get_achievement("click-ascending").objective.increase_to(4)
	else:
		_ascending_progress = 0
	
	if _descending_progress == 2:
		_descending_progress = 3
		AchievementService.get_achievement("click-descending").objective.increase_to(3)
	else:
		_descending_progress = 0


func _on_button_5_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[4].complete()
	
	if _ascending_progress == 4:
		_ascending_progress = 5
		AchievementService.get_achievement("click-ascending").objective.increase_to(5)
	else:
		_ascending_progress = 0
	
	if _descending_progress == 1:
		_descending_progress = 2
		AchievementService.get_achievement("click-descending").objective.increase_to(2)
	else:
		_descending_progress = 0


func _on_button_6_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[5].complete()
	
	if _ascending_progress == 5:
		_ascending_progress = 6
		AchievementService.get_achievement("click-ascending").objective.increase_to(6)
	else:
		_ascending_progress = 0
	
	_descending_progress = 1
	AchievementService.get_achievement("click-descending").objective.increase_to(1)


func _on_any_button_pressed() -> void:
	AchievementService.unlock("click-any-button")
	AchievementService.get_achievement("click-buttons-10-times").objective.increment()


func _on_scene_change_button_pressed() -> void:
	get_tree().change_scene_to_file("res://other_scene.tscn")


func _on_achievements_button_pressed() -> void:
	_game_container.visible = false
	_achievement_container.visible = true


func _on_achievement_back_button_pressed() -> void:
	_achievement_container.visible = false
	_game_container.visible = true


func _on_reset_button_pressed() -> void:
	AchievementService.reset_completion()
