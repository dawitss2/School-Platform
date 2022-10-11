<?php
include "quotedata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class Quote {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function read($row) {
        $result = new quotedata();
        $result->QuoteID = $row["QuoteID"];
        $result->Author = $row["Author"];
        $result->Quote = $row["Quote"];
        return $result;
    }
    public function getAll() {               
        $sql = "SELECT * FROM quotes ";       
        $q = $this->db->prepare($sql);
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