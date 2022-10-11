<?php
include 'subjectdata.php';
include "gradedata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class subject {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function readsubject($row) {
        $result = new gradedata();
        $result->Name = $row["Name"];
        return $result;
    }
    private function read($row) {
        $result = new subjectdata();
        $result->SubjectID = $row["SubjectID"];
        $result->Name = $row["Name"];
        $assigned = $this->getAssigned($row["SubjectID"]);
        if ($assigned != null)
        {
          $result->AssignedGrade = $this->getAssigned($row["SubjectID"]);  
        }
        else
        {
            $result->AssignedGrade = "";
        }
        return $result;
    }
    public function getAll() {               
        $sql = "SELECT * FROM subject WHERE isactive = 1  ORDER BY SubjectID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function addSubject($Name) {               
        $sql = "INSERT INTO `subject`(`Name`) VALUES ('".$Name."')";       
        $q = $this->db->prepare($sql);
        if ($q->execute())
        {
        return $this->db->lastInsertId();
        }
        else
        {
            return null;
        }
       }
    public function updateSubject($Name, $SubjectID ) {               
         $sql = "UPDATE `subject` SET `Name`=:Name WHERE SubjectID =:SubjectID";       
         $q = $this->db->prepare($sql);
         $q->bindParam(":Name", $Name);
         $q->bindParam(":SubjectID",$SubjectID);
        if ($q->execute())
        {
        return "Updated";
        }
        else
        {
            return null;
        }
       }
    public function assignSubject($Name,$grade,$type,$SubjID) {
        if($type == 0)
        {   
            $SubjectID = $this->addSubject($Name);
            if ($SubjectID != null)
            {
                return $this->assign($grade,$SubjectID);
            }
            else
            {
                return null;
            }
        }
         else {
             return $this->assign($grade,$SubjID); 
         }  
        } 
     public function assign($Name,$SubjID)
        {
              $sql = "INSERT INTO `assignedsubject`( `GradeID`, `SubjectID`) VALUES ((SELECT `GradeID` FROM `grade` WHERE Name = :Gname),:subject)";       
                $q = $this->db->prepare($sql);
                $q->bindParam(":Gname", $Name);
                $q->bindParam(":subject",$SubjID);
                if ($q->execute())
                {
                return "Subject ".$SubjID." Assigned to ".$Name;
                }
                else
                {
                    return null;
                }
        }
    public function getAssigned($SubjID)
        {
              $sql = "Select Name from grade,assignedsubject where grade.GradeID = assignedsubject.GradeID and assignedsubject.SubjectID = :subject";       
                $q = $this->db->prepare($sql);
                $q->bindParam(":subject",$SubjID);
                if ($q->execute())
                {
                    $result = "";
                    $rows = $q->fetchAll();
                    foreach($rows as $row) {
                     $result .= $row['Name'] . ",";
                    }
                    return $result;
                }
                else
                {
                    return null;
                }
        }
    public function getAssignedByGrade($GradeName)
        {
              $sql = "Select subject.Name from subject,assignedsubject where subject.SubjectID = assignedsubject.SubjectID and assignedsubject.GradeID = (Select GradeID from grade where Name = :GradeName) and subject.isactive = 1";       
                $q = $this->db->prepare($sql);
                $q->bindParam(":GradeName",$GradeName);
                if ($q->execute())
                {
                    $result = array();
                    $rows = $q->fetchAll();
                    foreach($rows as $row) {
                     array_push($result, $this->readsubject($row));
                    }
                    return $result;
                }
                else
                {
                    return null;
                }
        }

   public function remove($SubjectID) {
        $sql = "UPDATE subject SET isactive = 0 WHERE SubjectID = :SubjectID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":SubjectID", $SubjectID);
        if($q->execute())
        {return 'Subject Removed';}
        else
        { 
            return null;
        }
    }
    public function removeGradeAssignment($SubjectID,$GradeName) {
        $sql = "DELETE FROM `assignedsubject` WHERE GradeID=(SELECT `GradeID` FROM `grade` WHERE Name = :GradeName) and SubjectID =:SubjectID ";
        $q = $this->db->prepare($sql);
        $q->bindParam(":SubjectID", $SubjectID);
        $q->bindParam(":GradeName", $GradeName);
        if($q->execute())
        {return 'Grade Assignment Removed';}
        else
        { 
            return null;
        }
    }
       // Get Subjects by Grade
}

?>