@tool
extends Node2D

@export var factor: float = 1.0

@onready var efs = EditorInterface.get_resource_filesystem()

@export_tool_button("go") var ___asdaf = go
func go() -> void:
	var source:String = "res://assets/.res/units"
	var dest:String = "res://assets//units"
	var dirs = DirAccess.get_directories_at(source)
	
	#rescale png
	for dir in dirs:
		var in_path:String = source.path_join(dir)
		var out_path:String = dest.path_join(dir)
		rescale(in_path,out_path)
		
	efs.scan()
	await efs.filesystem_changed
	
	#create svd
	for dir in dirs:
		var out_path:String = dest.path_join(dir)
		create_data(out_path)
	
func rescale(in_dir:String,out_dir:String) -> void:
	var files: PackedStringArray = DirAccess.get_files_at(in_dir)
	for filename in files:
		
		if filename.get_extension() != "png":continue

		var input_path := in_dir.path_join(filename)
		var img := Image.new()
		img.load(input_path)

		var new_w := int(img.get_width() * factor)
		var new_h := int(img.get_height() * factor)
		img.resize(new_w, new_h, Image.INTERPOLATE_LANCZOS)

		var output_path := out_dir.path_join(filename)
		
		if not DirAccess.dir_exists_absolute(out_dir):
			DirAccess.make_dir_absolute(out_dir)
	
		img.save_png(output_path)
		print("new pic: ", output_path)

func create_data(dir:String) -> void:
	var files: PackedStringArray = DirAccess.get_files_at(dir)
	for filename in files:
		if filename.get_extension() != "png":continue

		var png_path := dir.path_join(filename)
		create_visual_resource(png_path)

func create_visual_resource(png_path:String) -> void:
	var tex := load(png_path) as Texture2D

	var w := tex.get_width()
	var h := tex.get_height()

	var frames := 1
	if w != h:
		frames = w / h
	
	var res := StateVisualData.new()
	res.texture = tex
	res.frames = frames
	res.anima = UnitVisual.AnimaType.LOOP

	var tres_path := png_path.get_basename() + ".tres"
	ResourceSaver.save(res, tres_path)
	print("new res: ", tres_path)
