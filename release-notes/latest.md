- `AchievementService` now has properties for reading and updating
  certain sync-related settings. These are read from project settings
  on startup, and will be used instead of project settings from then
  on.
- Sync button on achievements UI now responds to changes in sync
  settings on the `AchievementService` singleton.
