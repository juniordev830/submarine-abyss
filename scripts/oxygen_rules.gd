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


## Altitude is an in-game vertical coordinate; lower positions consume more oxygen.
## The multiplier is capped so missions remain finite and predictable.
static func oxygen_rate_at_depth(height: float, surface_y: float = 10.0, base_rate: float = 1.5) -> float:
	if not is_finite(height) or not is_finite(surface_y) or not is_finite(base_rate):
		return 0.0
	if base_rate < 0.0:
		return 0.0
	var depth: float = maxf(0.0, surface_y - height)
	var multiplier: float = 1.0 + minf(depth / 20.0, 1.0)
	return base_rate * multiplier


static func estimated_oxygen_seconds(current: float, rate: float) -> float:
	if not is_finite(current) or not is_finite(rate):
		return 0.0
	if current <= 0.0 or rate <= 0.0:
		return 0.0
	return current / rate

## Locate the nearest remaining pearl; invalid coordinates never become a target.
static func nearest_target_index(origin: Vector3, targets: Array[Vector3]) -> int:
	if not origin.is_finite():
		return -1
	var nearest_index := -1
	var nearest_squared := INF
	for index in range(targets.size()):
		var point: Vector3 = targets[index]
		if not point.is_finite():
			continue
		var squared: float = origin.distance_squared_to(point)
		if squared < nearest_squared:
			nearest_squared = squared
			nearest_index = index
	return nearest_index


## World-axis bearings: X positive is east, Z negative is north.
static func sonar_direction(origin: Vector3, target: Vector3) -> String:
	if not origin.is_finite() or not target.is_finite():
		return "DESCONHECIDO"
	var offset: Vector3 = target - origin
	var horizontal: float = maxf(absf(offset.x), absf(offset.z))
	if absf(offset.y) > horizontal:
		return "SUBIR" if offset.y > 0.0 else "DESCER"
	if horizontal < 0.001:
		return "AQUI"
	if absf(offset.x) >= absf(offset.z):
		return "LESTE" if offset.x > 0.0 else "OESTE"
	return "SUL" if offset.z > 0.0 else "NORTE"
