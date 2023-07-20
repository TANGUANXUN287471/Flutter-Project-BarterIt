<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['sellerid'])){
	$sellerid = $_POST['sellerid'];	
	$sqlloadpropose = "SELECT * FROM `propose_table` INNER JOIN `item_table` ON propose_table.seller_item_id = item_table.item_id WHERE propose_table.seller_id = '$sellerid' AND propose_table.propose_status = 0";
}

$result = $conn->query($sqlloadpropose);

if ($result->num_rows > 0) {
    $proposeitems["propose"] = array();
	while ($row = $result->fetch_assoc()) {
        $proposelist = array();
        $proposelist['propose_id'] = $row['propose_id'];
        $proposelist['seller_item_id'] = $row['seller_item_id'];
		$proposelist['seller_item_name'] = $row['seller_item_name'];
        $proposelist['seller_item_qty'] = $row['seller_item_qty'];
        $proposelist['seller_item_value'] = $row['seller_item_value'];
		$proposelist['seller_item_desc'] = $row['seller_item_desc'];
		$proposelist['item_name'] = $row['item_name'];
        $proposelist['item_type'] = $row['item_type'];
		$proposelist['item_condition'] = $row['item_condition'];
        $proposelist['item_desc'] = $row['item_desc'];
        $proposelist['item_value'] = $row['item_value'];
        $proposelist['item_qty'] = $row['item_qty'];
        $proposelist['propose_item_id'] = $row['propose_item_id'];
		$proposelist['propose_item_name'] = $row['propose_item_name'];
        $proposelist['propose_item_qty'] = $row['propose_item_qty'];
        $proposelist['propose_item_value'] = $row['propose_item_value'];
		$proposelist['propose_item_desc'] = $row['propose_item_desc'];
        $proposelist['buyer_id'] = $row['buyer_id'];
		$proposelist['seller_id'] = $row['seller_id'];
        $proposelist['propose_date'] = $row['propose_date'];
        array_push($proposeitems["propose"] ,$proposelist);
    }
    $response = array('status' => 'success', 'data' => $proposeitems);
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