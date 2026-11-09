"""Simple underwater navigation and oxygen management prototype."""
from dataclasses import dataclass
from math import hypot

@dataclass
class Submarine:
    x: float = 0.0
    y: float = 0.0
    depth_m: float = 0.0
    oxygen_pct: float = 100.0
    battery_pct: float = 100.0

    def move(self, dx: float, dy: float, depth_change: float, dt: float) -> None:
        if not 0 < dt <= 1:
            raise ValueError("dt must be between 0 and 1 second")
        if hypot(dx, dy) > 4 * dt or abs(depth_change) > 2 * dt:
            raise ValueError("Movement exceeds safe speed")
        next_depth = self.depth_m + depth_change
        if not 0 <= next_depth <= 500:
            raise ValueError("Depth outside operational range")
        battery_cost = (hypot(dx, dy) + abs(depth_change)) * 0.08
        oxygen_cost = dt * 0.03
        if self.battery_pct < battery_cost or self.oxygen_pct < oxygen_cost:
            raise RuntimeError("Insufficient battery or oxygen")
        self.x += dx
        self.y += dy
        self.depth_m = next_depth
        self.battery_pct -= battery_cost
        self.oxygen_pct -= oxygen_cost

    def at_target(self, x: float, y: float, depth_m: float, tolerance: float = 2) -> bool:
        if tolerance < 0:
            raise ValueError("Tolerance cannot be negative")
        return hypot(self.x - x, self.y - y) <= tolerance and abs(self.depth_m - depth_m) <= tolerance

if __name__ == "__main__":
    sub = Submarine()
    sub.move(2, 0, 1, 1)
    print(sub)
