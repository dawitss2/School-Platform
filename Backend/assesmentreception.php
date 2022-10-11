<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include_once "models/assesment.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$assesmentclient = new assesment($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
          if(isset($_GET["add"]))
            {   
               if($_GET["add"]==1)
                {    
                    $result = $assesmentclient-> addAssessment($_GET['name'],$_GET['value']);
                }
                else
                {
                    $result = $assesmentclient->addAssessmentAssignment($_GET['assid'],$_GET['grade'],$_GET['subject']);
                }      
            }  
            if(isset($_GET["update"]))
            {                   
                if($_GET["update"]==1)
                {    
                    $result = $assesmentclient-> updateAssessment($_GET['name'],$_GET['value'],$_GET['assid']);
                }
                else
                {
                    $result = $assesmentclient->updateAssessmentAssignment($_GET['assid'],$_GET['grade'],$_GET['subject']);
                } 
            }
            if(isset($_GET["all"]))
            {   
                if($_GET["all"]==1)
                {    
                $result = $assesmentclient->getAll() ;
                }
                else
                {
                    $result = $assesmentclient->getAll_assignment();
                }
            }
            if(isset($_GET["stuval"]))
            {   
                if($_GET["stuval"]==1)
                {    
                $result = $assesmentclient-> addAssessmentResultStudent($_GET['aid'],$_GET['sid'],$_GET['value']);
                }
                else
                {
                $result = $assesmentclient->updateAssessmentResultStudent($_GET['aid'],$_GET['sid'],$_GET['value']);
                }
            }
            if(isset($_GET["fill"]))
            {
               $result = $assesmentclient->get_assignment($_GET["grade"],$_GET["subject"]);
            }
            if(isset($_GET["student"]))
            {
               $result = $assesmentclient->getAssesmentWithResultByStudentID($_GET["student"]);
            }
             if(isset($_GET["val"]))
            {  if($_GET["val"]==1)
               {$result = $assesmentclient->getAssessmentResultByGradeandSection($_GET["aid"],$_GET["grade"],$_GET["section"]);}
               else
               {$result = $assesmentclient->getAssessmentResultByStudent($_GET["aid"],$_GET["sid"]);  
               }
            }
            if(isset($_GET["remove"]))
            {      
            if($_GET["remove"]==1)
                {    
                    $result = $assesmentclient->removeAssessment($_GET['assid']);
                }
                else
                {
                    $result = $assesmentclient->removeAssessmentAssignment($_GET['assid']);
                }    
            }
     case "POST":
           if(isset($_GET["addres"]))
           {           
             $result = $assesmentclient->addAssessmentResult($_GET["aid"],$_GET["gname"],$_GET["section"],json_decode(file_get_contents('php://input'), true));
             //$communicationsweeklyclient->addcommunicationsweekly($_GET["sid"],$_GET["week"],json_decode(file_get_contents('php://input'), true));
           }
         if(isset($_GET["updateres"]))
           {  
            $result = $assesmentclient->updateAssessmentResult($_GET["aid"],$_GET["gname"],$_GET["section"],json_decode(file_get_contents('php://input'), true));
           }
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
echo json_encode($result);

?>
