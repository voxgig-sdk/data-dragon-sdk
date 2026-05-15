<?php
declare(strict_types=1);

// DataDragon SDK utility: result_body

class DataDragonResultBody
{
    public static function call(DataDragonContext $ctx): ?DataDragonResult
    {
        $response = $ctx->response;
        $result = $ctx->result;
        if ($result && $response && $response->json_func && $response->body) {
            $result->body = ($response->json_func)();
        }
        return $result;
    }
}
