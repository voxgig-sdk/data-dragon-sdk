# DataDragon SDK exists test

require "minitest/autorun"
require_relative "../DataDragon_sdk"

class ExistsTest < Minitest::Test
  def test_create_test_sdk
    testsdk = DataDragonSDK.test(nil, nil)
    assert !testsdk.nil?
  end
end
