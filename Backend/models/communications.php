<?php
include "communicationstdata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class communications {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function read($row) {
        $result = new communicationstdata();
        $result->CommitemID = $row["CommitemID"];
        $result->Type = $row["Type"]; 
        $result->Value = $row["Value"];
        $result->Catagory = $row["Catagory"];
        return $result;
    }

    public function getAll() {               
        $sql = "SELECT * FROM communications WHERE`isactive`=1  ORDER BY CommitemID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function addCommunicationItem($Type,$value,$catagory) {               
        $sql = "INSERT INTO `communications`(`Type`, `Value`, `Catagory`) VALUES (:Type,:value,:catagory)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Type", $Type);
        $q->bindParam(":value", $value);
        $q->bindParam(":catagory", $catagory);     
        if ($q->execute())
        {
        return "Communication Item Added";
        }
        else
        {
            return null;
        }
        }
    public function updateCommunicationItem($Type,$value,$catagory,$CommitemID) {               
        $sql = "UPDATE `communications` SET `Type`=:Type,`Value`=:value,`Catagory`=:catagory WHERE  CommitemID = :CommitemID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Type", $Type);
        $q->bindParam(":value", $value);
        $q->bindParam(":catagory", $catagory); 
        $q->bindParam(":CommitemID", $CommitemID);     
        if ($q->execute())
        {
        return "Assessment Assignment Updates";
        }
        else
        {
            return null;
        }
       }
    public function removeCommunicationItem($CommitemID) {               
        $sql = "UPDATE `communications` SET `isactive`=0 WHERE CommitemID=:CommitemID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":CommitemID", $CommitemID); 
        if ($q->execute())
        {
        return "Assessment Assignment Removed";
        }
        else
        {
            return null;
        }
       }
    public function getcommunicationsByType($type) {               
        $sql = "SELECT * FROM communications  Where Type = :type ORDER BY CommitemID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":type", $type);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getcommunicationsByCatagory($catagory) {               
        $sql = "SELECT * FROM communications  Where Catagory = :catagory ORDER BY CommitemID ASC";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":catagory", $catagory);
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