<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: *");
header("Access-Control-Allow-Headers: *");
$target_dir = "upload/";

$originalfile = $target_dir . basename($_FILES['uploadImg']['name']);
$uploadOk = 1;
$imageFileType = strtolower(pathinfo($originalfile,PATHINFO_EXTENSION));
$target_file = $target_dir .$_POST['sid'].'.'.$imageFileType;
echo $target_file." ";
// Check if image file is a actual image or fake image
//if(isset($_POST["myfile"])) {
  $check = getimagesize($_FILES['uploadImg']['tmp_name']);
  if($check !== false) {
    echo "File is an image - " . $check["mime"] . ".";
    $uploadOk = 1;
  } else {
    echo $_FILES['uploadImg']['name'];
    $uploadOk = 0;
  }
//}
// Check if file already exists
if (file_exists($target_file)) {
  echo "Sorry, file already exists.";
  $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
&& $imageFileType != "gif" ) {
  echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
  $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
  echo "Sorry, your file was not uploaded.";
// if everything is ok, try to upload file
} else {
  if (move_uploaded_file($_FILES['uploadImg']['tmp_name'], $target_file)) {
    echo "The file ". htmlspecialchars( basename( $_FILES['uploadImg']['name'])). " has been uploaded.";
  } else {
    echo "Sorry, there was an error uploading your file.";
  }
}
?>

