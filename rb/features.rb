# DataDragon SDK feature factory

require_relative 'feature/base_feature'
require_relative 'feature/ratelimit_feature'
require_relative 'feature/retry_feature'
require_relative 'feature/test_feature'
require_relative 'feature/timeout_feature'


module DataDragonFeatures
  def self.make_feature(name)
    case name
    when "base"
      DataDragonBaseFeature.new
    when "ratelimit"
      DataDragonRatelimitFeature.new
    when "retry"
      DataDragonRetryFeature.new
    when "test"
      DataDragonTestFeature.new
    when "timeout"
      DataDragonTimeoutFeature.new
    else
      DataDragonBaseFeature.new
    end
  end
end
