<?php
include "monthdata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class etcalmonth {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function read($row) {
        $result = new monthdata();
        $result->MonthID = $row["EtCalMonthsID"];
        $result->Name = $row["EtCalMonthsName"];
        return $result;
    }
    public function getAll($type,$StudentID) { 
        $sql=''; 
        if($type == 1)             
        {$sql = "SELECT * FROM etcalmonths WHERE EtCalMonthsID NOT IN (SELECT DISTINCT Month FROM communicationbookmonthly WHERE StudentID=:StudentID ORDER BY Month ASC)";}
        else 
        {$sql = "SELECT * FROM etcalmonths WHERE EtCalMonthsID IN (SELECT DISTINCT Month FROM communicationbookmonthly WHERE StudentID=:StudentID ORDER BY Month ASC)";}       
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
}

?>