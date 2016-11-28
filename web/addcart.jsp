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
String pname = request.getParameter("pname");
String cost = request.getParameter("cost");
Integer quantity = new Integer(Integer.parseInt(request.getParameter("qty")));

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(pid);
product.add(pname);
product.add(cost);
product.add(quantity);

// Update quantity if add same item to order again
if (itemList.containsKey(pid))
{	product = (ArrayList<Object>) itemList.get(pid);
	int curAmount = ((Integer) product.get(3)).intValue();
	product.set(3, new Integer(curAmount+1));
}
else
	itemList.put(pid,product);

session.setAttribute("itemList", itemList);

%>
<jsp:forward page="showcart.jsp" />