<?php
include "studentdata.php";
include "studentpaymentdata.php";
include "studentdata_all.php";
include_once "notice.php";
include_once "assesment.php";
include_once "paydata.php";
include "communicationsmonthly.php";
include "communicationsweekly.php";
include "address.php";
include "grade.php";
include "studentdatafrontend.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class student {

    protected $db;

    public function __construct(PDO $db)
    {
        $this->db = $db;
    }
    private function readsection($row) {
        $result = new gradedata();
        $result->Name = $row["Section"];
        return $result;
    }
     private function readpay($row) {
        $result = new paydata();
        $result->AcYear = $row["Acadamic Year"];
        $result->Month = $row["PaiedMonth"];
        $result->Bank = $row["Bank"];
        $result->Amount = $row["Amount"];
        $result->Payment = $row["Payment"];
        $result->Stamp = $row["stamp"];
        return $result;
    }
    private function read($row) {
        $result = new studentdata();
        $grade = new grade($this->db);
        $address = new address($this->db);
        $result->StudentID = $row["StudentID"];
        $result->img = "assets/images/user/user9.jpg";
	    $result->Name = $row["Name"]." ".$row["FName"]." ".$row["GFName"];
        $result->Gender = $row["Gender"];
        $result->GradeName = $grade->getGradeName($row["GradeID"]);
        $result->Section = $row["Section"];
        $result->isactive =  $row["isactive"];
        $result->paystart = $row["paystart"];
  	    $result->discount = $row["discount"];
        $result->address = $address->getAddressByStudentID($row["StudentID"]);
        return $result;
    }
     private function read_id($row) {
        $result = sprintf('%04u', $row[0]);
        return $result ;
    }
    private function read_all($row) {
        $result = new studentdata_all();
        $grade = new grade($this->db);
        $address = new address($this->db);
        $notice = new notice($this->db);
        $assesment = new assesment($this->db);
        $communicationsmonthly = new communicationsmonthly($this->db);
        $communicationsweekly = new communicationsweekly($this->db);
        $result->StudentID = $row["StudentID"];
        $result->img = 'http://192.168.1.202/progress_api/upload/'.$row["StudentID"].'.png';
        $result->Name = $row["Name"]." ".$row["FName"]." ".$row["GFName"];
        $result->Gender = $row["Gender"];
        $result->GradeName = $grade->getGradeName($row["GradeID"]);
        $result->Section = $row["Section"];
        $result->address = $address->getAddressByStudentID($row["StudentID"]);
        $result->result = $assesment->getAssesmentWithResultByStudentID($row["StudentID"]);
        $result->notice = $notice->getNoticeByStudent($row["StudentID"]);
        $result->commbookweekly = $communicationsweekly->getcommunicationsweklyByStudentID($row["StudentID"]);
        $result->combookmonthly = $communicationsmonthly->getcommunicationsmonthlyByStudentID($row["StudentID"]);
        $result->payment = $this->getAllPayments($row["StudentID"]);
        return $result;
    }

    private function readPayment($row) {
        $result = new studentpaymentdata();
        $grade = new grade($this->db);
        $address = new address($this->db);
        $result->StudentID = $row["StudentID"];
         if ($this->studentImageExistes($row["StudentID"]))
        {
            $result->img = 'http://localhost/progress_api/upload/'.$row["StudentID"].'.png';
        }
        else{$result->img = "assets/images/user/user9.jpg";}
        $result->Name = $row["Name"]." ".$row["FName"]." ".$row["GFName"];
        $result->Gender = $row["Gender"];
        $result->GradeName = $grade->getGradeName($row["GradeID"]);
        $result->Section = $row["Section"];
        $result->SchoolFee =  $this->getSchoolFee($row["StudentID"]);
        $result->BusFee = $this->getBusFee($row["StudentID"]);
        return $result;
    }
    private function studentImageExistes($StudentID){
        if (file_exists('upload/'.$StudentID.'.png')) {
             return true;
            }
            else
            {
                return false;
            }
    }
    private function readfrontend($row) {
        $result = new studentdatafrontend();
        $grade = new grade($this->db);
        $addressinstance = new address($this->db);
        $address = array();
        $address = $addressinstance->getAddressByStudentID($row["StudentID"]);
        $result->StudentID = $row["StudentID"];
        if ($this->studentImageExistes($row["StudentID"]))
        {
            $result->img = 'http://localhost/progress_api/upload/'.$row["StudentID"].'.png';
        }
        else{$result->img = "assets/images/user/user9.jpg";}
        $result->Name = $row["Name"]." ".$row["FName"]." ".$row["GFName"];
        if($row["Gender"]!='')
        {$result->Gender = $row["Gender"];}
        else{$result->Gender = '-';}
        $result->GradeName = $grade->getGradeName($row["GradeID"]);
        $result->Section= $row["Section"];
        if(!empty($address))
        {$result->gmn1 = $address[0]->FathersMobile;}
        else{$result->gmn1 = '-';}
        if(!empty($address))
        {$result->gmn2 =  $address[0]->MothersMobile;}
        else{$result->gmn2= '-';}
        return $result;
    }

    public function getSchoolFee($StudentID)
    {
       $sql = "SELECT (SELECT EtCalMonthsName FROM etcalmonths WHERE EtCalMonthsID = attachment.EtCalMonthsID) As PaiedMonth FROM student,attachment WHERE student.StudentID = attachment.StudentID and attachment.PaymentID = 1 and student.StudentID = :StudentID ";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = '';
        foreach($rows as $row) {
            $result .= $row['PaiedMonth'].", ";
        }
        return $result; 
    }
    /*(CASE (SELECT payment.PaymentName FROM payment WHERE payment.PaymentID = attachment.PaymentID) WHEN 'School Fee' THEN (SELECT pergradepay.Amount FROM student,pergradepay WHERE student.GradeID = pergradepay.GradeID and student.StudentID = @stuid) WHEN 'Bus Fee' THEN (SELECT perstudentpay.Amount FROM perstudentpay WHERE perstudentpay.StudentID = @stuid) WHEN 'Penality' THEN (COALESCE(calculatepenality(DATE(attachment.issuedon),(SELECT EtCalMonthsName FROM `etcalmonths` WHERE EtCalMonthsID = attachment.EtCalMonthsID)),0)) ELSE 0 END ) AS 'Amount'*/
    public function getAllPayments($StudentID)
    {
       $sql = "SELECT (SELECT EtCalMonthsName FROM etcalmonths WHERE EtCalMonthsID = attachment.EtCalMonthsID) As PaiedMonth,(SELECT `PaymentName` FROM `payment` WHERE `PaymentID` =attachment.PaymentID) as 'Payment',(SELECT `EduCalYear` FROM `educalyear` WHERE `EduCalYearID`=attachment.EduCalYearID) as 'Acadamic Year',attachment.Bank as 'Bank',(CASE (SELECT payment.PaymentName FROM payment WHERE payment.PaymentID = attachment.PaymentID) WHEN 'School Fee' THEN (SELECT pergradepay.Amount FROM student,pergradepay WHERE student.GradeID = pergradepay.GradeID and student.StudentID = :StudentID and pergradepay.PaymentID = 1) WHEN 'Bus Fee' THEN (SELECT perstudentpay.Amount FROM perstudentpay WHERE perstudentpay.StudentID = :StudentID ) WHEN 'Registration Fee' THEN (SELECT pergradepay.Amount FROM student,pergradepay WHERE student.GradeID = pergradepay.GradeID and student.StudentID = :StudentID and pergradepay.PaymentID = 7) WHEN 'ID Card Fee' THEN 30 WHEN 'After School' THEN 300 WHEN 'Penality' THEN (COALESCE(calculatepenality(DATE(attachment.issuedon),(SELECT EtCalMonthsName FROM `etcalmonths` WHERE EtCalMonthsID = attachment.EtCalMonthsID)),0)) ELSE 0 END ) AS 'Amount',attachment.stamp as 'stamp' FROM student,attachment WHERE student.StudentID = attachment.StudentID  and student.StudentID = :StudentID ";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
             array_push($result, $this->readpay($row));;
        }
        return $result; 
    }
    public function getBusFee($StudentID)
    {
       $sql = "SELECT (SELECT EtCalMonthsName FROM etcalmonths WHERE EtCalMonthsID = attachment.EtCalMonthsID) As PaiedMonth FROM student,attachment WHERE student.StudentID = attachment.StudentID and attachment.PaymentID = 2 and student.StudentID = :StudentID ";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        $rows = $q->fetchAll();
        $result = '';
        foreach($rows as $row) {
            $result .= $row['PaiedMonth'].", ";
        }
        return $result; 
    }
     public function getSections($GradeName)
    {
       $sql = "Select DISTINCT Section from student Where isactive = 1 and GradeID = (Select GradeID from grade where Name = :GradeName) ORDER BY Section";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":GradeName", $GradeName);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readsection($row));
        }
        return $result; 
    }
    public function getAll($type) { 
        $sql = "";
        if($type == 1)              
        {$sql = "SELECT * FROM student WHERE isactive = 1 ORDER BY GradeID ASC,CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";}
        else {
        $sql = "SELECT * FROM student WHERE (GradeID <= 4 or GradeID >= 15) and isactive = 1 ORDER BY GradeID ASC,CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";
        }       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readfrontend($row));
        }
        return $result;
       }
    public function getAllPayment() {               
        $sql = "SELECT * FROM student WHERE isactive = 1 ORDER BY GradeID ASC,CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->readPayment($row));
        }
        return $result;
    }
    public function getStudentByStudentID($StudentID) {               
        $sql = "SELECT * FROM student  where isactive = 1 and StudentID = ". $StudentID ;       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getStudentByGradeID($GradeID) {               
        $sql = "SELECT student.* FROM student where GradeID = ".$GradeID." ORDER BY CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getStudentByGradeName($Name) {               
        $sql = "SELECT * FROM `student` WHERE GradeID = (Select GradeID from grade where Name = '".$Name."') ORDER BY CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
       public function getStudentByGradeNameandSection($Name,$Section) {               
        $sql = "SELECT * FROM `student` WHERE GradeID = (Select GradeID from grade where Name = '".$Name."') and Section ='".$Section."' ORDER BY CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read($row));
        }
        return $result;
       }
    public function getStudentByParentsMobileNum($ParentsMobileNum) {               
        $sql = "SELECT student.* FROM student,address WHERE student.StudentID = address.StudentID and (address.FathersMobile = '".$ParentsMobileNum."' or address.MothersMobile = '".$ParentsMobileNum."') ORDER BY CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = array();
        foreach($rows as $row) {
            array_push($result, $this->read_all($row));
        }
        return $result;
       }
    public function getStudentIDByParentsMobileNum($ParentsMobileNum) {               
        $sql = "SELECT student.StudentID FROM student,address WHERE student.StudentID = address.StudentID and (address.FathersMobile = '".$ParentsMobileNum."' or address.MothersMobile = '".$ParentsMobileNum."') ORDER BY CONCAT(student.Name,' ',student.FName,' ',student.GFName) ASC";       
        $q = $this->db->prepare($sql);
        $q->execute();
        $rows = $q->fetchAll();
        $result = 0;
        if(count($rows)>0)
        {$result = $this->read_id($rows[0]);}
        return $result;
       }
    public function addStudent($SName,$FName,$GFName,$Gender,$GrdName,$Section,$fmob,$mmob,$add,$kk,$wor,$hno) {               
        $sql = "INSERT INTO `student`(`Name`, `FName`, `GFName`,`Gender`,`GradeID`, `Section`) VALUES (:Sname,:Fname,:GFname,:Gender,(SELECT `GradeID` FROM `grade` WHERE Name = :Gname),:section)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Sname", $SName);
        $q->bindParam(":Fname", $FName);
        $q->bindParam(":GFname", $GFName);
        $q->bindParam(":Gender", $Gender);
        $q->bindParam(":Gname", $GrdName);
        $q->bindParam(":section", $Section);
        if ($q->execute())
        {
            $addressresult = array();
            $StudentID = $this->db->lastInsertId();
            $address = new address($this->db);
            $address->addStudentAddress($StudentID,$fmob,$mmob,$add,$kk,$wor,$hno);
            //$address->addStudentAddress($StudentID,$fmob,$mmob,$address,$kk,$wor,$keb,$hno);
            return $this->getStudentByStudentID($StudentID);
        }
        else
        {
            return null;
        }
       }
    public function addStudentMini($SName,$FName,$GFName,$Gender,$GrdName,$Section,$fmob,$mmob) {               
        $sql = "INSERT INTO `student`(`Name`, `FName`, `GFName`,`Gender`,`GradeID`, `Section`) VALUES (:Sname,:Fname,:GFname,:Gender,(SELECT `GradeID` FROM `grade` WHERE Name = :Gname),:section)";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Sname", $SName);
        $q->bindParam(":Fname", $FName);
        $q->bindParam(":GFname", $GFName);
        $q->bindParam(":Gender", $Gender);
        $q->bindParam(":Gname", $GrdName);
        $q->bindParam(":section", $Section);
        if ($q->execute())
        {
            $addressresult = array();
            $StudentID = $this->db->lastInsertId();
            $address = new address($this->db);
            $address->addStudentAddressMini($StudentID,$fmob,$mmob);
            //$address->addStudentAddress($StudentID,$fmob,$mmob,$address,$kk,$wor,$keb,$hno);
            return $this->getStudentByStudentID($StudentID);
        }
        else
        {
            return null;
        }
       }
    public function updateStudent($StudentID,$SName,$FName,$GFName,$Gender,$GrdName,$Section,$fmob,$mmob) {               
        $sql = "UPDATE `student` SET `Name`=:Sname,`FName`=:Fname,`GFName`=:GFname,`Gender`=:Gender,`GradeID`=(SELECT `GradeID` FROM `grade` WHERE Name = :Gname),`Section`=:section where StudentID=:Sid";       
        $q = $this->db->prepare($sql);
        $q->bindParam(":Sid", $StudentID);
        $q->bindParam(":Sname", $SName);
        $q->bindParam(":Fname", $FName);
        $q->bindParam(":GFname", $GFName);
        $q->bindParam(":Gender", $Gender);
        $q->bindParam(":Gname", $GrdName);
        $q->bindParam(":section", $Section);
        if ($q->execute())
        {
            $address = new address($this->db);
            $address->updateStudentAddress($StudentID,$fmob,$mmob);
            //$address->addStudentAddress($StudentID,$fmob,$mmob,$address,$kk,$wor,$keb,$hno);
            return $this->getStudentByStudentID($StudentID);
        }
        else
        {
            return null;
        }
       }

    public function remove($StudentID) {
        $sql = "UPDATE student SET isactive = 0 WHERE StudentID = :StudentID";
        $q = $this->db->prepare($sql);
        $q->bindParam(":StudentID", $StudentID);
        $q->execute();
        return 'Student Removed';
    }

}

?>