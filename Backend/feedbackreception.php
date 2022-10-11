<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/feedback.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
$feedbackclient = new Feedback($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":  
        if(isset($_GET["add"]))         
        {   
            if($_GET["add"]==1)
            {
                $result = $feedbackclient->addMonthlyFeedback($_GET['sid'],$_GET['mid'],$_GET['val']);
            }
            else
            {
                $result = $feedbackclient->addweeklyFeedback($_GET['sid'],$_GET['wid'],$_GET['val']);
            }
        }
        if(isset($_GET["get"]))
        {
            if($_GET["get"]==1)
            {$result = $feedbackclient->getmonthlyFeedBack($_GET['sid'],$_GET['mid']);}
            else
            {$result = $feedbackclient->getweeklyFeedBack($_GET['sid'],$_GET['wid']);} 
        }
        break;
    case "DELETE":
        break;
}
        header("Content-Type: application/json");
        header("Access-Control-Allow-Headers: *");
        header("Access-Control-Allow-Origin: *");
        echo json_encode($result);

?>