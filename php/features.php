<?php
declare(strict_types=1);

// DataDragon SDK feature factory

require_once __DIR__ . '/feature/BaseFeature.php';
require_once __DIR__ . '/feature/TestFeature.php';


class DataDragonFeatures
{
    public static function make_feature(string $name)
    {
        switch ($name) {
            case "base":
                return new DataDragonBaseFeature();
            case "test":
                return new DataDragonTestFeature();
            default:
                return new DataDragonBaseFeature();
        }
    }
}
