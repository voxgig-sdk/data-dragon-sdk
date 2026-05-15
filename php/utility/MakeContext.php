<?php
declare(strict_types=1);

// DataDragon SDK utility: make_context

require_once __DIR__ . '/../core/Context.php';

class DataDragonMakeContext
{
    public static function call(array $ctxmap, ?DataDragonContext $basectx): DataDragonContext
    {
        return new DataDragonContext($ctxmap, $basectx);
    }
}
