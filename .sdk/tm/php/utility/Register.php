<?php
declare(strict_types=1);

// DataDragon SDK utility registration

require_once __DIR__ . '/../core/UtilityType.php';
require_once __DIR__ . '/Clean.php';
require_once __DIR__ . '/Done.php';
require_once __DIR__ . '/MakeError.php';
require_once __DIR__ . '/FeatureAdd.php';
require_once __DIR__ . '/FeatureHook.php';
require_once __DIR__ . '/FeatureInit.php';
require_once __DIR__ . '/Fetcher.php';
require_once __DIR__ . '/MakeFetchDef.php';
require_once __DIR__ . '/MakeContext.php';
require_once __DIR__ . '/MakeOptions.php';
require_once __DIR__ . '/MakeRequest.php';
require_once __DIR__ . '/MakeResponse.php';
require_once __DIR__ . '/MakeResult.php';
require_once __DIR__ . '/MakePoint.php';
require_once __DIR__ . '/MakeSpec.php';
require_once __DIR__ . '/MakeUrl.php';
require_once __DIR__ . '/Param.php';
require_once __DIR__ . '/PrepareAuth.php';
require_once __DIR__ . '/PrepareBody.php';
require_once __DIR__ . '/PrepareHeaders.php';
require_once __DIR__ . '/PrepareMethod.php';
require_once __DIR__ . '/PrepareParams.php';
require_once __DIR__ . '/PreparePath.php';
require_once __DIR__ . '/PrepareQuery.php';
require_once __DIR__ . '/ResultBasic.php';
require_once __DIR__ . '/ResultBody.php';
require_once __DIR__ . '/ResultHeaders.php';
require_once __DIR__ . '/TransformRequest.php';
require_once __DIR__ . '/TransformResponse.php';

DataDragonUtility::setRegistrar(function (DataDragonUtility $u): void {
    $u->clean = [DataDragonClean::class, 'call'];
    $u->done = [DataDragonDone::class, 'call'];
    $u->make_error = [DataDragonMakeError::class, 'call'];
    $u->feature_add = [DataDragonFeatureAdd::class, 'call'];
    $u->feature_hook = [DataDragonFeatureHook::class, 'call'];
    $u->feature_init = [DataDragonFeatureInit::class, 'call'];
    $u->fetcher = [DataDragonFetcher::class, 'call'];
    $u->make_fetch_def = [DataDragonMakeFetchDef::class, 'call'];
    $u->make_context = [DataDragonMakeContext::class, 'call'];
    $u->make_options = [DataDragonMakeOptions::class, 'call'];
    $u->make_request = [DataDragonMakeRequest::class, 'call'];
    $u->make_response = [DataDragonMakeResponse::class, 'call'];
    $u->make_result = [DataDragonMakeResult::class, 'call'];
    $u->make_point = [DataDragonMakePoint::class, 'call'];
    $u->make_spec = [DataDragonMakeSpec::class, 'call'];
    $u->make_url = [DataDragonMakeUrl::class, 'call'];
    $u->param = [DataDragonParam::class, 'call'];
    $u->prepare_auth = [DataDragonPrepareAuth::class, 'call'];
    $u->prepare_body = [DataDragonPrepareBody::class, 'call'];
    $u->prepare_headers = [DataDragonPrepareHeaders::class, 'call'];
    $u->prepare_method = [DataDragonPrepareMethod::class, 'call'];
    $u->prepare_params = [DataDragonPrepareParams::class, 'call'];
    $u->prepare_path = [DataDragonPreparePath::class, 'call'];
    $u->prepare_query = [DataDragonPrepareQuery::class, 'call'];
    $u->result_basic = [DataDragonResultBasic::class, 'call'];
    $u->result_body = [DataDragonResultBody::class, 'call'];
    $u->result_headers = [DataDragonResultHeaders::class, 'call'];
    $u->transform_request = [DataDragonTransformRequest::class, 'call'];
    $u->transform_response = [DataDragonTransformResponse::class, 'call'];
});
