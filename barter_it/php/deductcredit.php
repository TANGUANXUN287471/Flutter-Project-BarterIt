<?php
if (!isset($_POST['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_POST['userid'];

include_once("dbconnect.php");

// Fetch the current user_credit value from the database
$sql_fetch_credit = "SELECT `user_credit` FROM `user_registration_table` WHERE user_id = '$userid'";
$result_fetch_credit = $conn->query($sql_fetch_credit);

if ($result_fetch_credit->num_rows > 0) {
    // Fetch the user_credit value from the database
    $row = $result_fetch_credit->fetch_assoc();
    $current_credit = $row['user_credit'];

    // Check if the user has enough credit to accept the propose
    if ($current_credit >= 5) {
        // Subtract 5 from the current user_credit value
        $new_credit = $current_credit - 5;

        // Update the user_credit value in the database
        $sql_update_credit = "UPDATE `user_registration_table` SET `user_credit` = '$new_credit' WHERE user_id = '$userid'";
        $result_update_credit = $conn->query($sql_update_credit);

        if ($result_update_credit === TRUE) {
            // Update the propose status to 1 (accepted) in the propose_table
            $proposeid = $_POST['proposeid']; 

            $sql_update_propose_status = "UPDATE `propose_table` SET `propose_status` = 1 WHERE seller_id = '$userid' AND propose_id = '$proposeid'";
            $result_update_propose_status = $conn->query($sql_update_propose_status);

            if ($result_update_propose_status === TRUE) {
                $response = array('status' => 'success', 'data' => 'User credit updated and propose accepted.');
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => 'Failed to update propose status.');
                sendJsonResponse($response);
            }
        } else {
            $response = array('status' => 'failed', 'data' => 'Failed to update user credit.');
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => 'Not enough credit to accept the propose.');
        sendJsonResponse($response);
    }
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
