extends Timer
class_name BuffHandler
## Manage [BuffSkill]'s of owner

class BuffProcessor:
	var buff:BuffSkill
	var c:SkillExecutionContext
	var current_time:float = 0
	var total_time:float = 0
	
	func _init(b:BuffSkill,_c:SkillExecutionContext) -> void:
		buff = b
		c = _c
		#first exec
		execute()

	func execute() -> void:
		buff.execute(c)

@export var unit:Alive

var enabled:bool = 1

var _buffs:Array[BuffProcessor]

func _ready() -> void:
	timeout.connect(tick)

func append(buff:BuffSkill,c:SkillExecutionContext) -> void:
	_buffs.append(BuffProcessor.new(buff,c))
	#forgeted whai is it for
	if enabled and _buffs.size() == 1:
		start()

## When die
func off() -> void:
	enabled = 0
	stop()

func tick() -> void:
	var q_to_del:Array[BuffProcessor]
	var delta:float = wait_time

	for buff_p in _buffs:
		buff_p.current_time += delta
		if buff_p.current_time > buff_p.buff.tick:
			buff_p.execute()
			buff_p.current_time -= buff_p.buff.tick
			
			buff_p.total_time += buff_p.buff.tick
			if buff_p.total_time > buff_p.buff.time:
				q_to_del.append(buff_p)
				
	for buff_p in q_to_del:
		if buff_p.buff.end_skill:
			buff_p.buff.end_skill.execute(buff_p.c)
		_buffs.erase(buff_p)
	
	if _buffs.is_empty():
		stop()
