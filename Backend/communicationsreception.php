<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/communications.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$communicationsclient = new communications($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
            if(isset($_GET["add"]))
            {
             $result = $communicationsclient ->addCommunicationItem($_GET["type"],$_GET["value"],$_GET["catagory"]);               
            }  
            if(isset($_GET["update"]))
            {       
               $result = $communicationsclient ->updateCommunicationItem($_GET["type"],$_GET["value"],$_GET["catagory"],$_GET["cid"]); 
            }
            if(isset($_GET["all"]))
            {       
            $result = $communicationsclient -> getAll();
            }
            if(isset($_GET["type"]))
            {       
            $result = $communicationsclient -> getcommunicationsByType($_GET["type"]);
            }
            if(isset($_GET["remove"]))
            {  
               $result = $communicationsclient->removeCommunicationItem($_GET["cid"]);   
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