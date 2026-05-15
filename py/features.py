# DataDragon SDK feature factory

from feature.base_feature import DataDragonBaseFeature
from feature.test_feature import DataDragonTestFeature


def _make_feature(name):
    features = {
        "base": lambda: DataDragonBaseFeature(),
        "test": lambda: DataDragonTestFeature(),
    }
    factory = features.get(name)
    if factory is not None:
        return factory()
    return features["base"]()
