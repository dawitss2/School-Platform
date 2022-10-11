<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class Feedback {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    public function getmonthlyFeedBack($StudentID,$MonthID) {               
        $sql = "SELECT Value FROM monthlyfeedback Where StudentID = :StudentID and MonthID = :MonthID ORDER BY feedbackID ASC";       
        $q = $this->db->prepare($sql);
         $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":MonthID", $MonthID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = '';
        foreach($rows as $row) {
            $result = $result." ".$row['Value'];;
        }
        return $result;
       }
    public function getweeklyFeedBack($StudentID,$WeekID) {               
        $sql = "SELECT Value FROM weeklyfeedback Where StudentID = :StudentID and WeekID = :WeekID ORDER BY feedbackID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":WeekID", $WeekID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = '';
        foreach($rows as $row) {
            $result = $result." ".$row['Value'];
        }
        return $result;
       }
    public function addMonthlyFeedback($StudentID,$MonthID,$Value) {               
        $sql = "INSERT INTO `monthlyfeedback`(`StudentID`, `MonthID`, `Value`) VALUES (:StudentID,(SELECT EtCalMonthsID FROM `etcalmonths` WHERE EtCalMonthsName = :MonthID),:Value)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":MonthID", $MonthID);
        $q->bindParam(":Value", $Value);
        if($q->execute())
        {
            return "done";
        }
        else
        {
            return "failed";
        }
    }
    public function addweeklyFeedback($StudentID,$WeekID,$Value) {               
        $sql = "INSERT INTO `weeklyfeedback`(`StudentID`, `WeekID`, `Value`) VALUES (:StudentID,(SELECT WeekID FROM `weeks` WHERE Name =:WeekID),:Value)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":WeekID", $WeekID);
        $q->bindParam(":Value", $Value);
        if($q->execute())
        {
            return 1;
        }
        else
        {
            return 0;
        }
            }
}

?>