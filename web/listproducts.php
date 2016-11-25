<!DOCTYPE html>
<html>
<head>
<title>2Kyle16 Store</title>
</head>
<body>

<h1>2Kyle16 Offical Merchandise</h1>

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

<form method="get" action="listproducts.php">
	<input type="text" name="productName" size="50">
	<input type="submit" value="Submit"> (Leave blank for all products)
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
	
	$hasParam = false;
	$query = "SELECT cost, pname, image FROM Product";
	
	if($name == "") {
		echo "<h2>All Products</h2>";
	} else {
		echo "<h2>Products containing '$name'</h2>";
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
		
		$stmt->bind_result($cost, $name, $image); // bind result variables
		
		echo "<table><tr>";
		$count = 1;
		while($stmt->fetch()) {
			echo "<td><a href=\"images/products/$image\"><img src=\"images/products/$image\" alt=\"Product Image\"></a>
			<p><b>$name</b></p><p>\$$cost</p></td>";
			echo $count%3==0?"</tr><tr>":"";
			$count++;
		}
		echo "</tr></table>";			
	}
	$stmt->close(); // close stmt
	$conn->close(); // close connection

?>

</body>
</html>