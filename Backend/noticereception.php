<?php
session_start(); 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
include "models/notice.php";

$config = include("db/config.php");
$db = new PDO($config["db"], $config["username"], $config["password"]);
//$db->exec("setname utf8");
$noticeclient = new notice($db);
$result = array();

switch($_SERVER["REQUEST_METHOD"]) {
    case "GET":           
         if(isset($_GET["add"]))
            {
                        if($_GET["add"]==1)
                    {$result = $noticeclient->addNotice($_GET["title"],$_GET["value"],$_GET["type"]);}
                        else
                        {
                            if(isset($_GET["grade"]))
                     {$result = $noticeclient->addNoticewithAssignGrade($_GET["title"],$_GET["value"],$_GET["type"],$_GET["grade"]);} 
                            else
                    {$result = $noticeclient->addNoticewithAssignStudent($_GET["title"],$_GET["value"],$_GET["type"],$_GET["sid"]);}
                        }
           } 
            if(isset($_GET["update"]))
             {       
               $result = $noticeclient->updateNotice($_GET['title'],$_GET['value'],$_GET['type'],$_GET['nid']);
             }
              if(isset($_GET["assign"]))
             {        
                        if(isset($_GET["grade"]))
                          {$result = $noticeclient->assignNoticeGrade($_GET["nid"],$_GET["grade"]);}
                         else
                          {$result = $noticeclient->assignNoticeStudent($_GET["nid"],$_GET["sid"]);}
             }
            if(isset($_GET["all"]))
            {       
            $result = $noticeclient-> getAll($_GET["all"]);
            }
             if(isset($_GET["student"]))
            {       
            $result = $noticeclient-> getNoticeByStudent($_GET["student"]);
            }
            if(isset($_GET["remove"]))
            {  
                if($_GET["remove"]==1)
                    {$result = $noticeclient->remove($_GET["nid"]);}
                 else
                    {
                        if(isset($_GET["grade"]))
                          {$result = $noticeclient->removeNoticeAssignedGrade($_GET["nid"],$_GET["grade"]);}
                         else
                          {$result = $noticeclient->removeNoticeAssignedStudent($_GET["nid"],$_GET["sid"]);}
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