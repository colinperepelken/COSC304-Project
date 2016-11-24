<!DOCTYPE html>
<html>
<head>
<title>Login - 2Kyle16</title>
</head>
<body>

<h1>Login</h1>

<form method="get" action="login.php">
	<input type="text" name="username" size="12">
	<input type="text" name="password" size="15">
	<input type="submit" value="Login">
</form>

<?php
	ini_set('display_errors', 1); // display errors
	
	/* Read in parameters */
	if(isset($_GET["username"])&&isset($_GET(["password"]) {
		$username = $_GET["username"];
		$password = $_GET["password"];
		
		$query = "SELECT cid FROM AccountHolder WHERE username = ? AND password = ?";
		
		// connection information
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
			echo "Failed to prepare statement.";
		} else {
			$stmt->bind_param("ss", $username, $password); // bind params
			$stmt->execute(); // execute the statement
			$stmt->bind_result($cid); // bind result variable
			
			/* Query should only return 1 row if the username and password are correct. */
			$count = 0;
			while($stmt->fetch()) {
				$count++;
			}
			
			if($count == 1) {
				header("location: welcome.html"); // redirect browser to welcome page
			} else {
				echo "Your Username or Password is invalid."
			}
		}
		
		
		
		
		
		
	} else { // if the user provided no input
		echo "Please input a username and password."
	}
	

?>

</body>
</html>