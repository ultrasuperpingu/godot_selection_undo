@tool
extends EditorPlugin

var selection : Array[Node] = []
var undo_redo : EditorUndoRedoManager 
var isChangingSelection = false;

func _enter_tree() -> void:
	EditorInterface.get_selection().selection_changed.connect(selection_changed)
	selection = EditorInterface.get_selection().get_selected_nodes()
	undo_redo = get_undo_redo();

func selection_changed():
	if(isChangingSelection):
		isChangingSelection = false
		return
	var current_selection = EditorInterface.get_selection().get_selected_nodes()
	if(current_selection == selection):
		return
	var context=null
	if(len(current_selection)>0):
		context=current_selection[0]
	elif(len(selection)>0):
		context=selection[0]

	undo_redo.create_action("Selection Change", 0, context)
	undo_redo.add_do_method(self, "selection_changed_do_undo", EditorInterface.get_selection().get_selected_nodes())
	undo_redo.add_undo_method(self, "selection_changed_do_undo", selection)
	undo_redo.commit_action(false)
	selection = current_selection

func selection_changed_do_undo(nodes):
	if(isChangingSelection):
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
