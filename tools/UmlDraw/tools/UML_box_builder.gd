extends RefCounted
class_name UMLBoxBuilder

class TreeNode:
	var base:String = ""
	var nom:String = "FORGET"
	var children:Array[TreeNode]
	var deep:int = 0

	func _to_string() -> String:
		return "\n" + "_".repeat(deep) + nom + (str(children) if not children.is_empty() else "")

var _dest:Node
var _classes:Dictionary[String,Class]

func setup_and_go(classes:Dictionary[String,Class],dest:Node) -> void:
	_dest = dest
	_classes = classes
	_build_boxes()

func _build_boxes() -> void:
	for tree:TreeNode in _build_trees():
		_build_tree_recursive(tree,null)

func _build_trees() -> Array[TreeNode]:
	var nodes:Dictionary[String,TreeNode]
	
	for derived_nom: String in _classes.keys():
		var base_nom: String = _classes[derived_nom].base
		
		var new_node = TreeNode.new()
		new_node.base = base_nom
		new_node.nom = derived_nom
		new_node.deep = 0
		
		if nodes.has(derived_nom):
			continue

		if nodes.has(base_nom):
			new_node.deep = nodes[base_nom].deep + 1
			nodes[base_nom].children.append(new_node)

		elif base_nom != "":
			var new_base_node = TreeNode.new()
			new_base_node.nom = base_nom
			new_base_node.children.append(new_node)
			new_node.deep = 1
			nodes[base_nom] = new_base_node
			
		nodes[derived_nom] = new_node
	
	for node:TreeNode in nodes.values():
		if node.base != "":
			nodes.erase(node.nom)
	return nodes.values()

func _build_tree_recursive(node:TreeNode,parent_box:ClassBoxTool) -> void:
	var box:ClassBoxTool = _add_class_box(node)
	
	if parent_box:
		box.parent_box = parent_box
		if not parent_box.derived_boxes.has(box):
			parent_box.derived_boxes.append(box)

	for child:TreeNode in node.children:
		_build_tree_recursive(child,box,)

func _add_class_box(tree:TreeNode) -> ClassBoxTool:
	var box:ClassBoxTool = load("uid://dg2s2ktmkrhxg").instantiate()
	_dest.add_child(box)
	box.name = tree.nom
	box.owner = _dest.owner
	box.set_data(_classes[tree.nom])
	return box
