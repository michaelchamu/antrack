<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {

/* Check all form inputs using check_input function */

$postdata = file_get_contents("php://input");
$request = json_decode($postdata);

@$email = $request->email;
@$message = $request->message;


// if (empty($airline)) {
// 	$airline = "Not Applicable";
// }
//
// if (empty($flight)) {
// 	$flight = "Not Applicable";
// }
//
// if (empty($mobile)) {
// 	$mobile = "Not Provided";
// }
//
//
// if (empty($passport)) {
// 	$passport = "Not Provided";
// }
//
// if (empty($postal)) {
// 	$postal = "Not Provided";
// }
//
// if (empty($physical)) {
// 	$physical = "Not Provided";
// }

$message = "
<html>
<head>
</head>

<body>


<p>$message</p>


</body>
</html>

";

/* Set e-mail recipient */
$to = 'stalin@stalinkay.com';

$subject = 'Message to ' . $email . ', send from NAMCOR website' ;

$headers = "From: " . strip_tags('noreply@namcor.com.na') . "\r\n";
$headers .= "CC: " .  strip_tags('stalin@stalinkay.com') ."\r\n";
$headers .= "BCC: " .  strip_tags('stalin@stalinkay.com') ."\r\n";

$headers .= "MIME-Version: 1.0\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";

/* Send the message using mail() function */
	$GLOBALS['$mailsend'] = mail($to, $subject, $message, $headers);

	json_encode(array('mailsent' => 1));
}

?>