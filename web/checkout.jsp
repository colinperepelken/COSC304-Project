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
	<script>
	function printState(country) {
		var stateSelect = '';
		if(country == "United States"){
			stateSelect = '<select name="region" id="region" form="shipping" onchange="set(this.value)">'+
			'<option value="AK">AK-Alaska</option>'+
			'<option value="AL">AL-Alabama</option>'+
			'<option value="AR">AR-Arkansas</option>'+
			'<option value="AZ">AZ-Arizona</option>'+
			'<option value="CA">CA-California</option>'+
			'<option value="CO">CO-Colorado</option>'+
			'<option value="CT">CT-Connecticut</option>'+
			'<option value="DC">DC-District of Columbia</option>'+
			'<option value="DE">DE-Delaware</option>'+
			'<option value="FL">FL-Florida</option>'+
			'<option value="GA">GA-Georgia</option>'+
			'<option value="HI">HI-Hawaii</option>'+
			'<option value="IA">IA-Iowa</option>'+
			'<option value="ID">ID-Idaho</option>'+
			'<option value="IL">IL-Illinois</option>'+
			'<option value="IN">IN-Indiana</option>'+
			'<option value="KS">KS-Kansas</option>'+
			'<option value="KY">KY-Kentucky</option>'+
			'<option value="LA">LA-Louisiana</option>'+
			'<option value="MA">MA-Massachusetts</option>'+
			'<option value="MD">MD-Maryland</option>'+
			'<option value="ME">ME-Maine</option>'+
			'<option value="MI">MI-Michigan</option>'+
			'<option value="MN">MN-Minnesota</option>'+
			'<option value="MO">MO-Missouri</option>'+
			'<option value="MS">MS-Mississippi</option>'+
			'<option value="MT">MT-Montana</option>'+
			'<option value="NC">NC-North Carolina</option>'+
			'<option value="ND">ND-North Dakota</option>'+
			'<option value="NE">NE-Nebraska</option>'+
			'<option value="NH">NH-New Hampshire</option>'+
			'<option value="NJ">NJ-New Jersey</option>'+
			'<option value="NM">NM-New Mexico</option>'+
			'<option value="NV">NV-Nevada</option>'+
			'<option value="NY">NY-New York</option>'+
			'<option value="OH">OH-Ohio</option>'+
			'<option value="OK">OK-Oklahoma</option>'+
			'<option value="OR">OR-Oregon</option>'+
			'<option value="PA">PA-Pennsylvania</option>'+
			'<option value="RI">RI-Rhode Island</option>'+
			'<option value="SC">SC-South Carolina</option>'+
			'<option value="SD">SD-South Dakota</option>'+
			'<option value="TN">TN-Tennessee</option>'+
			'<option value="TX">TX-Texas</option>'+
			'<option value="UT">UT-Utah</option>'+
			'<option value="VA">VA-Virginia</option>'+
			'<option value="VT">VT-Vermont</option>'+
			'<option value="WA">WA-Washington</option>'+
			'<option value="WI">WI-Wisconsin</option>'+
			'<option value="WV">WV-West Virginia</option>'+
			'<option value="WY">WY-Wyoming</option>'+
			'</select>';
		}
		else if (country == 'Canada') {
			stateSelect = '<select name="region" id="region" form="shipping" onchange="set(this.value)">' +
			'<option value="AB">AB-Alberta</option>' +
			'<option value="BC">BC-British Columbia</option>' +
			'<option value="MB">MB-Manitoba</option>'+
			'<option value="NB">NB-New Brunswick</option>'+
			'<option value="NL">NL-Newfoundland and Labrador</option>'+
			'<option value="NT">NT-Northwest Territories</option>'+
			'<option value="NS">NS-Nova Scotia</option>'+
			'<option value="NU">NU-Nunavut</option>'+
			'<option value="ON">ON-Ontario</option>'+
			'<option value="PE">PE-Prince Edward Island</option>'+
			'<option value="QC">QC-Quebec</option>'+
			'<option value="SK">SK-Saskatchewan</option>'+
			'<option value="YT">YT-Yukon</option>'+
			'</select>';
		}
		else {
			stateSelect = '<select name="region" id="region" disabled="disable">'+
			'<option value="Other">Select Province/State</option>'+
			'</select>';
		}
		document.getElementById('stateSelect').innerHTML = stateSelect;
		
	}
	function set(region){
		//document.getElementById('province').value= region;
	}

	</script>
</head>
<body>
<div class = "mainDiv"><div id ="header"><img src="images/header.png"><br><font size="5.5"><a href="home.html">HOME </a>  <a href="listproducts.php">MERCH</a> <a href="listtickets.php">TICKETS</a>  <a href="showcart.jsp">CART</a> <a href="login.php">LOGIN</a> </font></div>
<div class = "content">
<center>
<div style="float: left;">
<%
if(session.getAttribute("username") != null) {
	String username = (String)session.getAttribute("username");
	out.println("Logged in as "+username+" <span><a href=\"logout.php\">Logout</a></span>");
} else {
	out.println("Logged in as Guest");
}
%>
</div>
<br><br>
<%
try {
	getConnection();
	if(session.getAttribute("username")!=null){
		HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");	
		PreparedStatement pstmt = null;
		out.println("<h1>Your Order Summary</h1>");
		out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

		double total = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = itemList.entrySet().iterator();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
					
		while (iterator.hasNext())//print out cart info
		{ 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			String productId = (String) product.get(0);
			out.print("<tr><td>"+productId+"</td>");
			out.print("<td>"+product.get(1)+"</td>");
			out.print("<td align=\"center\">"+product.get(3)+"</td>");
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
			out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
			out.println("</tr>");
			total = total +pr*qty;
		}
		out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td><td align=\"right\">"+currFormat.format(total)+"</td></tr>");
		
		pstmt = con.prepareStatement("SELECT * FROM ShippingOption");
		ResultSet ships = pstmt.executeQuery();
		pstmt = con.prepareStatement("SELECT * FROM PaymentMethod");
		ResultSet pays = pstmt.executeQuery();
		
		out.println("<form id='shipping' action='finalize.jsp'>");
		out.println("<tr><td><br><br>Enter your shipping address:<br><br>");
		out.println("<tr><td align=\"left\">Country:</td></tr><tr><td align=\"left\"><select name='country' id='country' onchange='printState(this.value)'>");
		out.println("<option value=\"Select\">Select a Country...</option>");
		out.println("<option value=\"Canada\">Canada</option>");
		out.println("<option value=\"United States\">United States</option>");
		out.println("</select></td></tr>");
		
		out.println("<tr><td align=\"left\">State/Province:</td></tr><tr><td align=\"left\"><p id=\"stateSelect\"><select name=\"region\" id=\"region\" disabled=\"disabled\"><option value=\"Other\">Select Region...</option></select></p>");
		//out.println("<input type='hidden' name='province'>");


		
		out.println("Street:<br><input type='text' name='address'><br>");
		out.println("City:<br><input type='text' name='city'><br><br></td></tr>");
		
		
		
		//TODO: validate country/ region selection

		// prints radio buttons for shipping and payment
		out.println("<tr><td align=\"left\">Shipping:<br>");
		while(ships.next()){
			String type = ships.getString(1);
			String cost = currFormat.format(ships.getDouble(2));
			out.println("<input name='shipType' type='radio' value=\""+ type +"\">" + type + " - " + cost + "<br>");
		}
		out.println("</td><td align=\"left\">Payment Type:<br>");
		while(pays.next()){
			String type = pays.getString(1);
			out.println("<input name='payType' type='radio' value=\""+ type +"\">" + type+"<br>");
		}
		
		out.println("</td></table>");
		out.println("<br><br><input id='submit' type='submit' value='Confirm'>");
		out.println("</form>");

		//button to go to next page, where info is then entered into database
		
	}else{
		response.sendRedirect("login.php");//must be logged in to checkout
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
