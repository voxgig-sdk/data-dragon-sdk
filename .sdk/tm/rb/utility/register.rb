# DataDragon SDK utility registration
require_relative '../core/utility_type'
require_relative 'clean'
require_relative 'done'
require_relative 'make_error'
require_relative 'feature_add'
require_relative 'feature_hook'
require_relative 'feature_init'
require_relative 'fetcher'
require_relative 'make_fetch_def'
require_relative 'make_context'
require_relative 'make_options'
require_relative 'make_request'
require_relative 'make_response'
require_relative 'make_result'
require_relative 'make_point'
require_relative 'make_spec'
require_relative 'make_url'
require_relative 'param'
require_relative 'prepare_auth'
require_relative 'prepare_body'
require_relative 'prepare_headers'
require_relative 'prepare_method'
require_relative 'prepare_params'
require_relative 'prepare_path'
require_relative 'prepare_query'
require_relative 'result_basic'
require_relative 'result_body'
require_relative 'result_headers'
require_relative 'transform_request'
require_relative 'transform_response'

DataDragonUtility.registrar = ->(u) {
  u.clean = DataDragonUtilities::Clean
  u.done = DataDragonUtilities::Done
  u.make_error = DataDragonUtilities::MakeError
  u.feature_add = DataDragonUtilities::FeatureAdd
  u.feature_hook = DataDragonUtilities::FeatureHook
  u.feature_init = DataDragonUtilities::FeatureInit
  u.fetcher = DataDragonUtilities::Fetcher
  u.make_fetch_def = DataDragonUtilities::MakeFetchDef
  u.make_context = DataDragonUtilities::MakeContext
  u.make_options = DataDragonUtilities::MakeOptions
  u.make_request = DataDragonUtilities::MakeRequest
  u.make_response = DataDragonUtilities::MakeResponse
  u.make_result = DataDragonUtilities::MakeResult
  u.make_point = DataDragonUtilities::MakePoint
  u.make_spec = DataDragonUtilities::MakeSpec
  u.make_url = DataDragonUtilities::MakeUrl
  u.param = DataDragonUtilities::Param
  u.prepare_auth = DataDragonUtilities::PrepareAuth
  u.prepare_body = DataDragonUtilities::PrepareBody
  u.prepare_headers = DataDragonUtilities::PrepareHeaders
  u.prepare_method = DataDragonUtilities::PrepareMethod
  u.prepare_params = DataDragonUtilities::PrepareParams
  u.prepare_path = DataDragonUtilities::PreparePath
  u.prepare_query = DataDragonUtilities::PrepareQuery
  u.result_basic = DataDragonUtilities::ResultBasic
  u.result_body = DataDragonUtilities::ResultBody
  u.result_headers = DataDragonUtilities::ResultHeaders
  u.transform_request = DataDragonUtilities::TransformRequest
  u.transform_response = DataDragonUtilities::TransformResponse
}
