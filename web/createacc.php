<!DOCTYPE html>
<html>
<head>
<title>Create Account - 2Kyle16</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
</head>
<body>
<div class = "mainDiv"><div id ="header">image<br><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="/">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<h1>Create Account</h1>
<!--
<form action="home.html">
	<input type="submit" value="Home" />
</form>
<p></p> -->

<form method="get" action="createacc.php">
	<table>
	<tr><td>Username</td><td><input type="text" name="username" size="15"></td></td>
	<tr><td>Password</td><td><input type="password" name="password" size="15"></td></td>
	<tr><td>Email</td><td><input type="text" name="email" size="15"></td></td>
	<tr><td>Name</td><td><input type="text" name="name" size="15"></td></td>
	<tr><td>Birthdate (YYYY-MM-DD)</td><td><input type="text" name="date" size="15"></td></td>
	</table>
	<br><br>
	<input type="submit" name="submit" value="Sign Up" id="submit" />
</form>
<p></p>

<?php
	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	
	if(!empty($_GET["username"]) && !empty($_GET["password"]) && !empty($_GET["email"]) && !empty($_GET["name"]) && !empty($_GET["date"])) {
		/* Read in parameters */
		$username = $_GET["username"];
		$password = $_GET["password"];
		$email = $_GET["email"];
		$name = $_GET["name"];
		$date = $_GET["date"];
		
		$sql = "INSERT INTO AccountHolder (username, password, email, name, birthDate) VALUES (?,?,?,?,?)";
		
		// connection information
		$server = "cosc304.ok.ubc.ca";
		$uid = "group6";
		$pw = "group6";
		$db = "db_group6";
		
		// connect
		$conn = new mysqli($server, $uid, $pw, $db);
		
		// check connection
		if($conn->connect_error) {
			echo "Failed to connect to server: " . $conn->connect_error;
		}
		
		$stmt = $conn->stmt_init();
		if(!$stmt->prepare($sql)) {
			echo "Failed to prepare statement";
		} else {
			$stmt->bind_param("sssss", $username, $password, $email, $name, $date); // bind params
			$stmt->execute(); // execute statement
			header("location: welcome.html"); // redirect browser to welcome page
			
		}
		$conn->close();
	}
?>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>