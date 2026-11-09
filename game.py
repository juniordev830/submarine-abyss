"""Submarine Abyss: a dependency-free terminal exploration game."""
import random

MAX_HULL = 100
MAX_OXYGEN = 12


def explore(seed=None, commands=None):
    rng = random.Random(seed)
    hull, oxygen, depth, treasures = MAX_HULL, MAX_OXYGEN, 0, 0
    log = []
    for command in commands or []:
        if command == "quit":
            break
        if command not in {"dive", "surface", "scan", "repair"}:
            log.append("Unknown command")
            continue
        oxygen -= 1
        if command == "dive":
            depth += 10
            hull -= rng.randint(0, 12)
        elif command == "surface":
            depth = max(0, depth - 20)
        elif command == "scan" and depth > 0:
            treasures += int(rng.random() < 0.5)
        elif command == "repair":
            hull = min(MAX_HULL, hull + 8)
        log.append(f"Depth: {depth}m | Hull: {hull} | Oxygen: {oxygen} | Treasures: {treasures}")
        if hull <= 0 or oxygen <= 0:
            log.append("Mission failed")
            break
        if depth == 0 and treasures:
            log.append("Mission complete")
            break
    return log


def main():
    print("Submarine Abyss | dive, surface, scan, repair, quit")
    commands = []
    while True:
        command = input("> ").strip().lower()
        commands.append(command)
        result = explore(seed=42, commands=commands)
        if result:
            print(result[-1])
        if command == "quit" or (result and result[-1] in {"Mission failed", "Mission complete"}):
            break


if __name__ == "__main__":
    main()
