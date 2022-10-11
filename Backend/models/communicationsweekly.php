<?php
include "communicationsweeklytdata.php";
include "weekdata.php";
include_once "communications.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);



class communicationsweekly {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    
    private function readweeks($row) {
        $result = new weekdata();
        $result->WeekID = $row["WeekID"];
        $result->Start_date = $row["Start_date"];
        $result->End_date = $row["End_date"]; 
        $result->Name = $row["Name"];      
        return $result;
    }
    private function read($row) {
        $result = new communicationsweeklytdata();
        $result->CommbookID = $row["CommbookID"];
        $result->CommitemID = $row["CommitemID"];
        $result->StudentID = $row["StudentID"]; 
        $result->commitem = $row["commitem"];
        $result->Value = $row["Value"];
        $result->WeekID = $row["WeekID"]; 
        $result->WeekName =  $row["WeekName"];       
        return $result;
    }
    public function getnewcommunicationWeeks($StudentID) {               
        $sql = "SELECT * FROM weeks WHERE WeekID NOT IN  (SELECT DISTINCT WeekID FROM `communicationbookweekly` where StudentID = :StudentID ORDER BY CommitemID ASC)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readweeks($row));
        }
        return $result;
       }
       public function getweekName($WeekID) {               
        $sql = "SELECT Name FROM weeks WHERE WeekID = :WeekID ORDER BY WeekID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":WeekID", $WeekID);
        $q->execute();
        $rows = $q->fetchAll();
        
        foreach($rows as $row) {
            $result  = $row['Name'];
        }
        return $result;
       }
    public function getaddedcommunicationWeeks($StudentID) {               
        $sql = "SELECT * FROM weeks WHERE WeekID  IN  (SELECT DISTINCT WeekID FROM `communicationbookweekly` where StudentID = :StudentID ORDER BY CommitemID ASC)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readweeks($row));
        }
        return $result;
       }
    public function getcommunicationsweklyByStudentIDandWeek($StudentID,$WeekId) {               
        $sql = "SELECT *,(SELECT communications.Value FROM `communications` WHERE CommitemID=communicationbookweekly.CommitemID) as 'commitem',(SELECT Name FROM weeks WHERE WeekID = :WeekID) as 'WeekName' FROM `communicationbookweekly`where WeekID = :WeekID and StudentID = :StudentID ORDER BY CommitemID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":WeekID", $WeekId);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getcommunicationsweklyByStudentID($StudentID) {               
        $sql = "SELECT *,(SELECT communications.Value FROM `communications` WHERE CommitemID=communicationbookweekly.CommitemID) as 'commitem',(SELECT Name FROM weeks WHERE WeekID = communicationbookweekly.WeekID) as 'WeekName'  FROM `communicationbookweekly`where StudentID = :StudentID ORDER BY WeekID ASC CommitemID";       
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
    public function addcommunicationsweekly($StudentID,$WeekID,$value) {  
        $communicationsclient = new communications($this->db);
        $commitems = $communicationsclient -> getcommunicationsByType('Weekly');
        $commitems = json_encode($commitems);
        $commitems = json_decode($commitems,true);
        $i = 1;
        $sql = "";
        foreach($commitems as $item)
        {
          $val = "val".$i;
          $sql .= "INSERT INTO `communicationbookweekly`( `StudentID`, `CommitemID`,`Value`,`WeekID`) VALUES (:studentid,".$item["CommitemID"].",'".$value[$val]."',:WeekID);";
          $i =$i+1;
        }                   
       $q = $this->db->prepare($sql);
       $q->bindParam(":studentid", $StudentID);    
       $q->bindParam(":WeekID", $WeekID);
         if ($q->execute())
         {
         return "Weekly Communication Added";  
         }
        else{
         return $sql;// code...
         }  
       }
    public function updatecommunicationsweekly($StudentID,$WeekID,$value) { 
        $communicationsclient = new communications($this->db);
        $commitems = $communicationsclient -> getcommunicationsByType('Weekly');
        $commitems = json_encode($commitems);
        $commitems = json_decode($commitems,true);
        $i = 1;
        $sql = "";
        foreach($commitems as $item)
        {
          $val = "val".$i;
          $sql .= "UPDATE `communicationbookweekly` SET `Value`='".$value[$val]."' WHERE StudentID = :StudentID and WeekID = :WeekID and CommitemID = ".$item["CommitemID"].";";
          $i =$i+1;
        }  
        //return $sql;                 
       $q = $this->db->prepare($sql);
       $q->bindParam(":StudentID", $StudentID);    
       $q->bindParam(":WeekID", $WeekID);
        if ($q->execute())
           {
           return "Weekly Communication Updated";  
           }
        else{
           return $sql;// code...
           }                     
       }
     public function remove($StudentID,$WeekID) {  
        $sql = "DELETE FROM `communicationbookweekly` WHERE StudentID = :StudentID and WeekID = :WeekID";
       $q = $this->db->prepare($sql);
       $q->bindParam(":StudentID", $StudentID);    
       $q->bindParam(":WeekID", $WeekID);
         if ($q->execute())
         {
         return "Weekly Communication Removed";  
         }
        else{
         return $sql;// code...
         }              
       }
}