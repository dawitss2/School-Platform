<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/communicationsweekly.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$communicationsweeklyclient = new communicationsweekly($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":             
         if(isset($_GET["all"]))
            {  
              if($_GET["all"]==1)     
                {$result = $communicationsweeklyclient->getnewcommunicationWeeks($_GET["sid"]);}
              else
                {$result = $communicationsweeklyclient->getaddedcommunicationWeeks($_GET["sid"]);}
            }
        if(isset($_GET["comm"]))
            {  
        $result = $communicationsweeklyclient->getcommunicationsweklyByStudentIDandWeek($_GET["sid"],$_GET["week"]);
            }
        if(isset($_GET["remove"]))
            {  
            $result = $communicationsweeklyclient->remove($_GET["sid"],$_GET["week"]);    
            }
        if(isset($_GET["student"]))
            {
               $result = $communicationsweeklyclient->getcommunicationsweklyByStudentID($_GET["student"]);  
            }
        break;
    case "POST":
        if(isset($_GET["add"]))
           {           
             $result = $communicationsweeklyclient->addcommunicationsweekly($_GET["sid"],$_GET["week"],json_decode(file_get_contents('php://input'), true));
           }
         if(isset($_GET["update"]))
           { $result = $communicationsweeklyclient->updatecommunicationsweekly($_GET["sid"],$_GET["week"],json_decode(file_get_contents('php://input'), true));
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