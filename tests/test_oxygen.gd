extends SceneTree
const Rules = preload("res://scripts/oxygen_rules.gd")

func _initialize() -> void:
	assert(is_equal_approx(Rules.consume_oxygen(100.0, 10.0), 85.0))
	assert(is_equal_approx(Rules.consume_oxygen(4.0, 10.0), 0.0))
	assert(is_equal_approx(Rules.consume_oxygen(100.0, 0.0), 100.0))
	assert(is_equal_approx(Rules.replenish_oxygen(95.0), 100.0))
	assert(is_equal_approx(Rules.replenish_oxygen(40.0), 52.0))
	assert(Rules.can_collect(1.8))
	assert(not Rules.can_collect(1.81))
	assert(not Rules.can_collect(-1.0))
	print("Oxygen rules: 8 assertions passed")
	quit()
