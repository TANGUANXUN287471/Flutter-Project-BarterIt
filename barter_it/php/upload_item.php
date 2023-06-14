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
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];
$image4 = $_POST['image4'];

$sqlinsert = "INSERT INTO `item_table`(`user_id`,`item_name`, `item_desc`, `item_type`,`item_condition`, `item_value`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_name','$item_desc','$item_type','$item_condition','$item_value','$item_qty','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $filename = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);

    // Save image 1
    $decoded_string = base64_decode($image);
    $path1 = '../assets/items/'.$filename.'_1.png';
    file_put_contents($path1, $decoded_string);

    // Save image 2
    $decoded_string2 = base64_decode($image2);
    $path2 = '../assets/items/'.$filename.'_2.png';
    file_put_contents($path2, $decoded_string2);

    // Save image 3
    $decoded_string3 = base64_decode($image3);
    $path3 = '../assets/items/'.$filename.'_3.png';
    file_put_contents($path3, $decoded_string3);

    // Save image 4
    $decoded_string4 = base64_decode($image4);
    $path4 = '../assets/items/'.$filename.'_4.png';
    file_put_contents($path4, $decoded_string4);

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