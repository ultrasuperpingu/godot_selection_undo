# <img src="selection_undo.png" width="32" height="32"> Godot Selection Undo

Add selection to the undo stack in Godot Editor

See Godot Proposal [#2958](https://github.com/godotengine/godot-proposals/issues/2958)

For now, it works pretty well for me. Need more test to be sure it's production ready.

## Installation
 * Unzip the addons folder into your project
 * Go to Project/Projects Settings..., Go to the Plugins tab and check "Selection Undo"

## Comments
Activating this plugin will make any selection change as a modification of the current scene. That means that if you open your project and select a node in a scene, and try to close the editor, you'll be asked if you want to save the scene.
