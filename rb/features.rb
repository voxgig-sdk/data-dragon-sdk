# DataDragon SDK feature factory

require_relative 'feature/base_feature'
require_relative 'feature/test_feature'


module DataDragonFeatures
  def self.make_feature(name)
    case name
    when "base"
      DataDragonBaseFeature.new
    when "test"
      DataDragonTestFeature.new
    else
      DataDragonBaseFeature.new
    end
  end
end
