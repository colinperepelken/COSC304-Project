<!DOCTYPE html>
<html>
<head>
<title>Load</title>
</head>
<body>

<h1>Load</h1>

<form action="home.html">
	<input type="submit" value="Home" />
</form>
<p></p>
<p></p>


<?php
	//error_reporting(-1); // report all PHP errors 
	//ini_set('display_errors', 1);


	$query = "SELECT pid FROM Product";

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
		$stmt->execute(); // execute statement
		
		$stmt->bind_result($pid); // bind result variables
		
		$sql = "INSERT INTO Stores(inventory,wid,pid) VALUES (?,?,?)";
		$stmt2 = $conn->stmt_init();
		$stmt2->prepare($sql);
		
		$count = 1;
		while($stmt->fetch()) {
			$inventory = rand(0,10);
			$wid = rand(1,2);
			$stmt2->bind_param("iis", 6, 1, $pid);
			$stmt2->execute();
			$count++;
		}
		echo "<p><h2>$count products stored.</h2></p>";			
	}
	$stmt->close(); // close stmt
	$conn->close(); // close connection

?>

</body>
</html>