@icon("res://assets/editor_assets/spawner_icon.svg")
@tool
@static_unload
extends Sprite2D
class_name Spawner

enum SpawnerAssemblerID
{
	ALIVE,
	CASTER,
	
	TARGETING,
	ALLY_TARGETING,
	
	UNIT,
	
	STATIC,
	
	GUI
}

static var SpawnerAssemblers:Dictionary[SpawnerAssemblerID,SpawnerAssembler] = {
	SpawnerAssemblerID.ALIVE : AliveSpawnerAssembler.new(),
	SpawnerAssemblerID.CASTER : CasterSpawnerAssembler.new(),
	
	SpawnerAssemblerID.TARGETING : TargeterSpawnerAssembler.new(),
	SpawnerAssemblerID.ALLY_TARGETING : AllyTargeterSpawnerAssembler.new(),
	
	SpawnerAssemblerID.UNIT : UnitSpawnerAssembler.new(),
	SpawnerAssemblerID.STATIC : StaticSpawnerAssembler.new(),
	SpawnerAssemblerID.GUI : GUISpawnerAssembler.new()
}

static var alive_id:int = 0

@export var team:Team:
	set(val):
		team = val
		_upd_editor_name()
		queue_redraw()

@export var actor_scene:PackedScene
@export var data:SpawnerData:
	set(val):
		data = val
		if not data:return
		_upd_draw()
		_upd_editor_name()
		if not data.is_building: return
		add_to_group("nv_geom")
		var sz:Vector2 = data.texture.texture.get_size();
		vertices  = PackedVector2Array([
			Vector2(-sz.x * 0.5,0),
			Vector2(-sz.x * 0.5,-sz.y),
			Vector2(sz.x * 0.5,-sz.y),
			Vector2(sz.x * 0.5,0)
		])

@export var vertices:PackedVector2Array = []

func spawn() -> void:
	var actor:Alive = actor_scene.instantiate()

	#have some @onready vars
	add_sibling(actor)
	
	#set context
	_pre_enter_execute(actor)
	#register affect team counter. Registration require setted position
	_register(actor)
	
	for id in data.spawner_assemblers:
		SpawnerAssemblers[id].execute(actor,data)
	


	queue_free()

func start_yield(val:float) -> void:
	get_tree().create_timer(val).timeout.connect(spawn)

func _register(actor:Alive) -> void:
	if data.is_building:
		team.register_building(actor)
	else:
		team.register_unit(actor)

func _pre_enter_execute(actor:Alive) -> void:
	actor.global_position = global_position
	actor.set_team(team)
	actor.team = team

	var nom:NomComp = NomComp.new()
	nom.nom = data.nom
	nom.id = alive_id
	alive_id += 1
	nom.prefix = team.name.trim_prefix("Team")
	actor.nom = nom
	actor.update_name()

func _upd_draw() -> void:
	centered = false
	texture = data.texture.texture
	offset = Vector2(
		-texture.get_width()/(2.0 * hframes),
		-texture.get_height())
	queue_redraw()

func _upd_editor_name() -> void:
	if data and team:
		name = data.nom + " " + team.name.trim_prefix("Team")
	else:
		name = "NULL"

func _draw() -> void:
	if data:
		modulate = team.color
		draw_circle(Vector2.ZERO,data.vision,Color.WHITE,0,1)
