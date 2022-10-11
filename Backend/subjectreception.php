<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/subject.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$subjectclient = new subject($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
         if(isset($_GET["add"]))
            {
                        if($_GET["add"]==1)
                    {$result = $subjectclient->addSubject($_GET["name"]);}
                        else
                        {
                     $result = $subjectclient->assignSubject($_GET["name"],$_GET["grade"],$_GET["type"],$_GET["subjid"]); 
                        }
            }  
            if(isset($_GET["update"]))
             {       
                        if($_GET["update"]==1)
                        {$result = $subjectclient->updateSubject($_GET["name"],$_GET["subjid"]);}
                            else
                            {
                         $result = $subjectclient->assignSubject($_GET["name"],$_GET["grade"],$_GET["type"],$_GET["subjid"]); 
                            }
            }
            if(isset($_GET["all"]))
            {       
            $result = $subjectclient-> getAll();
            }
            if(isset($_GET["grd"]))
            {       
            $result = $subjectclient-> getAssignedByGrade($_GET["grd"]);
            }
            if(isset($_GET["remove"]))
            {  
                if($_GET["remove"]==1)
                    {$result = $subjectclient->remove($_GET["subjid"]);}
                 else
                    {
                    $result = $subjectclient->removeGradeAssignment($_GET["subjid"],$_GET["grade"]); 
                    }     
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