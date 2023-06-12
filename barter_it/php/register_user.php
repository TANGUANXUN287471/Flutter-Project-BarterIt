<?php
if(!isset($_POST)){
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);

$sqlinsert = "INSERT INTO `user_registration`(`user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`) VALUES ('$email','$name','$phone','$password','$otp')";

if($conn->query($sqlinsert)== TRUE){
	$response = array('status' => 'success','data' => null);
sendJsonResponse($response);
}else{
	$response = array('status' => 'failed','data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}
?>