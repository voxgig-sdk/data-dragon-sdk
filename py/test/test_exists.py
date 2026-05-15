# ProjectName SDK exists test

import pytest
from datadragon_sdk import DataDragonSDK


class TestExists:

    def test_should_create_test_sdk(self):
        testsdk = DataDragonSDK.test(None, None)
        assert testsdk is not None
