extends RefCounted
## Standalone, deterministic rules for an underwater exploration game.

static func consume_oxygen(current: float, seconds: float, rate: float = 1.5) -> float:
	if current < 0.0 or seconds < 0.0 or rate < 0.0:
		return 0.0
	return clampf(current - seconds * rate, 0.0, 100.0)


static func replenish_oxygen(current: float, amount: float = 12.0) -> float:
	return clampf(maxf(0.0, current) + maxf(0.0, amount), 0.0, 100.0)


static func can_collect(distance: float, reach: float = 1.8) -> bool:
	return distance >= 0.0 and reach >= 0.0 and distance <= reach
