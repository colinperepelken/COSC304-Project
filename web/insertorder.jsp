<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="connection.jsp" %>


<html>
<head>
	<title>Checkout</title>
	<link href = "2kyle16.css" rel ="stylesheet" type ="text/css">
	<link rel="icon" href="images/favicon.png">
	<script>
	</script>
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<%
try {
	
	getConnection();
	//get parameters
	Integer cid = Integer.parseInt((String)session.getAttribute("cid"));
	String shipAddress = request.getParameter("street");
	String shipType = request.getParameter("shipType");
	String payType = request.getParameter("payType");
	double shipCost = Double.parseDouble(request.getParameter("shipCost"));
	double cartTotal = Double.parseDouble(request.getParameter("cartTotal"));
	double payCost = Double.parseDouble(request.getParameter("grandTotal"));
	String province = request.getParameter("region");
	String country = request.getParameter("country");
	String city = request.getParameter("city");

	
	

	HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");	
	PreparedStatement pstmt = null;
	if(itemList==null){
		out.println("<h1>2Kyle16 thanks you for your order!</h1>");

	}
	else{
		
	

		String sql = "INSERT INTO CustomerOrder(cid) VALUES (?)";
		pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		pstmt.setInt(1, cid.intValue());
		pstmt.executeUpdate();
		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		double total = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = itemList.entrySet().iterator();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		//TODO: insert into hasproduct
		
		while (iterator.hasNext()){ 
			//update HasProduct table to include order
			pstmt = con.prepareStatement("INSERT INTO HasProduct VALUES (?, ?, ?)");
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			int pid = Integer.parseInt((String)product.get(0));
			int qty = ((Integer)product.get(3)).intValue();
			pstmt.setInt(1, orderId);
			pstmt.setInt(2, pid);
			pstmt.setInt(3, qty);
			pstmt.executeUpdate();
			//update values in warehouse to reflect ordered product
			pstmt = con.prepareStatement("UPDATE Product SET inventory = inventory - ? WHERE pid = ?");
			pstmt.setInt(1, qty);
			pstmt.setInt(2, pid);
			pstmt.executeUpdate();
			
		}
		//insert into customer order
		sql = "UPDATE CustomerOrder SET orderDate=?, street=?,city=?,province=?,country=?,hasShipped=?,cartTotal=?,shippingType=?,shippingCost=?,paymentType=?,paymentCost=? WHERE oid = ? AND cid = ?";
		pstmt = con.prepareStatement(sql);
		//get current date
		java.util.Date orderDate = new java.util.Date(); 
		java.sql.Date sqlDate = new java.sql.Date(orderDate.getTime());	
		boolean hasShipped = false;
		//set preparestatement vars
		pstmt.setDate(1,sqlDate);
		pstmt.setString(2,shipAddress);
		pstmt.setString(3,city);
		pstmt.setString(4,province);
		pstmt.setString(5,country);
		pstmt.setBoolean(6,hasShipped);
		pstmt.setDouble(7,cartTotal);
		pstmt.setString(8,shipType);
		pstmt.setDouble(9,shipCost);
		pstmt.setString(10,payType);
		pstmt.setDouble(11,payCost);
		pstmt.setInt(12,orderId);
		pstmt.setInt(13,cid);
		//record order in db
		pstmt.executeUpdate();
		session.setAttribute("itemList", null);  
		out.println("<h1><b>2Kyle16 thanks you for your order!</b></h1>");
	}
}catch(SQLException e){
	out.println(e);
}finally{
	closeConnection();
}
	
%>                       				

</center>
</div></div>

<div id = "footer"><br><br> &copy; 2016 2Kyle16 inc. <br>Site by Brittany Miller, Maria Guenter, Colin Bernard, Zachery Grafton and Mackenzie Salloum</div>
</body>
</html>