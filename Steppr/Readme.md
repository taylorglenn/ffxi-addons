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
//st aftermath: Sets the level of aftermath buff you want to maintain - 1, 2, or 3.  Setting to 0 will allow the addon to use weaponskills freely and not consider aftermath.

//st start: Starts Steppr

//st stop: Stop Steppr

# Memory Commmands
//st save: Saves current queue as a list in ~/addons/Steppr/data/settings.xml
  - You may not use spaces, punctuation, or special characters

//st load: Loads a queue from a list in ~/addons/Steppr/data/settings.xml

//st delete: Deletes a saved list from ~/addons/Steppr/data/settings.xml
