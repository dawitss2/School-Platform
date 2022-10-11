<?php
include_once "models/attachmentdata.php";
include_once "models/pspdata.php";
class trans {

    protected $db;
    protected $db2;
    protected $db3;
    protected $db4;
    public $AttID = 0;
public function __construct(PDO $db,PDO $db2,PDO $db3,PDO $db4)
    {
        $this->db = $db;
        $this->db2 = $db2;
        $this->db3 = $db3;
        $this->db4 = $db4;
    }
    
public function read($row) {
        $result = new attachmentdata();
        $this->AttID = $this->AttID + 1;
        $result->AttachmentID = $this->AttID;
        $result->StudentID = $this->getNewID($row["sName"]);
        $result->Bank = $row["Bank"];       
        $result->PaymentID = $row["PaymentID"];
        $result->EduCalYearID = $row["EduCalYearID"]; 
        $result->EtCalMonthsID = $row["EtCalMonthsID"];
        $result->issuedon = $row["issuedon"];
        $result->issuedby = $row["issuedby"]; 
        $result->stamp = $row["stamp"];
        return $result;
    }
    public function readpsp($row) {
        $result = new pspdata();
        $this->AttID = $this->AttID + 1;
        $result->PerStudentPayID = $this->AttID;
        $result->StudentID = $this->getNewID($row["sName"]);       
        $result->PaymentID = $row["PaymentID"];
        $result->Amount = $row["Amount"];
        $result->isactive = $row["isactive"]; 
        $result->paystart = $row["paystart"];
        return $result;
    }

public function getAttachment() {               
        //$sql = "SELECT *,(SELECT CONCAT(Name,FName,GFName) FROM `student` WHERE StudentID = perstudentpay.StudentID) AS sName FROM `perstudentpay` WHERE 1 "; 
        $sql = "SELECT *,(SELECT CONCAT(Name,FName,GFName) FROM `student` WHERE StudentID = attachment.StudentID) AS sName FROM `attachment` WHERE 1 "; 

        $q1 = $this->db2->prepare($sql);
        $q2 = $this->db3->prepare($sql);
        $q3 = $this->db4->prepare($sql);
        $q1->execute();
        $q2->execute();
        $q3->execute();
        $rows1 = $q1->fetchAll();
        $rows2 = $q2->fetchAll();
        $rows3 = $q3->fetchAll();
        $result = array();
        foreach($rows1 as $row) {
            array_push($result, $this->read($row));
        }
        foreach($rows2 as $row) {
            array_push($result, $this->read($row));
        }
        foreach($rows3 as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }


public function getNewID($Student) {               
        $sql = "SELECT StudentID FROM `student` WHERE CONCAT(Name,FName,GFName) = :Student";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Student", $Student);
        $q->execute();
        $rows = $q->fetchAll();
        $result = "";
        foreach($rows as $row) {
            $result = $row["StudentID"];
        }
        return $result;
       }
}
?>