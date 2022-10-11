<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/communicationsmonthly.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$communicationsmonthlyclient = new communicationsmonthly($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
        if(isset($_GET["comm"]))
            {  
        $result = $communicationsmonthlyclient->getcommunicationsmonthlyByStudentIDandMonth($_GET["sid"],$_GET["month"]);
            }
        if(isset($_GET["remove"]))
            {  
            $result = $communicationsmonthlyclient->remove($_GET["sid"],$_GET["month"]);    
            }
        if(isset($_GET["student"]))
            {  
            $result = $communicationsmonthlyclient->getcommunicationsmonthlyByStudentID($_GET["student"]);  
            }
        break;
     case "POST":
        if(isset($_GET["add"]))
           {           
             $result = $communicationsmonthlyclient->addcommunicationsmonthly($_GET["sid"],$_GET["month"],json_decode(file_get_contents('php://input'), true));
           }
         if(isset($_GET["update"]))
           { $result = $communicationsmonthlyclient->updatecommunicationsmonthly($_GET["sid"],$_GET["month"],json_decode(file_get_contents('php://input'), true));
           }
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