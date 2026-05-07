extends Node

@onready var _game_container: Control = $MarginContainer/GameVBoxContainer
@onready var _achievement_container: Control = $MarginContainer/AchievementListVBoxContainer


# Signal connection
func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_1_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[0].complete()


func _on_button_2_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[1].complete()


func _on_button_3_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[2].complete()


func _on_button_4_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[3].complete()


func _on_button_5_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[4].complete()


func _on_button_6_pressed() -> void:
	AchievementService.get_achievement("click-every-button").objective.objectives[5].complete()


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
