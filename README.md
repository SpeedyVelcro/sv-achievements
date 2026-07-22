# SV Achievements
Achievements framework and related UI elements for the Godot Engine.

![Screenshot of an achievement popup](readme_screenshot_popup.png)
![Screnshot of an achievement list UI](readme_screenshot_menu.png)

## Dependencies
Requires [Godot 4.7](https://godotengine.org/download/4.x)

## Installation
- Download the archive `sv-achievements-addon-vX.X.X.zip` from the
  [latest release page](https://github.com/SpeedyVelcro/sv-achievements/releases/latest).
- Extract the archive into the root directory of your project (i.e. the
  same folder as your `project.godot` file).
- Activate the plugin in Project Settings.

## Usage
- Create an `AchievementList` resource
- Edit the newly-created resource and configure the achievements you want for
  your game.
- Add the `AchievementList` to your project settings under
  `Sv Achievements > General > Achievements`.
- the scene `achievement_overlay.tscn` somewhere in your game where it will
  display above all other scenes and persist through reloads (e.g. you might
  place it in an autoloaded scene and adjust its Z index).
- Place the scene `achievement_list_ui.tscn` somewhere in your game's menus.

The project at the root of the repository is an example of usage.

## License
See [`LICENSE.txt`](LICENSE.txt)
