<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/quote.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$quoteclient = new quote($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
        $result = $quoteclient->getAll();
        break;
    case "DELETE":
        //parse_str(file_get_contents("php://input"), $_DELETE);
        //$result = $studentclient->remove($_DELETE["id"]);
        break;
}
        header("Content-Type: application/json");
        header("Access-Control-Allow-Headers: *");
        header("Access-Control-Allow-Origin: *");
        echo json_encode($result);

?>