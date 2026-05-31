class ProposedAlgorithm:
    """Skeleton for the paper's proposed algorithm."""

    def __init__(self, instance, config=None):
        self.instance = instance
        self.config = config or {}

    def initialize(self):
        raise NotImplementedError

    def iterate(self):
        raise NotImplementedError

    def run(self):
        """Return a unified Result/Schedule object."""
        raise NotImplementedError
