<?php
declare(strict_types=1);

// DataDragon SDK base feature

class DataDragonBaseFeature
{
    public string $version;
    public string $name;
    public bool $active;

    public function __construct()
    {
        $this->version = '0.0.1';
        $this->name = 'base';
        $this->active = true;
    }

    public function get_version(): string { return $this->version; }
    public function get_name(): string { return $this->name; }
    public function get_active(): bool { return $this->active; }

    public function init(DataDragonContext $ctx, array $options): void {}
    public function PostConstruct(DataDragonContext $ctx): void {}
    public function PostConstructEntity(DataDragonContext $ctx): void {}
    public function SetData(DataDragonContext $ctx): void {}
    public function GetData(DataDragonContext $ctx): void {}
    public function GetMatch(DataDragonContext $ctx): void {}
    public function SetMatch(DataDragonContext $ctx): void {}
    public function PrePoint(DataDragonContext $ctx): void {}
    public function PreSpec(DataDragonContext $ctx): void {}
    public function PreRequest(DataDragonContext $ctx): void {}
    public function PreResponse(DataDragonContext $ctx): void {}
    public function PreResult(DataDragonContext $ctx): void {}
    public function PreDone(DataDragonContext $ctx): void {}
    public function PreUnexpected(DataDragonContext $ctx): void {}
}
