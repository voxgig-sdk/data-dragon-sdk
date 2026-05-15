<?php
declare(strict_types=1);

// DataDragon SDK utility: feature_hook

class DataDragonFeatureHook
{
    public static function call(DataDragonContext $ctx, string $name): void
    {
        if (!$ctx->client) {
            return;
        }
        $features = $ctx->client->features ?? null;
        if (!$features) {
            return;
        }
        foreach ($features as $f) {
            if (method_exists($f, $name)) {
                $f->$name($ctx);
            }
        }
    }
}
