<?php
declare(strict_types=1);

// DataDragon SDK utility: feature_add

class DataDragonFeatureAdd
{
    public static function call(DataDragonContext $ctx, mixed $f): void
    {
        $ctx->client->features[] = $f;
    }
}
