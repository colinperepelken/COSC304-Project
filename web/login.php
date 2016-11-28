<!DOCTYPE html>
<html>
<head>
<title>Login - 2Kyle16</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>

<!--
<h1>Login</h1>
<form action="home.html">
	<input type="submit" value="Home" />
</form> colin i'm commenting out your ugly ass buttons-->
<p></p><br><br><br>
<form method="get" action="login.php">
	Username <input type="text" name="username" size="15">
	Password <input type="password" name="password" size="15">
	<input type="submit" id="submit" value="Login">
</form>
<p></p>



<!--

<form action="createacc.php">
	<input type="submit" value="Create Account" />
</form>
-->
<?php
	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	
	if(!empty($_GET["username"]) && !empty($_GET["password"])) {
		/* Read in parameters */
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
				// to do query to get cid that was just inserted 
				
			
				// then add into user session
				$sql = "INSERT INTO UserSession(cid, referralURL) VALUES ();";//needs to update user session in db to store 
				$_SERVER['HTTP_REFERER'];
				
				
				header("location: $_SERVER['HTTP_REFERER]"); // redirect browser to welcome page
			} else {
				echo "<br>Your Username or Password is invalid.";
			}
		}
		$stmt->close();
		$conn->close();
		
		/*******************TODO: add code to check if user is an admin ***************/
		
		
	} else { // if the user provided no input COLIN FIX THIS
		//echo "Please input a username and password.";
	}
	

?>
<br><br>
Don't have an account? <span><a href="createacc.php">Sign up</a></span> today! 

<br><br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>facebook link etc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>