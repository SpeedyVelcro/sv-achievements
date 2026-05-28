class_name GameJoltAchievementSyncAdapter
extends AchievementSyncAdapter
## Adapter for the Game Jolt API
##
## An [AchievementSyncAdapter] for v0.0.8 (and possibly later varions) of the
## game-jolt-api plugin by Joel Games da Silva found at
## [url]https://github.com/murikistudio/game-jolt-api[/url].
## You must have this plugin installed in your project for this class to work
## properly.
# TODO: One-shot signal connections mean there are possible race conditions all
# over if another thread is interacting with the Game Jolt API.


# Override
func sync_one_way(achievement: Achievement) -> void:
	_unlock_trophy(achievement)


# Override
func sync_two_way(achievement: Achievement) -> void:
	# Game Jolt trophies do not support progress; only unlock state.
	
	if achievement.is_unlocked():
		_unlock_trophy(achievement)
	
	var _on_fetch_complete: Callable = func (result: Dictionary) -> void:
		if not _is_result_success(result): # Also pushes an error
			return
		var trophy = result if result.has("achieved") else result[0]
		if bool(trophy["achieved"]):
			achievement.unlock()
	
	_get_game_jolt_autoload().trophies_fetch(null, [achievement.game_jolt_id]).trophies_fetch_completed \
			.connect(_on_fetch_complete, CONNECT_ONE_SHOT)


func _unlock_trophy(achievement: Achievement) -> void:
	if achievement.is_unlocked():
		_get_game_jolt_autoload().trophies_add_achieved(achievement.game_jolt_id) \
				.trophies_add_achieved_completed \
				.connect(_on_game_jolt_request_completed, CONNECT_ONE_SHOT)


# Override
func one_way_sync_multiple(achievements: Array[Achievement]) -> void:
	var game_jolt := _get_game_jolt_autoload()
	game_jolt.batch_begin()
	
	for achievement in achievements:
		sync_one_way(achievement)
	
	game_jolt.batch_end()
	game_jolt.batch().batch_completed.connect(_on_game_jolt_request_completed, CONNECT_ONE_SHOT)


# Override
func two_way_sync_multiple(achievements: Array[Achievement]) -> void:
	if achievements.size() <= 0:
		return
	
	if achievements.size() == 1:
		sync_two_way(achievements[0])
	
	var ids = achievements.map(func(achievement: Achievement): return achievement.game_jolt_id)
	
	var _on_fetch_complete: Callable = func (result: Dictionary) -> void:
		if not _is_result_success(result): # Also pushes an error
			return
		if not result.has("trophies") or result["trophies"] is not Array:
			push_error("Trophies fetch response does not have a trophies array, or trophies is not of type array.")
			return
		for achievement in achievements:
			var trophy_index = result["trophies"].find_custom(func(t): return t.has("id") and t["id"] == achievement.game_jolt_id)
			if trophy_index < 0:
				push_error("Could not find Game Jolt trophy with ID %d in response." % achievement.game_jolt_id)
			var trophy = result["trophies"][trophy_index]
			var achieved := false
			if trophy.has("achieved") and bool(trophy["achieved"]):
				achieved = true
			
			if achievement.is_unlocked() and not achieved:
				_unlock_trophy(achievement)
			elif achieved and not achievement.is_unlocked():
				achievement.unlock()
	
	_get_game_jolt_autoload().trophies_fetch(null, ids).trophies_fetch_completed \
			.connect(_on_fetch_complete, CONNECT_ONE_SHOT)


# Dynamic retrieval to avoid compile errors for users that are not using Game Jolt
# or this adapter.
func _get_game_jolt_autoload() -> Node:
	return Engine.get_main_loop().root.get_node("GameJolt")


func _is_result_success(result: Dictionary, push_error := true) -> bool:
	if (not result.has("success")) or result["success"] != true:
		if push_error:
			push_error("Game Jolt achievement sync adapter sent an unsuccessful request. Response: %s" % JSON.stringify(result))
		return false
	return true


# Signal connection
func _on_game_jolt_request_completed(result: Dictionary) -> void:
	# Pushes an error
	_is_result_success(result)
