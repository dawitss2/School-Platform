<?php
include "assesmentdata.php";
//include "gradedata.php";
include_once "student.php";
include "assesment_result.php";
include "assesmentassigned.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class assesment {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
     private function readfrontend($row) {
        $result = new assesmentdata();
        $result->AssID = $row["AssID"];
        $result->Name = $row["Name"];
        $result->Value = $row["Value"];
        return $result;
    }
    private function read($row) {
        $result = new assesmentassigned();
        $result->AssessmentID = $row["AssessmentID"];
        $result->AssID = $row["AssID"];
        $result->Name = $row["Name"];       
        $result->Value = $row["Value"];
        $result->SubjectName = $row["Subject"]; 
        $result->Grade = $row["Grade"];
        return $result;
    }
    private function read_result($row) {
        $result = new assesment_result();
        $result->ResultID = $row["ResultID"];
        $result->AssesmentID = $row["AssessmentID"];
        $result->SubjectName = $row["Subject"]; 
        $result->Name = $row["Name"];
        $result->Value = $row["Out Of"];
        $result->Result = $row["Result"];
        return $result;
    }
    private function read_value($row) {
        $result = new gradedata(); 
        $result->Name = $row;
        return $result;
    }

    public function getAssesmentByAssesmentID($AssesmentID) {               
        $sql = "SELECT AssessmentID,assessment.AssID,(SELECT Name FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Name,(SELECT Value FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Value,(SELECT `Name` FROM `subject` WHERE SubjectID = assessment.SubjectID) As 'Subject',(SELECT Name FROM `grade` WHERE GradeID = assessment.GradeID) as 'Grade FROM `assesment` WHERE AssesmentID=:AssesmentID ORDER BY AssesmentID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssesmentID", $AssesmentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
        public function getAll_assignment() {               
        $sql = "SELECT AssessmentID,assessment.AssID,(SELECT Name FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Name,(SELECT Value FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Value,(SELECT `Name` FROM `subject` WHERE SubjectID = assessment.SubjectID) As 'Subject',(SELECT Name FROM `grade` WHERE GradeID = assessment.GradeID) as 'Grade' FROM `assessment` WHERE isactive = 1 ORDER BY AssessmentID ASC ";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
       public function get_assignment($GradeName,$SubjectName) {               
        $sql = "SELECT AssessmentID,assessment.AssID,(SELECT Name FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Name,(SELECT Value FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Value,(SELECT `Name` FROM `subject` WHERE SubjectID = assessment.SubjectID) As 'Subject',(SELECT Name FROM `grade` WHERE GradeID = assessment.GradeID) as 'Grade' FROM `assessment` WHERE GradeID = (SELECT GradeID FROM `grade` WHERE Name = :GradeName) and SubjectID = (SELECT `SubjectID` FROM `subject` WHERE Name = :SubjectName) and isactive = 1 ORDER BY AssessmentID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":GradeName", $GradeName);
        $q->bindParam(":SubjectName", $SubjectName);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
         foreach($rows as $row) {
            array_push($result, $this->read($row));
            }       
        return $result;
       }
    public function getAll() {               
        $sql = "SELECT * FROM `assessmentdetail` WHERE isactive = 1 ORDER BY AssID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readfrontend($row));
        }
        return $result;
       }
     public function addAssessment($Name,$Value) {               
        $sql = "INSERT INTO `assessmentdetail`(`Name`, `Value`) VALUES (:Name,:Value)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Name", $Name);
        $q->bindParam(":Value", $Value);     
        if ($q->execute())
        {
        return "Assessment Added";
        }
        else
        {
            return null;
        }
       }
       public function addAssessmentAssignment($AssID,$GradeName,$SubjectName) {               
        $sql = "INSERT INTO `assessment`(`AssID`, `GradeID`, `SubjectID`) VALUES (:AssID,(SELECT GradeID FROM `grade` WHERE Name = :GradeName),(SELECT SubjectID FROM `subject` WHERE Name =:SubjectName))";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssID", $AssID);
        $q->bindParam(":GradeName", $GradeName);
        $q->bindParam(":SubjectName", $SubjectName);     
        if ($q->execute())
        {
        return "Assessment Added";
        }
        else
        {
            return null;
        }
        }
        public function updateAssessmentAssignment($AssessmentID,$GradeName,$SubjectName) {               
        $sql = "UPDATE `assessment` SET `GradeID`=(SELECT GradeID FROM `grade` WHERE Name = :GradeName),`SubjectID`=(SELECT SubjectID FROM `subject` WHERE Name =:SubjectName) WHERE AssessmentID = :AssessmentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssessmentID", $AssessmentID);
        $q->bindParam(":GradeName", $GradeName);
        $q->bindParam(":SubjectName", $SubjectName);     
        if ($q->execute())
        {
        return "Assessment Assignment Updates";
        }
        else
        {
            return null;
        }
       }
       public function removeAssessmentAssignment($AssessmentID) {               
        $sql = "UPDATE `assessment` SET `isactive`=0 WHERE AssessmentID=:AssessmentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssessmentID", $AssessmentID); 
        if ($q->execute())
        {
        return "Assessment Assignment Removed";
        }
        else
        {
            return null;
        }
       }
        public function updateAssessment($Name,$Value,$AssID) {               
        $sql = "UPDATE `assessmentdetail` SET `Name`=:Name,`Value`=:Value WHERE AssID=:AssID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Name", $Name);
        $q->bindParam(":Value", $Value); 
         $q->bindParam(":AssID", $AssID); 
        if ($q->execute())
        {
        return "Assessment Updated";
        }
        else
        {
            return null;
        }
       }
       public function removeAssessment($AssID) {               
        $sql = "UPDATE `assessmentdetail` SET `isactive`=0 WHERE AssID=:AssID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssID", $AssID); 
        if ($q->execute())
        {
        return "Assessment Removed";
        }
        else
        {
            return null;
        }
       }
    public function getAssesmentByGrade($GrdName) {               
        $sql = "SELECT AssessmentID,assessment.AssID,(SELECT Name FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Name,(SELECT Value FROM `assessmentdetail` WHERE AssID=assessment.AssID) as Value,(SELECT `Name` FROM `subject` WHERE SubjectID = assessment.SubjectID) As 'Subject',(SELECT Name FROM `grade` WHERE GradeID = assessment.GradeID) as 'Grade' FROM `assesment` WHERE GradeID=(SELECT `GradeID` FROM `grade` WHERE Name = :Gname) ORDER BY AssesmentID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Gname", $GrdName);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getAssesmentWithResultByStudentID($StudentID) {               
        $sql = "SELECT result.ResultID,`AssessmentID`,(SELECT `Name` FROM `subject` WHERE SubjectID = assessment.SubjectID) As 'Subject',(SELECT Name FROM `assessmentdetail` WHERE AssID = assessment.AssID) as 'Name', (SELECT Value FROM `assessmentdetail` WHERE AssID = assessment.AssID) as 'Out Of',COALESCE((SELECT `Value` FROM `result` WHERE AssesmentID = assessment.AssessmentID and StudentID = :sid),'-') As 'Result' FROM `assessment`,`result` WHERE assessment.AssessmentID = result.AssesmentID and result.StudentID = :sid and assessment.GradeID = (SELECT GradeID From student where StudentID = :sid) ORDER BY SubjectID ASC";     
        $q = $this->db->prepare($sql);
        $q->bindParam(":sid", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read_result($row));
        }
        return $result;
       }
    public function assignAssessment($GrdName,$AssID,$Subject) {               
        $sql = "INSERT INTO `assesment`(`AssID`, `GradeID`,`SubjectID`) VALUES (:Name,:Value,(SELECT GradeID From grade where Name = :Gname),(SELECT SubjectID From subject where Name = :Sname))";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Name", $Name);
        $q->bindParam(":Value", $Value);
        $q->bindParam(":Gname", $GrdName);
        $q->bindParam(":Sname", $Subject);
        if ($q->execute())
        {
        return $this->getAssesmentByAssesmentID($this->db->lastInsertId());  
        }
        else{
         return null;// code...
         }         
       }
    public function updateAssesment($AssesmentID,$Name,$Value) {               
        $sql = "UPDATE `assesment` SET `Name`= :Name,`Value`= :Value WHERE `AssesmentID`= :AssesmentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Name", $Name);
        $q->bindParam(":Value", $Value);
        $q->bindParam(":AssesmentID", $AssesmentID);
        $q->execute();
        if ($q->execute())
        {
        return $this->getAssesmentByAssesmentID($AssesmentID);  
        }
        else
        {
         return null;// code...
        } 
       }
    public function removeAssesment($AssesmentID) {               
        $sql = "DELETE FROM `assesment` WHERE `AssesmentID`= :AssesmentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssesmentID", $AssesmentID);
        $q->execute();
        if ($q->execute())
        {
        return "Success";  
        }
        else
        {
         return null;// code...
        } 
       }
       public function getAssessmentResultByGradeandSection($AssessmentID,$GradeName,$section)
       {
        $sql = "SELECT Value FROM `result` WHERE AssesmentID = :AssessmentID and StudentID IN (Select StudentID from student Where GradeID =(Select GradeID from grade where Name= :GradeName) and Section = :section)";
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssessmentID", $AssessmentID);
        $q->bindParam(":GradeName", $GradeName);
        $q->bindParam(":section", $section);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read_value($row['Value']));
        }
        return $result;
       }
       public function getAssessmentResultByStudent($AssessmentID,$StudentID)
       {
        $sql = "SELECT Value FROM `result` WHERE AssesmentID = :AssessmentID and StudentID = :StudentID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":AssessmentID", $AssessmentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read_value($row['Value']));
        }
        return $result;
       }
       public function addAssessmentResult($AssessmentID,$GradeName,$section,$value) { 
        $studentclient = new student($this->db);
        $students = $studentclient -> getStudentByGradeNameandSection($GradeName,$section);
        $students = json_encode($students);
        $students = json_decode($students,true);
        $i = 1;
        $sql = "";
        foreach($students as $item)
        {$val = "val".$i;
        $sql .= "INSERT INTO `result`(`AssesmentID`, `StudentID`, `Value`) VALUES (:AssessmentID,".$item['StudentID'].",".$value[$val].");";
        $i = $i+1;  
        }   
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssessmentID", $AssessmentID);     
        if ($q->execute())
        {
        return "Assessment Result Added";
        }
        else
        {
           return null;
        }
        }
        public function updateAssessmentResult($AssessmentID,$GradeName,$section,$value) {               
        $studentclient = new student($this->db);
        $students = $studentclient -> getStudentByGradeNameandSection($GradeName,$section);
        $students = json_encode($students);
        $students = json_decode($students,true);
        $i = 1;
        $sql = "";
        foreach($students as $item)
        {$val = "val".$i;
        $sql .= "UPDATE `result` SET  `Value` = ".$value[$val]." WHERE  `AssesmentID` = :AssessmentID and `StudentID` = ".$item['StudentID'].";";
        $i = $i+1;  
        }  
        //return $sql; 
        $q = $this->db->prepare($sql);
        $q->bindParam(":AssessmentID", $AssessmentID);     
        if ($q->execute())
        {
        return "Assessment Result Updated";
        }
        else
        {
           return null;
        }
       }
       public function addAssessmentResultStudent($AssessmentID,$StudentID,$value)
       {
        $sql = "INSERT INTO `result`(`AssesmentID`, `StudentID`, `Value`) VALUES (:AssessmentID,:StudentID,:value)";
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":AssessmentID", $AssessmentID);
        $q->bindParam(":value", $value);
         if ($q->execute())
        {
        return "Assessment Result Added";
        }
        else
        {
           return null;
        }
       }
        public function updateAssessmentResultStudent($AssessmentID,$StudentID,$value)
       {
        $sql = "UPDATE `result` SET `Value` = :value WHERE `AssesmentID` = :AssessmentID and `StudentID`=:StudentID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":AssessmentID", $AssessmentID);
        $q->bindParam(":value", $value);
         if ($q->execute())
        {
        return "Assessment Result Updated";
        }
        else
        {
           return null;
        }
       }
}

?>