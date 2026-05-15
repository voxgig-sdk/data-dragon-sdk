# DataDragon SDK utility: feature_add
module DataDragonUtilities
  FeatureAdd = ->(ctx, f) {
    ctx.client.features << f
  }
end
