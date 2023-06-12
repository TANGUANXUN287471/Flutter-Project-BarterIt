<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemName'];
$item_desc = $_POST['itemDesc'];
$item_value = $_POST['itemValue'];
$item_qty = $_POST['itemQty'];
$item_type = $_POST['type'];
$item_condition = $_POST['condition'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image = $_POST['image'];

$sqlinsert = "INSERT INTO `item_table`(`user_id`,`item_name`, `item_desc`, `item_type`,`item_condition`, `item_value`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_name','$item_desc','$item_type','$item_condition','$item_value','$item_qty','$latitude','$longitude','$state','$locality')";

if($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($image);
	$path = '../assets/items/'.$filename.'.png';
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>