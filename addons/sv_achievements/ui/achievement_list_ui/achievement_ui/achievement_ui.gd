extends MarginContainer
## UI for displaying a single achievement.
##
## This UI displays a single [Achievement] from SV Achievements. It adapts to
## the achievement's configuration, displaying e.g. a progress bar
## or sub-achievements. The UI updates according to changes in the achievement's
## unlock status and the completion status of its objectives.

## Achievement to display. Required.
@export var achievement: Achievement:
	set(value):
		_disconnect_signals()
		achievement = value
		_display_achievement()
		_connect_signals()
	get:
		return achievement

@export_category("Icon")
## Set to true to display the icon. [member default_achievement_icon] and/or
## [member Achievement.icon] should be set if this is true.
@export var show_icon: bool = true:
	set(value):
		show_icon = value
		_update_icon()
	get:
		return show_icon

## When true and this achievement is locked, a grayscale filter will be applied
## to the icon.
@export var grayscale_icon_when_locked: bool = true:
	set(value):
		grayscale_icon_when_locked = value
		_update_icon()
	get:
		return grayscale_icon_when_locked

## If true, a border will be displayed around the icon. This border is a panel
## that displays above the icon with custom theming to show a white border around
## (not overlapping) its dimensions. To override this behaviour set a custom
## [StyleBox] with [member icon_border_stylebox_override].
@export var show_icon_border: bool = true:
	set(value):
		show_icon_border = value
		_update_icon()
	get:
		return show_icon_border

## Stylebox used to display a border around the achievement icon. Set this to
## replace the default icon border (by default a white border). See
## [member show_icon_border].
@export var icon_border_stylebox_override: StyleBox:
	set(value):
		icon_border_stylebox_override = value
		_update_icon()
	get:
		return icon_border_stylebox_override

## Default achievement icon to display if the [member Achievement.icon] is not
## set. Leaving this unset may result in undefined behaviour. Set [member display_icon]
## to false instead if you want to hide the icon.
@export var default_achievement_icon: Texture2D:
	set(value):
		default_achievement_icon = value
		_update_icon()
	get:
		return default_achievement_icon

## Icon to display instead of [member Achievement.icon] if the achievement
## hasn't been unlocked. If this is left unset, then the achievement icon will
## still be displayed when locked.
@export var locked_achievement_icon: Texture2D:
	set(value):
		locked_achievement_icon = value
		_update_icon()
	get:
		return locked_achievement_icon

## Icon to display when achievement's icon is secret. If this is not set, then
## [member default_achievement_icon] will be used instead.
@export var secret_achievement_icon: Texture2D:
	set(value):
		secret_achievement_icon = value
		_update_icon()
	get:
		return secret_achievement_icon

@export_category("Details")
## Text to display in place of the achievement name when [member Achievement.secret_name]
## is true.
@export var secret_name: String = "Hidden Achievement":
	set(value):
		secret_name = value
		_update_details()
	get:
		return secret_name

## Text to display in place of the achievement description when
## [member Achievement.secret_description] is true.
@export var secret_description: String = "Unlock this achievement to find out more.":
	set(value):
		secret_description = value
		_update_details()
	get:
		return secret_description

@export_category("Reward")
## Set to true to bold the text "Reward:" that displays before the reward
## description.
@export var bold_reward_title: bool:
	set(value):
		bold_reward_title = value
		_update_reward()
	get:
		return bold_reward_title

## This text will be displayed if the achievement has an award but [member Achievement.secret_reward]
## is set to true.
@export var secret_reward_description: String = "???":
	set(value):
		secret_reward_description = value
		_update_reward()
	get:
		return secret_reward_description

@export_category("Objectives")
## If this is true and the achievement has [member Achievement.show_objectives]
## set to true, then objectives will be shown in a collapsible list.
@export var show_objective_list: bool = true:
	set(value):
		show_objective_list = value
		_update_objective_list()
	get:
		return show_objective_list

## Icon to display in the objective list when objectives are incomplete. It is
## recommended you use a [DPITexture].
@export var objective_incomplete_icon: Texture2D:
	set(value):
		objective_incomplete_icon = value
		_update_objective_list()
	get:
		return objective_incomplete_icon

## Icon to display in the objective list when objectives are completed. It is
## recommended you use a [DPITexture].
@export var objective_complete_icon: Texture2D:
	set(value):
		objective_complete_icon = value
		_update_objective_list()
	get:
		return objective_complete_icon

## Size of a single level of indentation in the objective list in pixels.
@export var objective_list_indent_size: float = 24.0:
	set(value):
		objective_list_indent_size = value
		_update_objective_list()
	get:
		return objective_list_indent_size

@onready var _icon_texture_rect: TextureRect = $VBoxContainer/HBoxContainer/VBoxContainer/IconTextureRect
@onready var _icon_spacer: Control = $VBoxContainer/IconSpacerReferenceRect
@onready var _icon_border_panel: Panel = $VBoxContainer/HBoxContainer/VBoxContainer/IconTextureRect/IconBorderPanel
@onready var _name_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/NameLabel
@onready var _description_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer2/DescriptionLabel
@onready var _sync_button: Button = $VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/SyncButton
@onready var _reward_container: Control = $VBoxContainer/HBoxContainer/VBoxContainer2/RewardContainer
@onready var _reward_title_label: RichTextLabel = $VBoxContainer/HBoxContainer/VBoxContainer2/RewardContainer/RewardTitleLabel
@onready var _reward_label: Label = $VBoxContainer/HBoxContainer/VBoxContainer2/RewardContainer/RewardLabel
@onready var _progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var _progress_label: Label = $VBoxContainer/ProgressBar/ProgressLabel
@onready var _objective_container: Control = $VBoxContainer/ObjectiveFoldableContainer
@onready var _objective_list_ui: Control = $VBoxContainer/ObjectiveFoldableContainer/ObjectiveListUI

var _default_icon_border_stylebox: StyleBox = preload("res://addons/sv_achievements/ui/theming/icon_border/icon_border_white.tres")


# Override
func _ready() -> void:
	_display_achievement()
	# TODO: Connect signals
	
	# Don't call get_setting() if it doesn't exist because we don't want to clutter the output with warnings.
	var enable_sync: bool = ProjectSettings.get_setting_with_override(SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH) \
		if ProjectSettings.has_setting(SVAchievementsConstants.SETTINGS_ENABLE_SYNC_PATH) \
		else false
	
	if enable_sync:
		_sync_button.visible = true
	else:
		_sync_button.visible = false


func _display_achievement() -> void:
	if achievement == null:
		# Only need the one error so it's displayed here on achievement set, instead of
		# every time any other property is changed.
		push_error("AchievementUI does not have an achievement set.")
		return
	
	_update_icon()
	_update_details()
	_update_reward()
	_update_progress()
	_update_objective_list()


func _update_icon() -> void:
	if _icon_texture_rect == null or achievement == null:
		return # Not until ready
	
	if not show_icon:
		_icon_texture_rect.visible = false
		return
	
	_icon_texture_rect.visible = true
	
	if achievement.is_unlocked():
		_icon_texture_rect.texture = achievement.icon if achievement.icon != null else default_achievement_icon
	else:
		# TODO: grey out achievement
		if achievement.secret_icon:
			_icon_texture_rect.texture = secret_achievement_icon if secret_achievement_icon != null else default_achievement_icon
		else:
			_icon_texture_rect.texture = locked_achievement_icon \
				if locked_achievement_icon != null \
				else achievement.icon \
					if achievement.icon != null \
					else default_achievement_icon
	
	if not show_icon_border:
		_icon_border_panel.visible = false
		return
	
	_icon_border_panel.visible = true
	
	_icon_border_panel.add_theme_stylebox_override("panel", icon_border_stylebox_override if icon_border_stylebox_override != null else _default_icon_border_stylebox)


func _update_details() -> void:
	if _name_label == null or _description_label == null or achievement == null:
		return # Not until ready
	
	if achievement.is_unlocked():
		_name_label.text = achievement.name
		_description_label.text = achievement.description
	else:
		_name_label.text = secret_name if achievement.secret_name else achievement.name
		_description_label.text = secret_description if achievement.secret_description else achievement.description


func _update_reward() -> void:
	if _reward_container == null or _reward_label == null or _reward_title_label == null or achievement == null:
		return # Not until ready
	
	if achievement.reward_description.is_empty():
		_reward_container.visible = false
		return
	
	_reward_container.visible = true
	
	_reward_title_label.text = "[b]Reward:[/b]" if bold_reward_title else "Reward:"
	
	if achievement.is_unlocked():
		_reward_label.text = achievement.reward_description
	else:
		_reward_label.text = secret_reward_description if achievement.secret_reward else achievement.reward_description


func _format_float(value: float) -> String:
	var new_string := str(value)
	if not new_string.contains("."):
		return new_string
	while new_string.ends_with("0"):
		new_string = new_string.trim_suffix("0")
	new_string = new_string.trim_suffix(".")
	return new_string


func _update_progress() -> void:
	if _progress_bar == null or _progress_label == null or achievement == null:
		return # Not ready yet
	
	if not achievement.should_show_progress_bar():
		_progress_bar.visible = false
		_update_icon_spacer()
		return
	
	_progress_bar.visible = true
	
	var progress := achievement.get_progress()
	var target := achievement.get_progress_target()
	
	_progress_bar.value = progress
	_progress_bar.max_value = target
	
	_progress_label.text = "%s/%s" % [_format_float(progress), _format_float(target)]
	
	_update_icon_spacer()


func _update_objective_list() -> void:
	if _objective_container == null or _objective_list_ui == null or achievement == null:
		return # Not ready yet
	
	if not achievement.show_objectives or achievement.show_objectives == null:
		_objective_container.visible = false
		_update_icon_spacer()
		return
	
	_objective_container.visible = true
	_objective_list_ui.objective = achievement.objective
	_objective_list_ui.incomplete_icon = objective_incomplete_icon
	_objective_list_ui.complete_icon = objective_complete_icon
	_objective_list_ui.indent_size = objective_list_indent_size
	
	_update_icon_spacer()


func _update_icon_spacer() -> void:
	if _icon_spacer == null:
		return
	
	# If either of these are visible, they will show too close to the icon (and
	# also the description actually, so maybe this func is a bit of a misnomer).
	# But we also don't want to add un-necessary space between achievements if
	# they're not visible, hence setting this conditionally.
	_icon_spacer.visible = _progress_bar.visible or _objective_container.visible


func _connect_signals() -> void:
	if achievement == null:
		return
	
	achievement.unlocked.connect(_on_achievement_unlocked)
	achievement.progress_changed.connect(_on_achievement_progress_changed)
	achievement.reset.connect(_on_achievement_reset)


func _disconnect_signals() -> void:
	if achievement == null:
		return
	
	if achievement.unlocked.is_connected(_on_achievement_unlocked):
		achievement.unlocked.disconnect(_on_achievement_unlocked)
	
	if achievement.progress_changed.is_connected(_on_achievement_progress_changed):
		achievement.progress_changed.disconnect(_on_achievement_progress_changed)
	
	if achievement.reset.is_connected(_on_achievement_reset):
		achievement.reset.disconnect(_on_achievement_reset)


# Signal connection
func _on_achievement_unlocked() -> void:
	_update_icon()
	_update_details()
	_update_reward()


# Signal connection
func _on_achievement_progress_changed(_value: float) -> void:
	_update_progress()


# Signal connection
func _on_achievement_reset() -> void:
	_update_icon()
	_update_details()
	_update_reward()
	_update_progress()


# Override
func _exit_tree() -> void:
	_disconnect_signals()
