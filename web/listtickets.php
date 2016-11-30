<!DOCTYPE html>
<html>
<head>
<title>2Kyle16 Tickets</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
<link rel="icon" href="images/favicon.png">

<script>
	function addcart(pid, pname, cost, id) {
		window.location.href ="addcart.jsp?pid=" + pid + "&pname=" + pname +"&qty=" + document.getElementById(id).value + "&cost=" + cost;
	}
</script>

<script>
	function checkQuantity(max, id, pname, cost, count) {
		var v = document.getElementById(id).value;
		if(parseInt(v) >= max){
			alert("Your quantity is too high, we dont even have that many tickets you greedy bastard!");
		} else {
			addcart(id, pname, cost, count)
		}				
	}
</script>

</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a></font></div>
<div style="float: left;">
<?php
	/* Check if user is logged in and display message */
	session_start();
	if(isset($_SESSION["cid"])) {
		$username = $_SESSION["username"];
		echo "Logged in as $username <span><a href=\"logout.php\">Logout</a></span>";
	} else {
		echo "Logged in as Guest";
	}
?>
</div>
<div class = "content">
<center>

<!--
<form action="home.html">
	<input type="submit" value="Home" />
</form>
<form action="">
	<input type="submit" value="View Cart" />
</form>
<form action="login.php">
	<input type="submit" value="Login" />
</form> -->


<?php

	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	

	$hasParam = false;
	$query = "SELECT pid, pname, cost, image, inventory
		      FROM Ticket";
	


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
		$stmt->bind_result($pid, $pname, $cost, $image, $inventory);
		
		echo "<p>";
		$count = 1;
		while($stmt->fetch()) {
			if($inventory=="0") {
				$msg = "Sold out";
			} else {
				$msg = "<tr><td><input type='number' class='numberBox' id='number$count' 
						value='1' id='qty' size='1' min='1' max='$inventory'>";
				$msg .= "<input type=\"button\" id=\"submit\" value=\"Add to Cart\" 
						onclick=\"checkQuantity(&#34;$inventory&#34;, &#34;number$count&#34;,&#34;$pname&#34;, &#34;$cost&#34;, &#34;number$count&#34;)\"></td></tr>";
				
			}
			echo "<br><img src=\"images/tickets/$image\" alt=\"Ticket Image\" style=\"float:left\">
			<br><br><br><b>$pname</b><br>\$$cost<br>$msg<br> </p><br><br><br><br><br>";
			$count++;
		}		
	}
	$stmt->close(); // close stmt
	$conn->close(); // close connection

?>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>