<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>

<HTML>
<HEAD>
<TITLE>Shopping Cart</TITLE>
</HEAD>
<BODY>

<script>
function update(newpid, newqty)
{
	window.location="showcart.jsp?update="+newpid+"&newqty="+newqty;
}
</script>
<FORM name="form1">

<%
// Get the current list of products
HashMap itemList = (HashMap) session.getAttribute("itemList");
ArrayList product = new ArrayList();
String pid = request.getParameter("delete");
String update = request.getParameter("update");
String newqty = request.getParameter("newqty");

// check if shopping cart is empty
if (itemList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	itemList = new HashMap();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	
	// if pid not null, then user is trying to remove that item from the shopping cart
	if(pid != null && (!pid.equals(""))) {
		if(itemList.containsKey(pid)) {
			itemList.remove(pid);
		}
	}
	
	// if update isn't null, the user is trying to update the quantity
	if(update != null && (!update.equals(""))) {
		if (itemList.containsKey(update)) { // find item in shopping cart
			product = (ArrayList) itemList.get(update);
			product.set(3, (new Integer(newqty))); // change quantity to new quantity
		}
		else {
			itemList.put(pid,product);
		}
	}

	// print out HTML to print out the shopping cart
	out.println("<H1>Your Shopping Cart</H1>");
	out.print("<TABLE><TR><TH>Product pid</TH><TH>Product Name</TH><TH>Quantity</TH>");
	out.println("<TH>Price</TH><TH>Subtotal</TH><TH></TH><TH></TH></TR>");

	int count = 0;
	double total =0;
	// iterate through all items in the shopping cart
	Iterator iterator = itemList.entrySet().iterator();
	while (iterator.hasNext()) {
		count++;
		Map.Entry entry = (Map.Entry)(iterator.next());
		product = (ArrayList) entry.getValue();
		// read in values for that product pid
		out.print("<TR><TD>"+product.get(0)+"</TD>");
		out.print("<TD>"+product.get(1)+"</TD>");

		out.print("<TD ALIGN=CENTER><INPUT TYPE=\"text\" name=\"newqty"+count+"\" size=\"3\" value=\""
			+product.get(3)+"\"></TD>");
		double pr = Double.parseDouble( (String) product.get(2));
		int qty = ( (Integer)product.get(3)).intValue();
		
		// print out values for that product from shopping cart
		out.print("<TD ALIGN=RIGHT>"+currFormat.format(pr)+"</TD>");
		out.print("<TD ALIGN=RIGHT>"+currFormat.format(pr*qty)+"</TD>");
		// allow the customer to delete items from their shopping cart by clicking here
		out.println("<TD>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF=\"showcart.jsp?delete="
			+product.get(0)+"\">Remove Item from Cart</A></TD>");
		// allow customer to change quantities for a product in their shopping cart
		out.println("<TD>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=BUTTON OnClick=\"update("
			+product.get(0)+", document.form1.newqty"+count+".value)\" VALUE=\"Update Quantity\">");
		out.println("</TR>");
		// keep a running total for all items ordered
		total = total +pr*qty;
	}
	// print out order total
	out.println("<TR><TD COLSPAN=4 ALIGN=RIGHT><B>Order Total</B></TD>"
			+"<TD ALIGN=RIGHT>"+currFormat.format(total)+"</TD></TR>");
	out.println("</TABLE>");
	//give user option to check out
	out.println("<H2><A HREF=\"checkout.jsp\">Check Out</A></H2>");
}
// set the shopping cart
session.setAttribute("itemList", itemList);
// give the customer the option to add more items to their shopping cart
%>
<H2><A HREF="listproducts.php">Continue Shopping</A></H2>
</FORM>
</BODY>
</HTML> 



