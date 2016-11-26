<!DOCTYPE html>
<html>
<head>
<title>2Kyle16 Store</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
</head>
<body>

<h1>2Kyle16 Tour Information</h1>

<form action="home.html">
	<input type="submit" value="Home" />
</form>
<form action="">
	<input type="submit" value="View Cart" />
</form>
<form action="login.php">
	<input type="submit" value="Login" />
</form>

<p></p>
<p></p>

<?php

	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	

	$hasParam = false;
	$query = "SELECT pname, cost, image, inventory
		      FROM Ticket";
	
	echo "<h2>Some Dope Paper Granting Access to Kyle's Lit Concerts</h2>";

	$server = "cosc304.ok.ubc.ca";
	$uid = "group6";
	$pw = "group6";
	$db = "db_group6";
	
	// connect
	$conn = new mysqli($server, $uid, $pw, $db);
	
	// check connection
	if($conn->connect_error)
		echo "Failed to connect to server: " . $conn->connect_error;
	
	$stmt = $conn->stmt_init();
	
	if(!$stmt->prepare($query)) {
		echo "Failed to prepare statement";
	} else { 
		$stmt->execute();
		$stmt->bind_result($pname, $cost, $image, $inventory);
		
		echo "<table><tr>";
		$count = 1;
		while($stmt->fetch()) {
			if($inventory=="0") {
				$msg = "Out of Stock!";
			} else {
				$msg = "Add to Cart";
			}
			echo "<td><a href=\"images/tickets/$image\"><img src=\"images/tickets/$image\" alt=\"Ticket Image\"></a>
			<p><b>$pname</b></p><p>\$$cost</p><p>$msg</p></td>";
		}
		echo "</tr></table>";			
	}
	$stmt->close(); // close stmt
	$conn->close(); // close connection

?>
