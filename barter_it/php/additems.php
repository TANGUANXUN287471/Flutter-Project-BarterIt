<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['item_id'];
$cartqty = $_POST['cart_qty'];
$cartprice = $_POST['cart_price'];
$userid = $_POST['userid'];
$sellerid = $_POST['sellerid'];

$checkitemid = "SELECT * FROM `cart_table` WHERE `user_id` = '$userid' AND  `item_id` = '$itemid'";
$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `cart_table`
        INNER JOIN `item_table` ON cart_table.item_id = item_table.item_id
        SET `cart_qty` = (cart_table.cart_qty + 1),
            `cart_price` = (cart_table.cart_price + item_table.item_value)
        WHERE `cart_table`.`user_id` = '$userid' AND `cart_table`.`item_id` = '$itemid'";

}else{
	$sql = "INSERT INTO `cart_table`(`item_id`, `cart_qty`, `cart_price`, `user_id`, `seller_id`) VALUES ('$itemid','$cartqty','$cartprice','$userid','$sellerid')";
}

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