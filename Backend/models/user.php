<?php
include 'userdata.php';
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class user {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function read($row) {

        $result = new userdata();
        $result->UserID = $row["UserID"];
        $result->Name = $row["fname"]." ".$row["lname"];
        $result->userName = $row["userName"];
        if ($row["authority"] != 0)
        {
          $result->authority = "Administrator";  
        }
        else
        {
            $result->authority = "Teacher";
        }
        return $result;
    }
    public function getAll() {               
        $sql = "SELECT * FROM account WHERE stat = 1  ORDER BY UserID ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function addUser($fname,$lname,$authority) {               
        $sql = "INSERT INTO `account`( `fname`, `lname`, `authority`,`pass`) VALUES (:fname,:lname,:authority,'password')";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":fname", $fname);
        $q->bindParam(":lname",$lname);
        $q->bindParam(":authority",$authority);
        if ($q->execute())
        {
        return $this->updateUsername($fname,$this->db->lastInsertId());
        }
        else
        {
            return null;
        }
       }
    public function updateUsername($fname,$UserID) {               
         $sql = "UPDATE `account` SET `userName`=:username WHERE UserID =:UserID";       
         $q = $this->db->prepare($sql);
         $un = $fname.$UserID;
         $q->bindParam(":username", $un );
         $q->bindParam(":UserID", $UserID );
        if ($q->execute())
        {
        return "User Added";
        }
        else
        {
            return null;
        }
       }
    public function updateUser($fname,$lname,$authority,$UserID) {               
       $sql = "UPDATE `account` SET `fname`=:fname,`lname`=:lname,`pass`='password',`authority`=:authority WHERE UserID =:UserID";
               
        $q = $this->db->prepare($sql);
         $q->bindParam(":fname", $fname);
        $q->bindParam(":lname",$lname);
        $q->bindParam(":authority",$authority);
        $q->bindParam(":UserID", $UserID );
        if ($q->execute())
        {
        return "Updated";
        }
        else
        {
            return null;
        }
       }
   public function remove($UserID) {
        $sql = "UPDATE account SET stat = 0 WHERE UserID = :UserID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":UserID", $UserID);
        if($q->execute())
        {return 'User Removed';}
        else
        { 
            return null;
        }
    }
           // Get Subjects by Grade
}

?>