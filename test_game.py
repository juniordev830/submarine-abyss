import unittest
from game import explore


class GameTests(unittest.TestCase):
    def test_invalid_command(self):
        self.assertEqual(explore(commands=["unknown"]), ["Unknown command"])

    def test_dive_changes_depth(self):
        self.assertIn("Depth: 10m", explore(seed=1, commands=["dive"])[0])

    def test_quit_does_not_consume_oxygen(self):
        self.assertEqual(explore(commands=["quit"]), [])


if __name__ == "__main__":
    unittest.main()
