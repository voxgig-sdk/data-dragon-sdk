<?php
declare(strict_types=1);

// DataDragon SDK utility: prepare_body

class DataDragonPrepareBody
{
    public static function call(DataDragonContext $ctx): mixed
    {
        if ($ctx->op->input === 'data') {
            return ($ctx->utility->transform_request)($ctx);
        }
        return null;
    }
}
