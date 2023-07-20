<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$selleritemid = $_POST['seller_item_id'];
$selleritemname = $_POST['seller_item_name'];
$selleritemqty = $_POST['seller_item_qty'];
$selleritemvalue = $_POST['seller_item_value'];
$selleritemdesc = $_POST['seller_item_desc'];
$proposeitemid = $_POST ['propose_item_id'];
$proposeitemname = $_POST ['propose_item_name'];
$proposeitemqty = $_POST ['propose_item_qty'];
$proposeitemvalue = $_POST ['propose_item_value'];
$proposeitemdesc = $_POST ['propose_item_desc'];
$userid = $_POST['user_id'];
$sellerid = $_POST['seller_id'];

$sql = "INSERT INTO `propose_table`(`seller_item_id`, `seller_item_name`, `seller_item_qty`, `seller_item_value`, `seller_item_desc`, `propose_item_id`, `propose_item_name`, `propose_item_qty`, `propose_item_value`, `propose_item_desc`, `buyer_id`, `seller_id`) VALUES ('$selleritemid', '$selleritemname','$selleritemqty','$selleritemvalue', '$selleritemdesc', '$proposeitemid','$proposeitemname','$proposeitemqty','$proposeitemvalue', '$proposeitemdesc','$userid','$sellerid')";

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'failed', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>