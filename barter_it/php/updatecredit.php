<?php
if (!isset($_POST['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_POST['userid'];

include_once("dbconnect.php");

// Fetch the user credit from the database
$sql_fetch_credit = "SELECT `user_credit` FROM `user_registration_table` WHERE user_id = '$userid'";
$result_fetch_credit = $conn->query($sql_fetch_credit);

if ($result_fetch_credit->num_rows > 0) {
    // Fetch the user credit value from the database
    $row = $result_fetch_credit->fetch_assoc();
    $user_credit = $row['user_credit'];

    $response = array('status' => 'success', 'data' => array('user_credit' => $user_credit));
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => 'User ID not found.');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
