import unittest
from core import Mission, Point


class MissionTests(unittest.TestCase):
    def test_collect_and_deliver(self):
        mission = Mission()
        with self.assertRaises(ValueError):
            mission.collect()
        mission.move(4, 0, 6)
        mission.collect()
        with self.assertRaises(ValueError):
            mission.collect()
        with self.assertRaises(ValueError):
            mission.deliver()
        mission.move(-4, 0, -6)
        mission.deliver()
        self.assertTrue(mission.finished)

    def test_resource_and_depth_limits(self):
        mission = Mission(energy=2)
        with self.assertRaises(ValueError):
            mission.move(4, 0, 0)
        self.assertEqual(mission.energy, 2)
        self.assertEqual(mission.position, Point(0, 0, 0))
        with self.assertRaises(ValueError):
            mission.move(0, 0, -1)

    def test_oxygen_and_reset(self):
        mission = Mission()
        mission.tick(10)
        self.assertEqual(mission.oxygen, 99)
        mission.move(1, 0, 1)
        mission.reset()
        self.assertEqual(mission.position, Point(0, 0, 0))
        self.assertEqual(mission.energy, 100)

    def test_invalid_values(self):
        mission = Mission()
        for bad in (0, -1, float("inf"), float("nan")):
            with self.assertRaises(ValueError):
                mission.tick(bad)


if __name__ == "__main__":
    unittest.main()
