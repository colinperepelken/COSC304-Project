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

<div style="float: left;">
<?php
	/* dispay logged in as message */
	session_start();
	if(isset($_SESSION["cid"])) {
		$username = $_SESSION["username"];
		echo "Logged in as $username";
	} 
?>
</div>

<?php
	error_reporting(-1); // report all PHP errors 
	ini_set('display_errors', 1);
	
	if(isset($_SESSION["cid"])) {
		$username = $_SESSION["username"];
		$isAdmin = $_SESSION["isAdmin"];
		if($isAdmin == "true") {
			
			//show form
			echo "<br>
					<p><span><a href=\"admin.php?reports='1'\">Generate Reports</a></span></p>
					<p><span><a href=\"admin.php?add='1'\">Add a Product</a></span></p>
					<p><span><a href=\"admin.php?delete='1'\">Delete a Product</a></span></p>
					<br>";
			
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
			
			/* GENERATE REPORTS */
			if(isset($_GET["reports"])) {
				
				echo "<h1>Sales Reports</h1>";
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
				
				/*  --Top 3 Most Ordered Products-- */
				echo "<b>Top 3 Most Ordered Products</b><br>";
				$sql = "select Product.pname, Product.pid
						from CustomerOrder, HasProduct, Product 
						where Product.pid = HasProduct.pid and HasProduct.oid = CustomerOrder.oid
						group by Product.pid
						order by count(HasProduct.quantity)	desc limit 3;";
				$result = $conn->query($sql);
				if ($result->num_rows > 0) {
					echo "<table><tr><td>Name </td><td>PID</td></tr>";
					// output data of each row
					while($row = $result->fetch_assoc()) {
						
						echo "<tr><td>".$row["pname"]."</td><td>".$row["pid"]."</td></tr>";
					}
					echo "</table>";
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
				
				
			/* ADD A PRODUCT */
			} else if(isset($_GET["add"]) || isset($_GET["pname"])) {
				if(isset($_GET["pname"])) {
					
					/* insert the new product TO DO: data validation*/
					$cost = $_GET["cost"];
					$pname = $_GET["pname"];
					$desc = $_GET["desc"];
					$inv = $_GET["inv"];
					$wid = $_GET["wid"];
					$cid = $_GET["cid"];
					$img = $_GET["img"];
					
					
					$sql = "INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (?,?,?,?,?,?,?);";
					$stmt = $conn->stmt_init();
					if(!$stmt->prepare($sql)) {
						echo "Failed to prepare statement";
					} else {
						$stmt->bind_param("sssssss", $cost, $pname, $desc, $img, $wid, $inv, $cid); // bind params
						$stmt->execute(); // execute statement
						header("Location: admin.php");
					}
				} else {
					// collect information for product to add
					echo "<form method=\"get\" action=\"admin.php\">
	<table>
	<tr><td align =\"left\">Name:</td><td align =\"left\"><input type=\"text\" name=\"pname\" size=\"15\"></td></td>
	<tr><td  align =\"left\">Description:</td><td  align =\"left\"><input type=\"text\" name=\"desc\" size=\"20\"></td></td>
	<tr><td align =\"left\">Image URL:</td><td align =\"left\"><input type=\"text\" name=\"img\" size=\"20\"></td></td>
	<tr><td align =\"left\">Cost:</td><td align =\"left\"><input type=\"text\" name=\"cost\" size=\"3\"></td></td>
	<tr><td align =\"left\">Inventory:</td><td align =\"left\"><input type=\"text\" name=\"inv\" size=\"3\"></td></td>
	<tr><td align =\"left\">WID:</td><td align =\"left\"><input type=\"text\" name=\"wid\" size=\"3\"></td></td>
	<tr><td align =\"left\">CID:</td><td align =\"left\"><input type=\"text\" name=\"cid\" size=\"3\"></td></td>
	</table>
	<br><br>
	<input type=\"submit\" name=\"submit\" value=\"Add Product\" id=\"submit\" />
</form>";
				}
			

			/* DELETE A PRODUCT */
			} else if(isset($_GET["delete"])) {
				
				if(isset($_GET["pid"])) { // if a pid to delete is specified then delete it
					$pid = $_GET["pid"];
					$sql = "DELETE FROM Product WHERE pid=?;";
					$stmt = $conn->stmt_init();
					if(!$stmt->prepare($sql)) {
						echo "Failed to prepare statement.";
					} else {
						$stmt->bind_param("i", $pid);
						$stmt->execute();
						header("Location: admin.php");
					}
					
				} else { // else show the list of products
					$sql = "SELECT pid, pname FROM Product;";
					$result = $conn->query($sql);
					if ($result->num_rows > 0) {
						echo "<table><tr><td></td><td><b>pid </b></td><td><b>pname</b></td></tr>";
						// output data of each row
						while($row = $result->fetch_assoc()) {
							$pid = $row["pid"];
							echo "<tr><td><span><a href=\"admin.php?delete=1&pid=$pid\">Delete</a></span></td><td>".$row["pid"]."</td><td>".$row["pname"]."</td></tr>";
						}
						echo "</table>";
					} 
				}
			
			}
			
			$conn->close(); // close the connection
		} else {
			echo "Admin permissions are required to access this page! Get out!"; // deny access if user is not an admin 
		}
	} else {
		echo "Admin permissions are required to access this page! Get out!"; // deny access if not logged in
	}
?>


<br><br><br><br>
</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>