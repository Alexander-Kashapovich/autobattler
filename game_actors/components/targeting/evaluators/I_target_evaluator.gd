@abstract
extends Resource
class_name TargeterEvaluator

@export var value:float = 1.0

@abstract
func evaluate(targets:Array[TargetWeight],ctx:TargetEvaluationContext) -> void
