extends VBoxContainer
## UI for displaying a complete list of achievements.
##
## Displays all achievements configured for SV achievements in a list.

@export_category("Icons")
## Set to true to display achievement icons. [member default_achievement_icon]
## should be set if not every achievement has its own icon.
@export var show_icons: bool = true:
	set(value):
		if value == show_icons:
			return
		show_icons = value
		for node in _achievement_nodes:
			node.show_icon = value
	get:
		return show_icons

## When true and achievements are locked, a grayscale filter will be applied
## to their icons.
@export var grayscale_icons_when_locked: bool = true:
	set(value):
		if value == grayscale_icons_when_locked:
			return
		grayscale_icons_when_locked = value
		for node in _achievement_nodes:
			node.grayscale_icon_when_locked = value
	get:
		return grayscale_icons_when_locked

## If true, a border will be displayed around achievement icons. This border is a panel
## that displays above the icon with custom theming to show a border around
## (not overlapping) its dimensions. To override this behaviour set a custom
## [StyleBox] with [member icon_border_stylebox_override].
@export var show_icon_borders: bool = true:
	set(value):
		if value == show_icon_borders:
			return
		show_icon_borders = value
		for node in _achievement_nodes:
			node.show_icon_border = value
	get:
		return show_icon_borders

## Stylebox used to display a border around achievement icons. Set this to
## replace the default icon border (by default a white border). See
## [member show_icon_borders].
@export var icon_border_stylebox_override: StyleBox:
	set(value):
		if value == icon_border_stylebox_override:
			return
		icon_border_stylebox_override = value
		for node in _achievement_nodes:
			node.icon_border_stylebox_override = value
	get:
		return icon_border_stylebox_override

## Default achievement icon to display if the [member Achievement.icon] is not
## set. Leaving this unset may result in undefined behaviour. Set [member display_icon]
## to false instead if you want to hide the icon.
@export var default_achievement_icon: Texture2D:
	set(value):
		if value == default_achievement_icon:
			return
		default_achievement_icon = value
		for node in _achievement_nodes:
			node.default_achievement_icon = value
	get:
		return default_achievement_icon

## Icon to display instead of [member Achievement.icon] if achievements
## haven't been unlocked. If this is left unset, then achievement icons will
## still be displayed when locked.
@export var locked_achievement_icon: Texture2D:
	set(value):
		if value == locked_achievement_icon:
			return
		locked_achievement_icon = value
		for node in _achievement_nodes:
			node.locked_achievement_icon = value
	get:
		return locked_achievement_icon

## Icon to display when achievement's icon is secret. If this is not set, then
## [member default_achievement_icon] will be used instead.
@export var secret_achievement_icon: Texture2D:
	set(value):
		if value == secret_achievement_icon:
			return
		secret_achievement_icon = value
		for node in _achievement_nodes:
			node.secret_achievement_icon = value
	get:
		return secret_achievement_icon

@export_category("Details")
## Text to display in place of the achievement name when [member Achievement.secret_name]
## is true.
@export var secret_name: String = "Hidden Achievement":
	set(value):
		if value == secret_name:
			return
		secret_name = value
		for node in _achievement_nodes:
			node.seccret_name = value
	get:
		return secret_name

## Text to display in place of the achievement description when
## [member Achievement.secret_description] is true.
@export var secret_description: String = "Unlock this achievement to find out more.":
	set(value):
		if value == secret_description:
			return
		secret_description = value
		for node in _achievement_nodes:
			node.secret_description = value
	get:
		return secret_description

@export_category("Rewards")
## Set to true to bold the text "Reward:" that displays before reward
## descriptions.
@export var bold_reward_titles: bool:
	set(value):
		if value == bold_reward_titles:
			return
		bold_reward_titles = value
		for node in _achievement_nodes:
			node.bold_reward_title = bold_reward_titles
	get:
		return bold_reward_titles

## This text will be displayed if achievements have an award but [member Achievement.secret_reward]
## is set to true.
@export var secret_reward_description: String = "???":
	set(value):
		if value == secret_reward_description:
			return
		secret_reward_description = value
		for node in _achievement_nodes:
			node.secret_reward_description = secret_reward_description
	get:
		return secret_reward_description

@export_category("Objectives")
## If this is true and an achievement has [member Achievement.show_objectives]
## set to true, then objectives will be shown in a collapsible list.
@export var show_objective_lists: bool = true:
	set(value):
		if value == show_objective_lists:
			return
		show_objective_lists = value
		for node in _achievement_nodes:
			node.show_objective_list = value
	get:
		return show_objective_lists

## Icon to display in objective lists when objectives are incomplete. It is
## recommended you use a [DPITexture].
@export var objective_incomplete_icon: Texture2D:
	set(value):
		if value == objective_incomplete_icon:
			return
		objective_incomplete_icon = value
		for node in _achievement_nodes:
			node.objective_incomplete_icon = objective_incomplete_icon
	get:
		return objective_incomplete_icon

## Icon to display in objective lists when objectives are completed. It is
## recommended you use a [DPITexture].
@export var objective_complete_icon: Texture2D:
	set(value):
		if value == objective_complete_icon:
			return
		objective_complete_icon = value
		for node in _achievement_nodes:
			node.objective_complete_icon = objective_complete_icon
	get:
		return objective_complete_icon

## Size of a single level of indentation in objective lists in pixels.
@export var objective_list_indent_size: float = 24.0:
	set(value):
		if value == objective_list_indent_size:
			return
		objective_list_indent_size = value
		for node in _achievement_nodes:
			node.objective_list_indent_size = objective_list_indent_size
	get:
		return objective_list_indent_size

var _achievement_nodes: Array[Control] = []

var _achievement_scene := preload("res://addons/sv_achievements/ui/achievement_list_ui/achievement_ui/achievement_ui.tscn")


func _ready() -> void:
	for achievement: Achievement in AchievementService.achievements:
		var ui := _achievement_scene.instantiate()
		
		ui.achievement = achievement
		ui.show_icon = show_icons
		ui.grayscale_icon_when_locked = grayscale_icons_when_locked
		ui.show_icon_border = show_icon_borders
		ui.icon_border_stylebox_override = icon_border_stylebox_override
		ui.default_achievement_icon = default_achievement_icon
		ui.locked_achievement_icon = locked_achievement_icon
		ui.secret_achievement_icon = secret_achievement_icon
		ui.secret_name = secret_name
		ui.secret_description = secret_description
		ui.bold_reward_title = bold_reward_titles
		ui.secret_reward_description = secret_reward_description
		ui.show_objective_list = show_objective_lists
		ui.objective_incomplete_icon = objective_incomplete_icon
		ui.objective_complete_icon = objective_complete_icon
		ui.objective_list_indent_size = objective_list_indent_size
		
		ui.size_flags_horizontal = SizeFlags.SIZE_EXPAND_FILL
		
		add_child(ui)
