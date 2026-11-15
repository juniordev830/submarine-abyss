"""Finite-resource underwater exploration model for a fictional mission."""
from dataclasses import dataclass
from math import dist, isfinite


def finite(v):
    if isinstance(v, bool) or not isinstance(v, (int, float)) or not isfinite(v):
        raise ValueError("numeric value must be finite")
    return float(v)


@dataclass(frozen=True)
class Point:
    x: float
    y: float
    depth: float

    def __post_init__(self):
        for v in (self.x, self.y, self.depth):
            finite(v)


class Mission:
    def __init__(self, target=Point(4, 0, 6), energy=100, oxygen=100, max_depth=40):
        self.target = target
        self.start_energy = finite(energy)
        self.start_oxygen = finite(oxygen)
        self.max_depth = finite(max_depth)
        if min(self.start_energy, self.start_oxygen, self.max_depth) <= 0:
            raise ValueError("invalid mission resource")
        if not 0 <= target.depth <= self.max_depth:
            raise ValueError("target outside depth limits")
        self.reset()

    def reset(self):
        self.position = Point(0, 0, 0)
        self.energy = self.start_energy
        self.oxygen = self.start_oxygen
        self.carrying = False
        self.finished = False

    def move(self, dx, dy, ddepth):
        if self.finished:
            raise ValueError("mission already finished")
        delta = [finite(v) for v in (dx, dy, ddepth)]
        next_pos = Point(self.position.x + delta[0], self.position.y + delta[1],
                         self.position.depth + delta[2])
        if not 0 <= next_pos.depth <= self.max_depth:
            raise ValueError("outside depth bounds")
        cost = dist((0, 0, 0), delta)
        if cost > self.energy:
            raise ValueError("insufficient energy")
        self.energy -= cost
        self.position = next_pos

    def tick(self, dt):
        dt = finite(dt)
        if not 0 < dt <= 60:
            raise ValueError("invalid time step")
        if not self.finished:
            self.oxygen = max(0.0, self.oxygen - dt * 0.1)
        if self.oxygen == 0:
            raise ValueError("oxygen exhausted")

    def collect(self):
        if self.carrying or dist(tuple(vars(self.position).values()),
                                  tuple(vars(self.target).values())) > 1:
            raise ValueError("target out of range or already collected")
        self.carrying = True

    def deliver(self):
        if not self.carrying or dist(tuple(vars(self.position).values()), (0, 0, 0)) > 1:
            raise ValueError("return to base with the item")
        self.finished = True


if __name__ == "__main__":
    mission = Mission()
    mission.move(4, 0, 6)
    mission.collect()
    mission.move(-4, 0, -6)
    mission.deliver()
    print("Mission completed:", mission.finished)
