<?php
include "communicationsmonthlytdata.php";
include "communications.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class communicationsmonthly {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    private function read($row) {
        $result = new communicationsmonthlytdata();
        $result->CommbookID = $row["CommbookID"];
        $result->CommitemID = $row["CommitemID"]; 
        $result->StudentID = $row["StudentID"];
        $result->Value = $row["Value"];
        $result->Month = $row["Month"];
        $result->commitem = $row["commitem"];
         $result->MonthName = $row["MonthName"];
        return $result;
    }
    public function getcommunicationsmonthlyByStudentIDandMonth($StudentID,$Month) {               
        $sql = "SELECT *,(SELECT communications.Value FROM `communications` WHERE CommitemID=communicationbookmonthly.CommitemID) as 'commitem',(SELECT `EtCalMonthsName` FROM `etcalmonths` WHERE `EtCalMonthsID` = :Month) as 'MonthName'  FROM `communicationbookmonthly` where Month = :Month and StudentID = :StudentID ORDER BY CommitemID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":Month", $Month);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getcommunicationsmonthlyByStudentID($StudentID) {               
        $sql = "SELECT *,(SELECT communications.Value FROM `communications` WHERE CommitemID=communicationbookmonthly.CommitemID) as 'commitem',(SELECT `EtCalMonthsName` FROM `etcalmonths` WHERE `EtCalMonthsID` =communicationbookmonthly.Month) as 'MonthName'  FROM `communicationbookmonthly` where StudentID = :StudentID ORDER BY Month ASC CommitemID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function addcommunicationsmonthly($StudentID,$Month,$value) {  
        $communicationsclient = new communications($this->db);
        $commitems = $communicationsclient -> getcommunicationsByType('monthly');
        $commitems = json_encode($commitems);
        $commitems = json_decode($commitems,true);
        $i = 1;
        $sql = "";
        foreach($commitems as $item)
        {
          $val = "val".$i;
          $sql .= "INSERT INTO `communicationbookmonthly`( `StudentID`, `CommitemID`,`Value`,`Month`) VALUES (:studentid,".$item["CommitemID"].",'".$value[$val]."',:Month);";
          $i =$i+1;
        }                   
       $q = $this->db->prepare($sql);
       $q->bindParam(":studentid", $StudentID);    
       $q->bindParam(":Month", $Month);
         if ($q->execute())
         {
         return "Monthly Communication Added";  
         }
        else{
         return $sql;// code...
         }  
       }
    public function updatecommunicationsmonthly($StudentID,$Month,$value) { 
        $communicationsclient = new communications($this->db);
        $commitems = $communicationsclient -> getcommunicationsByType('monthly');
        $commitems = json_encode($commitems);
        $commitems = json_decode($commitems,true);
        $i = 1;
        $sql = "";
        foreach($commitems as $item)
        {
          $val = "val".$i;
          $sql .= "UPDATE `communicationbookmonthly` SET `Value`='".$value[$val]."' WHERE StudentID = :StudentID and Month = :Month and CommitemID = ".$item["CommitemID"].";";
          $i =$i+1;
        }  
        //return $sql;                 
       $q = $this->db->prepare($sql);
       $q->bindParam(":StudentID", $StudentID);    
       $q->bindParam(":Month", $Month);
        if ($q->execute())
           {
           return "Monthly Communication Updated";  
           }
        else{
           return $sql;// code...
           }                     
       }
     public function remove($StudentID,$Month) {  
        $sql = "DELETE FROM `communicationbookmonthly` WHERE StudentID = :StudentID and Month = :Month";
       $q = $this->db->prepare($sql);
       $q->bindParam(":StudentID", $StudentID);    
       $q->bindParam(":Month", $Month);
         if ($q->execute())
         {
         return "Monthly Communication Removed";  
         }
        else{
         return "Not Removed";
         }              
       }

}

?>