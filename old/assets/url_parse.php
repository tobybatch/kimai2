#!/usr/bin/env php
<?php
$parts = parse_url($argv[1]);
echo ltrim($parts[$argv[2]] ?? "", "/");

