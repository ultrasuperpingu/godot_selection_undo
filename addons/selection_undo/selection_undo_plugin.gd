@tool
extends EditorPlugin

var selection : Array[Node] = []
var undo_redo : EditorUndoRedoManager 
var isChangingSelection = false;
var current_scene : Node

func _enter_tree() -> void:
	EditorInterface.get_selection().selection_changed.connect(selection_changed)
	current_scene = get_tree().edited_scene_root
	selection = EditorInterface.get_selection().get_selected_nodes()
	undo_redo = get_undo_redo();
	current_scene = get_tree().edited_scene_root

func selection_changed():
	print(EditorInterface.get_selection().get_selected_nodes())
	if isChangingSelection:
		isChangingSelection = false
		return
	var current_selection = EditorInterface.get_selection().get_selected_nodes()
	if current_selection == selection:
		return
	if current_scene != get_tree().edited_scene_root:
		current_scene = get_tree().edited_scene_root
		print("scene changed")
		return
	var context : Node = null
	var previousContext : Node = null
	var currentContext : Node = null
	if len(current_selection) > 0:
		currentContext = current_selection[0]
		context=currentContext
	if len(selection) > 0:
		previousContext = selection[0]
		if context == null:
			context=previousContext
	if context == null:
		context=current_scene
	undo_redo.create_action("Selection Change", 0, context)
	undo_redo.add_do_method(self, "selection_changed_do_undo", EditorInterface.get_selection().get_selected_nodes())
	undo_redo.add_undo_method(self, "selection_changed_do_undo", selection)
	undo_redo.commit_action(false)
	selection = current_selection

func selection_changed_do_undo(nodes):
	if isChangingSelection:
		return
	isChangingSelection = true
	EditorInterface.get_selection().clear()
	for n in nodes:
		EditorInterface.get_selection().add_node(n)
	selection = EditorInterface.get_selection().get_selected_nodes()

func _exit_tree() -> void:
	EditorInterface.get_selection().selection_changed.disconnect(selection_changed)
	selection = []
	undo_redo = null
	current_scene = null
