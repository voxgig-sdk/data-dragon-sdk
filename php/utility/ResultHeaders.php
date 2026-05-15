<?php
declare(strict_types=1);

// DataDragon SDK utility: result_headers

class DataDragonResultHeaders
{
    public static function call(DataDragonContext $ctx): ?DataDragonResult
    {
        $response = $ctx->response;
        $result = $ctx->result;
        if ($result) {
            if ($response && is_array($response->headers)) {
                $result->headers = $response->headers;
            } else {
                $result->headers = [];
            }
        }
        return $result;
    }
}
