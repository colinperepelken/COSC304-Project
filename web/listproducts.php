<!DOCTYPE html>
<html>
<head>
<title>2Kyle16 Store</title>
<link rel="stylesheet" type="text/css" href="2kyle16.css">
</head>
<body>
<div class = "mainDiv"><div id ="header">image<br><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="/">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<!--
<form action="home.html">
	<input type="submit" value="Home" />
</form>
<form action="showcart.jsp">
	<input type="submit" value="View Cart" />
</form>
<form action="login.php">
	<input type="submit" value="Login" />
</form> -->

<p></p>
<p></p>

<form method="get" action="listproducts.php">
	<input type="text" name="productName" size="50">
	<input type="submit" value="Search" id="submit"> 
	<br><br>
	(Leave blank for all products)
</form>
<form method="get" action="listproducts.php">
	<input type="checkbox" checked="true" name="clothing" value="1">Clothing
	<input type="checkbox" checked="true" name="accessories" value="2">Accessories
	<input type="checkbox" checked="true" name="music" value="3">Music
</form>

<?php
	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);

	/* Read in parameters if there is one */
	if(isset($_GET["productName"])) {
		$name = $_GET["productName"];
	} else {
		$name = "";	// if search bar is blank
	}
	
	//$category = array(1=>1,2=>2,3=>3);
	/*if($_GET["clothing"] == '1') {
		$category[1]=1;
	}
	if($_POST['accessories'] == '2') {
		$category[2]=2;
	}
	if($_POST['music'] == '3') {
		$category[3]=3;
	}*/
	
	/* VALIDATION */
	// strip symbols from search
	$name = preg_replace('/[^\p{L}\p{N}\s]/u', '', $name);
	
	$hasParam = false;
	$query = "SELECT pid, cost, pname, image, inventory FROM Product WHERE categoryID=1 OR categoryID=2 OR categoryID=3";
	

	
	if($name == "") {
		echo "<h1>All Products</h1>";
	} else {
		echo "<h1>Products containing '$name'</h1>";
		$query .= " WHERE pname LIKE ?";
		$name = "%$name%";
		$hasParam = true;
	}
	
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
		if($hasParam) $stmt->bind_param("s", $name); // bind param
		$stmt->execute(); // execute statement
		
		$stmt->bind_result($pid, $cost, $pname, $image, $inventory); // bind result variables
		
		echo "<table><tr>";
		$count = 1;
		while($stmt->fetch()) {
			if($inventory=="0") {
				$msg = "Out of Stock!";
			} else {
				$msg = "<span><a href=\"addcart.jsp?pid=$pid&pname=$pname&cost=$cost&qty=1\">Add to Cart</a></span>";
			}
			
			echo "<td><a href=\"preview.jsp?pid=$pid\"><img src=\"images/products/$image\" alt=\"Product Image\"></a>
			<p><b>$pname</b></p><p>\$$cost</p><p>$msg</p></td>";
			echo $count%3==0?"</tr><tr>":""; // 3 per row
 -			$count++;
		}
		echo "</tr></table>";			
	}
	$stmt->close(); // close stmt
	$conn->close(); // close connection

?>
</center>
</div></div>
<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>