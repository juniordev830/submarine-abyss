import unittest
from navigation import Submarine

class TestSubmarine(unittest.TestCase):
    def test_move_consumes_resources(self):
        sub = Submarine()
        sub.move(2, 0, 1, 1)
        self.assertEqual(sub.depth_m, 1)
        self.assertLess(sub.oxygen_pct, 100)
        self.assertLess(sub.battery_pct, 100)

    def test_depth_limit(self):
        with self.assertRaises(ValueError):
            Submarine(depth_m=500).move(0, 0, 1, 1)

    def test_speed_limit(self):
        with self.assertRaises(ValueError):
            Submarine().move(5, 0, 0, 1)

    def test_target_detection(self):
        sub = Submarine(x=10, y=10, depth_m=20)
        self.assertTrue(sub.at_target(11, 10, 20))
        self.assertFalse(sub.at_target(20, 10, 20))

    def test_resource_failure_is_atomic(self):
        sub = Submarine(battery_pct=0)
        with self.assertRaises(RuntimeError):
            sub.move(2, 0, 0, 1)
        self.assertEqual(sub.x, 0)

if __name__ == "__main__":
    unittest.main()
