<?php
include 'noticedata.php';
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class notice {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
  
    private function read($row,$type) {

        $result = new noticedata();
      
        $result->NotificationID = $row["NotificationID"];
        $result->Title = $row["Title"];
        $result->Value = $row["Value"];
        $result->Type = $row["Type"];
        if ($type != 0)
        {
          $result->AssignedTo = $this->getAssignedStudentNotice($row["NotificationID"]);  
        }
        else
        {
            $result->AssignedTo = $this->getAssignedGradeNotice($row["NotificationID"]);
        }
        return $result;
    }
        private function read_app($row){
        $result = new noticedata();
        $result->NotificationID = $row["NotificationID"];
        $result->Title = $row["Title"];
        $result->Value = $row["Value"];
        $result->Type = $row["Type"];
        $result->AssignedTo = $row["Stamp"];
        return $result;}
    public function getAll($type) {               
        $sql = "SELECT * FROM `notification` WHERE isactive=1  ORDER BY NotificationID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row,$type));
        }
        return $result;
       }
    public function getAssignedStudentNotice($NotificationID) {               
        $sql = "SELECT CONCAT(student.StudentID,' ',student.Name,' ',student.FName) as Name FROM `student`,`noticestudentassignment` WHERE student.StudentID = noticestudentassignment.StudentID and noticestudentassignment.NotificationID =:NotificationID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":NotificationID", $NotificationID);
        if ($q->execute())
        {
            $rows = $q->fetchAll();
            $result = '';
            foreach($rows as $row) {
            $result .= $row['Name']. "," ;
            }
            return $result;
        }
        else
        {
            return null;
        }
       }
    public function getNoticeByStudent($StudentID) {               
        $sql = "SELECT * FROM `notification` WHERE isactive=1 and (NotificationID IN (SELECT  NotificationID FROM `student`,`noticestudentassignment` WHERE student.StudentID = noticestudentassignment.StudentID and noticestudentassignment.StudentID =:StudentID) or NotificationID IN (SELECT NotificationID FROM `grade`,`noticegradeassignment` WHERE grade.GradeID = noticegradeassignment.GradeID and noticegradeassignment.GradeID =(SELECT GradeID from student WHERE StudentID =:StudentID))) ORDER BY Stamp ASC ";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        if ($q->execute())
        {
            $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read_app($row));
        }
        return $result;
        }
        else
        {
            return null;
        }
       }
    public function getAssignedGradeNotice($NotificationID) {               
          $sql = "SELECT grade.Name as Name FROM `grade`,`noticegradeassignment` WHERE grade.GradeID = noticegradeassignment.GradeID and noticegradeassignment.NotificationID =:NotificationID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":NotificationID", $NotificationID);
        if ($q->execute())
        {
            $rows = $q->fetchAll();
            $result = '';
            foreach($rows as $row) {
            $result .= $row['Name']. "," ;
            }
            return $result;
        }
        else
        {
            return null;
        }
       }
    public function addNotice($Title,$Value,$Type) {               
        $sql = "INSERT INTO `notification`( `Title`, `Value`, `Type`) VALUES (:Title,:Value,:Type)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Title", $Title);
        $q->bindParam(":Value",$Value);
        $q->bindParam(":Type",$Type);
        if ($q->execute())
        {
        return "Notification Added";
        }
        else
        {
            return null;
        }
       }
       public function addNoticewithAssignGrade($Title,$Value,$Type,$GradeName) {               
        $sql = "INSERT INTO `notification`( `Title`, `Value`, `Type`) VALUES (:Title,:Value,:Type)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Title", $Title);
        $q->bindParam(":Value",$Value);
        $q->bindParam(":Type",$Type);
        if ($q->execute())
        {
        return $this->assignNoticeGrade($this->db->lastInsertId(),$GradeName);
        }
        else
        {
            return null;
        }
       }
       public function addNoticewithAssignStudent($Title,$Value,$Type,$StudentID) {               
        $sql = "INSERT INTO `notification`( `Title`, `Value`, `Type`) VALUES (:Title,:Value,:Type)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Title", $Title);
        $q->bindParam(":Value",$Value);
        $q->bindParam(":Type",$Type);
        if ($q->execute())
        {
        return $this->assignNoticeStudent($this->db->lastInsertId(),$StudentID);
        }
        else
        {
            return null;
        }
       }
    public function updateNotice($Title,$Value,$Type,$NotificationID) {               
        $sql = "UPDATE `notification` SET `Title`=:Title,`Value`=:Value,`Type`=:Type WHERE NotificationID = :NotificationID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Title", $Title);
        $q->bindParam(":Value",$Value);
        $q->bindParam(":Type",$Type);
        $q->bindParam(":NotificationID",$NotificationID);
        if ($q->execute())
        {
        return "Notification Updated";
        }
        else
        {
            return null;
        }
   }
    public function assignNoticeGrade($NotificationID,$GradeName) {               
        $sql = "INSERT INTO `noticegradeassignment`(`NotificationID`,`GradeID`) VALUES (:NotificationID,(Select GradeID from grade where Name = :GradeName))";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":GradeName",$GradeName);
        $q->bindParam(":NotificationID",$NotificationID);
        if ($q->execute())
        {
        return "Notification Added";
        }
        else
        {
            return null;
        }
       }
    public function assignNoticeStudent($NotificationID,$StudentID) {               
       $sql = "INSERT INTO `noticestudentassignment`(`NotificationID`,`StudentID`) VALUES (:NotificationID,:StudentID)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":NotificationID",$NotificationID);
        $q->bindParam(":StudentID",$StudentID);
        if ($q->execute())
        {
        return "Notification Added";
        }
        else
        {
            return null;
        }
       }
  
   
   public function remove($NotificationID) {
        $sql = "UPDATE notification SET isactive = 0 WHERE NotificationID = :NotificationID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":NotificationID", $NotificationID);
        if($q->execute())
        {return 'Notification Removed';}
        else
        { 
            return null;
        }
     }
    public function removeNoticeAssignedGrade($NotificationID,$GradeName) {
         $sql = "DELETE FROM `noticegradeassignment` WHERE NotificationID = :NotificationID and GradeID=(Select GradeID from grade where Name = :GradeName)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":GradeName",$GradeName);
        $q->bindParam(":NotificationID",$NotificationID);
        if ($q->execute())
        {
        return "Notification Updated";
        }
        else
        {
            return null;
        }
    }
    public function removeNoticeAssignedStudent($NotificationID,$StudentID) {
        $sql = "DELETE FROM `noticestudentassignment` WHERE NotificationID=:NotificationID and StudentID =:StudentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":NotificationID",$NotificationID);
        $q->bindParam(":StudentID",$StudentID);
        if ($q->execute())
        {
        return "Notification Updated";
        }
        else
        {
            return null;
        }
    }
           // Get Subjects by Grade
}

?>