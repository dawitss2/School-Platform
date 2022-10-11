<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/student.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$studentclient = new student($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":  
            if(isset($_GET["add"]))
            {
                if($_GET["add"]==1)
            {$result = $studentclient->addStudent($_GET["sname"],$_GET["fname"],$_GET["gfname"],$_GET["gen"],$_GET["gname"],$_GET["section"],$_GET["fmob"],$_GET["mmob"],$_GET["add"],$_GET["kk"],$_GET["wor"],$_GET["hno"]);}
                else
                {
             $result = $studentclient->addStudentMini($_GET["sname"],$_GET["fname"],$_GET["gfname"],$_GET["gen"],$_GET["gname"],$_GET["section"],$_GET["fmob"],$_GET["mmob"]); 
                }
            }  
            if(isset($_GET["update"]))
            {       
            $result = $studentclient->updateStudent($_GET["sid"],$_GET["sname"],$_GET["fname"],$_GET["gfname"],$_GET["gen"],$_GET["gname"],$_GET["section"],$_GET["fmob"],$_GET["mmob"]);
            }
            if(isset($_GET["grd"]))
            {       
            $result = $studentclient-> getStudentByGradeName($_GET["grd"]);
            }
            if(isset($_GET["sec"]))
            {       
            $result = $studentclient-> getSections($_GET["sec"]);
            }
            if(isset($_GET["grdsec"]))
            {       
            $result = $studentclient-> getStudentByGradeNameandSection($_GET["grd"],$_GET["sec"]);
            }
            if(isset($_GET["all"]))
            {   
                if($_GET["all"]==1)
                {$result = $studentclient-> getAll($_GET["all"]);}
                else
                {$result = $studentclient-> getAll($_GET["all"]);}
            }
            if(isset($_GET["pay"]))
            {       
            $result = $studentclient-> getAllPayment();
            }
            if(isset($_GET["remove"]))
            {       
            $result = $studentclient->remove($_GET["sid"]);
            }
            if(isset($_GET["gmnum"]))
            {       
            $result = $studentclient->getStudentByParentsMobileNum($_GET["gmnum"]);
            }
            if(isset($_GET["auth"]))
            {       
            $result = $studentclient->getStudentIDByParentsMobileNum($_GET["auth"]);
            }
            if(isset($_GET["payment"]))
            {       
            $result = $studentclient->getAllPayments($_GET["payment"]);
            }
           //array_push($result,$GET["all"]);
        break;
    case "DELETE":
        parse_str(file_get_contents("php://input"), $_DELETE);
        $result = $studentclient->remove($_DELETE["sid"]);
        break;
}

//http://localhost/progress_api/studentreception.php?sname=Dawit&fname=Wubshet&gfname=Abebe&gname=Grade%20%201&section=A

header("Content-Type: application/json");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Origin: *");
echo json_encode($result);

?>
