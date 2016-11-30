<!DOCTYPE html>
<html>
<head>
<title>Admin - 2Kyle16</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>


<p></p><br><br><br>



<?php
	session_start();

	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	
	if(isset($_SESSION["cid"])) {
		$username = $_SESSION["username"];
		echo "Logged in as $username";
		$isAdmin = $_SESSION["isAdmin"];
		if($isAdmin == "true") {
			
			/* show admin stuff below */
			
			
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
			
		
			echo "<h3>Sales Reports</h3>";
			/* ------------ TON OF QUERIES INCOMING -------------------*/
			
			/*  --Total Gross Revenue To Date-- */
			echo "<b>Total Gross Revenue To Date</b><br>";
			$sql = "select sum(cartTotal) as revenue 
						from CustomerOrder;";
			$result = $conn->query($sql);
			if ($result->num_rows > 0) {
				// output data of each row
				while($row = $result->fetch_assoc()) {
					echo $row["revenue"];
				}
			} 
			
			echo "<br><br>";
			
			/*  --Average Customer Purchase Cost (Not Including Shipping Cost)-- */
			echo "<b>Average Customer Purchase Cost (Not Including Shipping Cost)</b><br>";
			$sql = "select avg(cartTotal) as averagePurchase 
					from CustomerOrder;";
			$result = $conn->query($sql);
			if ($result->num_rows > 0) {
				// output data of each row
				while($row = $result->fetch_assoc()) {
					echo $row["averagePurchase"];
				}
			} 
			
			echo "<br><br>";
			
			/*  --Top 3 Most Common Provinces That Ordered A Product-- */
			echo "<b>Top 3 Most Common Provinces That Ordered A Product</b><br>";
			$sql = "select province, count(province) as provNumber 
					from CustomerOrder 
					group by province 
					order by provNumber desc limit 3;";
			$result = $conn->query($sql);
			if ($result->num_rows > 0) {
				echo "<table><tr><td>Province </td><td>#Orders</td></tr>";
				// output data of each row
				while($row = $result->fetch_assoc()) {
					
					echo "<tr><td>".$row["province"]."</td><td>".$row["provNumber"]."</td></tr>";
				}
				echo "</table>";
			} 
			
			echo "<br><br>";
			
			/*  --Top 3 Customers Who Have Placed The Most Orders-- */
			echo "<b>Top 3 Customers Who Have Placed The Most Orders</b><br>";
			$sql = "select AccountHolder.name, count(CustomerOrder.cid) as numOrdersPlaced
					from CustomerOrder, AccountHolder
					where AccountHolder.cid = CustomerOrder.cid 
					group by CustomerOrder.cid, AccountHolder.name
					order by numOrdersPlaced desc limit 3;";
			$result = $conn->query($sql);
			if ($result->num_rows > 0) {
				echo "<table><tr><td> Name </td><td>#Orders</td></tr>";
				// output data of each row
				while($row = $result->fetch_assoc()) {
					
					echo "<tr><td>".$row["name"]."</td><td>".$row["numOrdersPlaced"]."</td></tr>";
				}
				echo "</table>";
			} 
			
			echo "<br><br>";
			
			/*  --Most Common Shipping Method-- */
			echo "<b>Most Common Shipping Method</b><br>";
			$sql = "select shippingType, count(shippingType) as numShips
					from CustomerOrder
					group by shippingType
					order by count(shippingType) desc limit 1;";
			$result = $conn->query($sql);
			if ($result->num_rows > 0) {
				echo "<table><tr><td> Shipping Method </td><td>#Orders</td></tr>";
				// output data of each row
				while($row = $result->fetch_assoc()) {
					
					echo "<tr><td>".$row["shippingType"]."</td><td>".$row["numShips"]."</td></tr>";
				}
				echo "</table>";
			} 
			
			
			$conn->close(); // close the connection
		} else {
			$last_page = $_SERVER['HTTP_REFERER']; // go back if user is not an admin
			header("Locaton: $last_page");
		}
	} else {
		$last_page = $_SERVER['HTTP_REFERER']; // go back if user is not logged in
		header("Location: $last_page");
	}
?>


<br><br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>