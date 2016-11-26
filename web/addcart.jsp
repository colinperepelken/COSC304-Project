<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> itemList = (HashMap<String, ArrayList<Object>>) session.getAttribute("itemList");

if (itemList == null)
{	// No products currently in list.  Create a list.
	itemList = new HashMap<String, ArrayList<Object>>();
}

// Add new product selected
// Get product information
String pid = request.getParameter("pid");
String name = request.getParameter("name");
String price = request.getParameter("price");
Integer quantity = new Integer(1);

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

// Update quantity if add same item to order again
if (itemList.containsKey(id))
{	product = (ArrayList<Object>) itemList.get(id);
	int curAmount = ((Integer) product.get(3)).intValue();
	product.set(3, new Integer(curAmount+1));
}
else
	itemList.put(id,product);

session.setAttribute("itemList", itemList);
%>
<jsp:forward page="showcart.jsp" />