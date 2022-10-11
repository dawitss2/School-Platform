<?php
include "addressdata.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class address {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }

    private function read($row) {
        $result = new addressdata();
        $result->AddID = $row["AddID"];
	    //$result->StudentID = $row["StudentID"];
	    $result->FathersMobile = $row["FathersMobile"];
        $result->MothersMobile = $row["MothersMobile"];
        $result->Address = $row["Address"];
        $result->KifleKetema = $row["KifleKetema"];
        $result->Woreda =  $row["Woreda"];
  	    $result->HouseNum = $row["HouseNum"];
        return $result;
    }
    public function getAddressByStudentID($StudentID) {               
        $sql = "SELECT * from `address` WHERE StudentID = ". $StudentID ;       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
     public function getaddr($StudentID) {               
        $sql = "SELECT FathersMobile,MothersMobile  from `address` WHERE StudentID = ". $StudentID ;       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = '';
        foreach($rows as $row) {
        $result['FathersMobile'] = $row['FathersMobile'];
        $result['MothersMobile'] = $row['MothersMobile'];
        }
        echo $result;
        return json_encode($result);
       }
    public function addStudentAddress($StudentID,$fmob,$mmob,$add,$kk,$wor,$hno) {               
        $sql = "INSERT INTO `address`(`StudentID`, `FathersMobile`, `MothersMobile`, `Address`, `KifleKetema`, `Woreda`, `HouseNum`) VALUES (:StudentID,:fmob,:mmob,:add,:kk,:wor,:hno)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":fmob", $fmob);
        $q->bindParam(":mmob", $mmob);
        $q->bindParam(":add", $add);
        $q->bindParam(":kk", $kk);
        $q->bindParam(":wor", $wor);
        $q->bindParam(":hno", $hno);
        $q->execute();    
        //return $this->getAddressByStudentID($StudentID);
       }
public function addStudentAddressMini($StudentID,$fmob,$mmob) {               
         $sql = "INSERT INTO `address`(`StudentID`, `FathersMobile`, `MothersMobile`, `Address`, `KifleKetema`, `Woreda`, `HouseNum`) VALUES (:StudentID,:fmob,:mmob,'','','','')";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":fmob", $fmob);
        $q->bindParam(":mmob", $mmob);
        $q->execute();  
        //return $this->getAddressByStudentID($StudentID);
       }
    public function updateStudentAddress($StudentID,$fmob,$mmob) {               
        $sql = "UPDATE `address` SET `FathersMobile`= :fmob, `MothersMobile` = :mmob where StudentID = :StudentID";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->bindParam(":fmob", $fmob);
        $q->bindParam(":mmob", $mmob);
        $q->execute();    
        //return $this->getAddressByStudentID($StudentID);
       }

}

?>