<?php
if (!isset($_POST['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_POST['userid'];

include_once("dbconnect.php");

$sql = "SELECT * FROM `user_registration_table` WHERE user_id = '$userid'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $userInfo = $result->fetch_assoc();

    $response = array(
        'status' => 'success',
        'data' => array(
            'sellerinfo' => array(
                'name' => $userInfo['user_name'],
                'phone' => $userInfo['user_phone'],
                'email' => $userInfo['user_email'],
				'datereg' => $userInfo['user_datereg']
            )
        )
    );
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
