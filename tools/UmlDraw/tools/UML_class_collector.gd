@tool
extends RefCounted
class_name UMLClassCollector
## Collect classes from project dir. Value in classes is bbcoded

const VARIANT_TYPE_NAME := {
   0: "void",
   1: "bool",
   2: "int",
   3: "float",
   4: "String",
   5: "Vector2",
   6: "Vector2i",
   7: "Rect2",
   8: "Rect2i",
   9: "Vector3",
   10: "Vector3i",
   11: "Transform2D",
   12: "Vector4",
   13: "Vector4i",
   14: "Plane",
   15: "Quaternion",
   16: "AABB",
   17: "Basis",
   18: "Transform3D",
   19: "Projection",
   20: "Color",
   21: "String",
   22: "NodePath",
   23: "RID",
   24: "Object",
   25: "Callable",
   26: "Signal",
   27: "Dictionary",
   28: "Array",
   29: "PackedByteArray",
   30: "PackedInt32Array",
   31: "PackedInt64Array",
   32: "PackedFloat32Array",
   33: "PackedFloat64Array",
   34: "PackedStringArray",
   35: "PackedVector2Array",
   36: "PackedVector3Array",
   37: "PackedColorArray",
   38: "PackedVector4Array",
   39: "Max"
}

func collect_classes(scan_root:String) -> Dictionary[String,Class]:
	var classes:Dictionary[String,Class]

	var files:Array[String]
	_scan_dir(scan_root, files)
	
	var script_files:Array[Script]
	_select_scripts(files,script_files)

	for script:Script in script_files:
		var c:Class = Class.new()
		
		c.nom = script.get_global_name()
		c.is_abstarct = script.is_abstract()
		
		var base:Script = script.get_base_script()
		if base:
			c.base = base.get_global_name()
			
		c.vars = get_properties(script.get_script_property_list())

		for m:Dictionary in script.get_script_method_list():
			if m.flags & METHOD_FLAG_VIRTUAL or m.name.begins_with("__"):
				continue
			#overload duplicates
			if c.funcs.has(m.name):continue
			
			var f:Func = Func.new()
			f.nom = m.name
			f.args = get_properties(m.args)
			f.ret = _get_property_type(m.return)
			
			c.funcs[f.nom] = f

		classes[c.nom] = c

	#in frist need collect all name. now collect depends
	for script:Script in script_files:
		var class_nom:String = script.get_global_name()
		var c:Class = classes[class_nom]

		for p:Dictionary in script.get_script_property_list():
			if p.name.begins_with("__"): continue
			if not (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE): continue

			# базовый тип
			var base_type := _get_property_type(p)
			if classes.has(base_type) and not c.dependencies.has(base_type):
				if c.base != base_type:
					c.dependencies.append(base_type)

			# Array[T]
			if p.type == TYPE_ARRAY and p.hint == PROPERTY_HINT_TYPE_STRING:
				var parts:PackedStringArray= p.hint_string.split(":")
				if parts.size() > 1:
					var inner := parts[1]
					if classes.has(inner) and not c.dependencies.has(inner):
						if c.base != inner:
							c.dependencies.append(inner)

			# Dictionary[K;V]
			if p.type == TYPE_DICTIONARY and p.hint == PROPERTY_HINT_TYPE_STRING:
				var kv:PackedStringArray = p.hint_string.split(";", false, 2)
				if kv.size() == 2:
					for part in kv:
						var sub := part.split(":")
						if sub.size() > 1:
							var t := sub[1]
							if classes.has(t) and not c.dependencies.has(t):
								if c.base != t:
									c.dependencies.append(t)

	return classes

func get_properties(data:Array[Dictionary]) -> Array[Var]:
	var res:Array[Var]
	for p:Dictionary in data:
		if p.name.begins_with("__"):continue
		res.append(parse_property(p))
	return res

func parse_property(p:Dictionary) -> Var:
	if p.type == TYPE_ARRAY:
		#exported arrays, may be nested
		if p.hint == PROPERTY_HINT_TYPE_STRING:
			return parse_array_property(p)
		#non export arrays
		if p.hint == PROPERTY_HINT_ARRAY_TYPE:
			var res = ArrayVar.new()
			res.nom = p.name
			res.type = VARIANT_TYPE_NAME[p.type]
			res.nested = p.hint_string
			return res
	#dict
	if p.type == TYPE_DICTIONARY and p.hint == PROPERTY_HINT_TYPE_STRING:
		return parse_dict_property(p)
	#other property
	else:
		var res:Var = Var.new()
		res.type =  _get_property_type(p)
		res.nom = p.name
		return res

func parse_dict_property(p:Dictionary) -> DictVar:
	var res = DictVar.new()
	res.nom = p.name
	res.type = VARIANT_TYPE_NAME[p.type]
	var kv:PackedStringArray = p.hint_string.split(";", false, 2)
	res.key = _parse_nested_hint(kv[0])
	res.val = _parse_nested_hint(kv[1])
	return res

func parse_array_property(p:Dictionary) -> ArrayVar:
	var res = ArrayVar.new()
	res.nom = p.name
	res.type = VARIANT_TYPE_NAME[p.type]
	
	res.nested = _parse_nested_hint(p.hint_string)
	return res

func _parse_nested_hint(hint:String) -> String:
	var parts:PackedStringArray = hint.split(":")
	var first:String = parts[0]
	#Object
	if "24" in parts[0]:
		#var _hint = first.split("/")[1]
		return parts[1]
			
	else:
		return VARIANT_TYPE_NAME[int(first)]

## class_name or name of built-in
func _get_property_type(p:Dictionary) -> String:
	var property_type:String = p.class_name
	if property_type == "":
		property_type = VARIANT_TYPE_NAME[p.type]
	return property_type


## get all files
func _scan_dir(path: String, out: Array) -> void:
	var dir := DirAccess.open(path)

	for file_name: String in dir.get_files():
		out.append(path.path_join(file_name))

	for dir_name: String in dir.get_directories():
		_scan_dir(path.path_join(dir_name), out)

## selectr only .gd scripts with specified class_name
func _select_scripts(files:Array[String],script_files:Array[Script]) -> void:
	for file:String in files:
		if not file.ends_with(".gd"):
			continue
			
		var s:Script = load(file)
		var  nom:String = s.get_global_name()
		#class_name not specified
		if nom == "":
			continue
		if nom.begins_with("UML"):
			continue
			
		script_files.append(load(file) as Script)
