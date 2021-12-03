# Steppr
Author: BlueGlenn

Version: 1.0
Auto-Executes weapon skills based on a queue

# Command Prefix
//Steppr
//st

# WS Queue Commands:
//st add "weapon_skill_name": Add desired weapon skill to queue
  - the weapon skill name must be in quotes, and you must know it
//st remove "weapon_skill_name": Remove weapon skill from queue
  - must be in quotes, and must be in queue already
//st clear: Clears entire weapon skill queue
//st queue: Prints entire queue for you to see

# Control Commands
//st start: Starts Steppr
//st stop: Stop Steppr

# Memory Commmands
//st save: Saves current queue as a list in ~/addons/Steppr/data/settings.xml
  - You may not use spaces, punctuation, or special characters
//st load: Loads a queue from a list in ~/addons/Steppr/data/settings.xml
//st delete: Deletes a saved list from ~/addons/Steppr/data/settings.xml