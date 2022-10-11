<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class educalyear {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    public function getAll() {               
        $sql = "SELECT EduCalYear FROM educalyear ORDER BY EduCalYearID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $row["EduCalYear"]);
        }
        return $result;
       }
    public function getCurrent() {               
        $sql = "SELECT EduCalYear FROM educalyear Where iscurrent = 1";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $row["EduCalYear"]);
        }
        return $result;
       }
}

?>