<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include_once "trans.php";

$config = include("db/config.php");
$db = new PDO($config["db3"], $config["username"], $config["password"]);
$db2 = new PDO($config["db2"], $config["username"], $config["password"]);
$db3 = new PDO($config["db4"], $config["username"], $config["password"]);
$db4 = new PDO($config["db5"], $config["username"], $config["password"]);
//$db->exec("setname utf8");

$result = array();
$transclient = new trans($db,$db2,$db3,$db4);
$result = $transclient->getAttachment();

header("Content-Type: application/json");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Origin: *");
echo json_encode($result);

?>
