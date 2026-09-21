- Improve UI Scale handling when Manage Resolution is off.
- `AchievementService` now has properties for reading and updating
  certain sync-related settings. These are read from project settings
  on startup, and will be used instead of project settings from then
  on.
- Sync button on achievements UI now responds to changes in sync
  settings on the `AchievementService` singleton.
- Improved keyboard/controller navigation support on `AchievementUI`
  scene.
- Fixed `AchievementListUI` exports not propagating to children after
  ready.
- Added several exported variables to `AchievementUI` and
  `AchievementListUI` for styling that can't be done with themes.

