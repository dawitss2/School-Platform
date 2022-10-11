<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/etcalmonth.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$etcalmonthclient = new etcalmonth($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
        $result = $etcalmonthclient->getAll($_GET["all"],$_GET["sid"]);
        break;
    case "DELETE":
        //parse_str(file_get_contents("php://input"), $_DELETE);
        //$result = $studentclient->remove($_DELETE["id"]);
        break;
}

//http://localhost/progress_api/studentreception.php?sname=Dawit&fname=Wubshet&gfname=Abebe&gname=Grade%20%201&section=A
header("Content-Type: application/json");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
echo json_encode($result);

?>