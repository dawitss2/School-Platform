<?php
include "gradedata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class Grade {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function read($row) {
        $result = new gradedata();
        $result->Name = $row["Name"];
        return $result;
    }
    public function getAll() {               
        $sql = "SELECT Name FROM grade  ORDER BY GradeID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getGradeName($GradeID) {               
        $sql = "SELECT  Name FROM grade Where GradeID =".$GradeID;       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
         $result = $row["Name"];
        }
        return $row["Name"];
       }
   
}

?>