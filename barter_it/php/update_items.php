<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$item_id = $_POST['itemId'];
$item_name = $_POST['itemName'];
$item_qty = $_POST['itemQty'];
$item_value = $_POST['itemValue'];
$item_type = $_POST['type'];
$item_desc = $_POST['itemDesc'];
$item_condition = $_POST['condition'];

$sql = "UPDATE `item_table` SET `item_name`='$item_name',`item_desc`='$item_desc',`item_type`='$item_type',`item_condition`='$item_condition',`item_value`='$item_value',`item_qty`='$item_qty' WHERE item_id = '$item_id'";

if ($conn->query($sql) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
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
