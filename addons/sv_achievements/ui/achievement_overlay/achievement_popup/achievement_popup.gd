extends PanelContainer
## Visual popup that informs the player an achievement has been unlocked.
##
## This is a small piece of UI that should be displayed in the corner of the
## screen temporarily whenever an achievement is unlocked. It does not do this
## behaviour itself, but rather displays the info of a set achievement. It is
## up to other nodes to create, position, and display this at the right time.


## Achievement that this popup should display.
@export var achievement: Achievement:
	set(value):
		achievement = value
		_display_achievement()
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

@export_category("Reward")
## Set to true to display reward in the popup (if the [member achievement] has one).
## Off by default to reduce clutter and allow more space for the desccription, but
## if achievement rewards are particularly important in your game you may wish to
## turn this on. 
@export var show_reward: bool = false:
	set(value):
		show_reward = value
		_update_reward()
	get:
		return show_reward

## Set to true to bold the text "Reward:" that displays before the reward
## description.
@export var bold_reward_title: bool = false:
	set(value):
		bold_reward_title = value
		_update_reward()
	get:
		return bold_reward_title

@onready var _icon_texture_rect: TextureRect = $MarginContainer/HBoxContainer/IconTextureRect
@onready var _icon_border_panel: Panel = $MarginContainer/HBoxContainer/IconTextureRect/IconBorderPanel
@onready var _name_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var _description_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel
@onready var _reward_container: Control = $MarginContainer/HBoxContainer/VBoxContainer/RewardHBoxContainer
@onready var _reward_title_label: RichTextLabel = $MarginContainer/HBoxContainer/VBoxContainer/RewardHBoxContainer/RewardTitleRichTextLabel
@onready var _reward_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/RewardHBoxContainer/RewardLabel

var _default_icon_border_stylebox: StyleBox = preload("res://addons/sv_achievements/ui/theming/icon_border/icon_border_white.tres")


# Override
func _ready() -> void:
	_display_achievement()


func _display_achievement() -> void:
	if _name_label == null or _description_label == null or achievement == null:
		return # Not ready yet. Will be re-run on ready.
	
	_name_label.text = achievement.name
	_description_label.text = achievement.description
	
	_update_icon()
	_update_reward()


func _update_icon() -> void:
	if _icon_texture_rect == null or _icon_border_panel == null or achievement == null:
		return # Not ready yet. Will be re-run on ready.
	
	if not show_icon:
		_icon_texture_rect.visible = false
		return
	
	_icon_texture_rect.texture = default_achievement_icon if achievement.icon == null else achievement.icon
	
	if not show_icon_border:
		_icon_border_panel.visible = false
		return
	
	_icon_border_panel.visible = true
	
	_icon_border_panel.add_theme_stylebox_override("panel", icon_border_stylebox_override if icon_border_stylebox_override != null else _default_icon_border_stylebox)


func _update_reward() -> void:
	if _reward_container == null or _reward_label == null or _reward_title_label == null or achievement == null:
		return # Not ready yet. Will be re-run on ready.
	
	if achievement.reward_description.is_empty() or not show_reward:
		_reward_container.visible = false
		return
	
	_reward_container.visible = true
	
	_reward_title_label.text = "[b]Reward:[/b]" if bold_reward_title else "Reward:"
	
	_reward_label.text = achievement.reward_description
