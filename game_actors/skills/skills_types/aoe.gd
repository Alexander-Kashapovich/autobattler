extends Skill
class_name AOESkill

@export var radius:float = 25

func _apply_to_target(ctx:SkillExecutionContext) -> void:
	for t:Alive in get_targets(ctx):
		for e:Effect in target_effects:
			var new_ctx = SkillExecutionContext.new()
			new_ctx.setup_manual(ctx.caster_stats,ctx.get_cast_point(),t)
			e.execute(new_ctx)

func get_targets(ctx:SkillExecutionContext) -> Array[Alive]:
	var q := PhysicsShapeQueryParameters2D.new()
	q.collide_with_areas = 1
	q.collide_with_bodies = 0
	q.transform = Transform2D(0,ctx.get_application_point())
	
	var c = CircleShape2D.new()
	c.radius = radius
	q.shape = c
	
	var res:Array[Alive]
	var bds = ctx.target.get_world_2d().direct_space_state.intersect_shape(q)
	for b in bds:
		if b.collider is Unit:
			res.append(b.collider)
		
	return res
