<!DOCTYPE html>
<html>
<head>
<title>Login - 2Kyle16</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
<link rel="icon" href="images/favicon.png">
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


<?php
session_start();
?>


<!--

<form action="createacc.php">
	<input type="submit" value="Create Account" />
</form>
-->
<?php
	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	
	/* Check if logged in already */
	if(isset($_SESSION["username"])) {
		$username = $_SESSION["username"];
		echo "<p>Already logged in as $username <span><a href=\"logout.php\">Logout</a></span></p>"; // user is already logged in
		if(isset($_SESSION["isAdmin"])) { // check if user is admin user
			if($_SESSION["isAdmin"] == "true") {
				echo "<br><span><a href=\"admin.php\">Admin Controls</a></span>";
			}
		}
	} else {
		// not logged in, display login form
		echo "<form method=\"post\" action=\"login.php\">
	Username <input type=\"text\" name=\"username\" size=\"15\">
	Password <input type=\"password\" name=\"password\" size=\"15\">
	<input type=\"submit\" id=\"submit\" value=\"Login\">
</form>
<p></p>";
		
		if(!(preg_match('/login/',$_SERVER['HTTP_REFERER']))) { // do not store login as last page
		$_SESSION["last_page"] = $_SERVER['HTTP_REFERER'];
		}
	
		if(isset($_POST["username"]) && isset($_POST["password"])) {
			/* Read in parameters */
			$username = $_POST["username"];
			$password = $_POST["password"];
		
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
					
					/* check if user is an admin */
					$sql = "SELECT cid FROM AdminUser WHERE cid=?;";
					$stmt = $conn->prepare($sql);
					if(!$stmt->prepare($sql)) {
						echo "Failed to prepare statement.";
					} else {
						$stmt->bind_param("s", $cid);
						$stmt->execute();
						
						$count = 0;
						while($stmt->fetch()) {
							$count++;
						}
						
						if($count == 1) { // then user is an admin user
							$isAdmin = "true";
						} else { // else user is not an admin
							$isAdmin = "false";
						}
					}
					
					
					$last_page = $_SESSION["last_page"]; // get the last page so can redirect to it after logging in
					
					/* Store cid and username in PHP session so can tell if user is logged in on other pages */
					$_SESSION["cid"] = $cid;
					$_SESSION["username"] = $username;
					$_SESSION["isAdmin"] = $isAdmin;
					
					/* Store session attributes in JSP session as well hahahha */
					header("Location: setjspsesh.jsp?cid=$cid&username=$username&admin=$isAdmin&last=$last_page"); // jsp code will re direct to last page as well
					
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
		
		echo "<br><br>";
		echo "Don't have an account? <span><a href=\"createacc.php\">Sign up</a></span> today! ";
	}
	
	
	

?>


<br><br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>