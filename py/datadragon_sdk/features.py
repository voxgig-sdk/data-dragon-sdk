# DataDragon SDK feature factory

from datadragon_sdk.feature.base_feature import DataDragonBaseFeature
from datadragon_sdk.feature.test_feature import DataDragonTestFeature


def _make_feature(name):
    features = {
        "base": lambda: DataDragonBaseFeature(),
        "test": lambda: DataDragonTestFeature(),
    }
    factory = features.get(name)
    if factory is not None:
        return factory()
    return features["base"]()
