@tool
extends Chase
class_name RangedChase

@export var backstep_factor:float = 0.7

func exec(delta:float) -> void:
	
	var target:Alive = ctx.target()
	ctx.nv.update_moving_target(target)
	
	var vec:Vector2 = target.global_position - ctx.unit.global_position
	var dist_sq:float = vec.length_squared()
	var attack_rng:float = ctx.attack_comp.range_sq()
	
	#closing
	if dist_sq > attack_rng:
		ctx.move(speed * ctx.nv.get_next_point_dir())
	
	#backstep
	elif dist_sq < (attack_rng * backstep_factor):
		ctx.nv.set_target_manual(ctx.unit.global_position + speed * -vec.normalized())
		ctx.move(speed * ctx.nv.get_next_point_dir())
	#can attack c 	else:
		ctx.targeter.find_best_target()
		if bb.is_have_a_good_spell():
			request_transition.emit(ID.PRECAST)
		else:
			#rotation
			ctx.move(vec.normalized())
			request_transition.emit(ID.SWING)
