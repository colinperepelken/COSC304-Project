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
					<p><span><a href=\"admin.php?reinit='1'\">Re Initialize the Product Database</a></span></p>
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
			
			/* RE INITIALIZE THE PRODUCT DATABASE */
			} else if(isset($_GET["reinit"])) {
				
				// TODO.. should write a SQL parser and just load the .sql files and run them but whatever this way works too
				// at least ill get more insertions on github this way ;)
				$sql = 
					"
					DELETE FROM CustomerOrder;
					DELETE FROM HasProduct;
					DELETE FROM Product;
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (45.00,\"CN TOWER Vinyl Album\",\"Includes the hit single ''George Bush'' and many other top tracks!\",\"album_record2_300.png\",1,65,3);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (10.00,\"Snapback Hat\",\"Comes in grey. A fashionable wear for any occasion. Wear it backwards or forwards!\",\"hat.png\",1,115,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (25.00,\"Hoodie - Grey\",\"Comes in grey. Warm %100 cotton. Stay toasty this winter. Want to look like a total park rat while you shred the pow at Biggie? Buy this.\",\"hoodie1.png\",1,99,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (25.00,\"Hoodie - Red\",\"Comes in red. Warm %100 cotton. Stay toasty this winter. Want to look like a total park rat while you shred the pow at Biggie? Buy this.\",\"hoodie2.png\",1,55,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,\"Lighter - White\",\"Comes in white. Designed in the Smokanagan, this will help you stay lit fam. Anyone spare some darts?\",\"lighter1.png\",1,43,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,\"Lighter - Black\",\"Comes in black. Designed in the Smokanagan, this will help you stay lit fam. Anyone spare some darts?\",\"lighter2.png\",2,0,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (30.00,\"Poster\",\"30cm x 28cm paper poster. Place on your ceiling so you can lay in bed and watch as the stars of his eyes glitter in the night.\",\"poster_300.png\",2,101,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (250.00,\"Record Player\",\"Very high quality! Each record player has been quality tested by 2Kyle himself. The case is construcyed of reinforced steel. Weight: 50kg. No embedded speakers, has AUX output.\",\"record_player.png\",2,300,3);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (20.00,\"Baseball Shirt\",\"100% Cotton. Wear the face of the famous rapper proudly! Great gift for family and friends.\",\"shirt_bball.png\",2,9,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - Blue\",\"Wow what a fantastic colour!! Limited time offer. Order soon, while quantities last! Very nice large image of the legend''s face.\",\"shirt_blue.png\",2,11,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - White\",\"Smaller face logo present on the front of the shirt. Nice little circle around it. Great photoshop job Brittany. Wow I am tired. Goodnight.\",\"shirt_face.png\",2,0,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - Black (Ladies)\",\"This one is for the ladies out there. Wow look at this wacky design! His face looks pretty messed up but that is alright. Perfect gift for Halloween. 100% spandex construction. For a limited time, ships with a bottle opener.\",\"shirt_ladies.png\",2,99,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - Red\",\"Any gender can wear this shirt! It comes in a beautiful red colour and includes a very large and prominent picture of Kyle''s face on the front. Enjoy any time of year!\",\"shirt_red.png\",1,56,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - Text\",\"Don''t want a picture of Kyle on your shirt for whatever reason? Look no further. There is only letters and numbers on this shirt! Woohoo.\",\"shirt_text.png\",1,0,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (15.00,\"T-Shirt - Face\",\"Comes in white. 100% Hemp fibre. Comes with marijuana bits stuck to the cloth and organic pit stains.\",\"shirt_white.png\",1,69,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (5.00,\"Stickers (3)\",\"Includes 3 stickers. One black, one blue, and one Boston University Red TM. These stickers have super strong adhesive and will stick to anything. Perfect for sticking to the back of your ride so people know you are the real deal.\",\"stickers.png\",1,90,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (30.00,\"Long Sleeve Sweater\",\"Grey sweater. 100% hemp and marijuana. Smells super dank. Look at the picture! There is stuff on the front and on the back! Wow, neato.\",\"sweater_300.png\",2,77,1);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (10.00,\"Tote Bag\",\"Carry all of your other 2Kyle16 merchandise in this limited time offer tan tote bag. 100% paper construction produced by Belize. Fast Shipping! 2Kyle out.\",\"tote_bagedit.png\",2,61,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (50.00,\"Vape - Grey\",\"Want to rip some fat clouds on a budget? This is the vape for you. Strong, durable construction. Does not include vape juice. Analog clock on the side for timing your wicked rips.\",\"vape_1.png\",2,4,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (100.00,\"Vape - Black\",\"Stealthy? Classy? 450 degrees Fahrenheit? What could be? Nothing other than the Ultimate Vape TM. Guranteed to impress.\",\"vape_2.png\",1,26,2);
					INSERT INTO Product(cost,pname,description,image,wid,inventory,categoryID) VALUES (100000.00,\"Vapetastic Premium Edition\",\"ARE YOU READY TO RIP THE FATTEST CLOUD POSSIBLE??? This vape is made from solid gold and comes with cartridges of Kyle''s sweat so you can enjoy both the man AND the vape. Stay smokey my friends.\",\"vape_3.png\",1,56,2);
					INSERT INTO Product(cost, pname, description, image, wid, inventory, categoryID) VALUES (10, \"Colin's Basement - 01/15/17\", \"Secret show in Colin\'s basement to kick off the new album.\", 'ticket_colin.png', 1, 28, 4);
					INSERT INTO Product(cost, pname, description, image, wid, inventory, categoryID) VALUES (25, \"Level - 02/16/17\", \"It's at level!\", 'ticket_level.png', 1, 100, 4);
					INSERT INTO Product(cost, pname, description, image, wid, inventory, categoryID) VALUES (50, \"Rose's - 03/29/17\", \"Maria's Birthday bash!!\", 'ticket_roses.png', 1, 40, 4);
					INSERT INTO Product(cost, pname, description, image, wid, inventory, categoryID) VALUES (25, \"Sapphire - 04/06/17\", \"Ooohh Sapphire\", 'ticket_sapphire.png', 1, 200, 4);
					INSERT INTO Product(cost, pname, description, image, wid, inventory, categoryID) VALUES (15, \"The Well - 05/20/17\", \"Summer show at the Well\", 'ticket_well.png', 1, 15, 4);";
					
				if($conn->multi_query($sql) == TRUE) {
					echo "<script trype='text/javascript'>alert('New records created successfully!');</script>";
				} else {
					echo "<script trype='text/javascript'>alert('Error inserting into database.');</script>";
					echo "Error: " . $sql . "<br>" . $conn->error;
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