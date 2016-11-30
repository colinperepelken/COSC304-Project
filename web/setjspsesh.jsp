<%
	// get parameters
	String cid = request.getParameter("cid");
	String username = request.getParameter("username");
	String isAdmin = request.getParameter("admin");
	String last_page = request.getParameter("last");
	
	// set jsp session variables
	session.setAttribute("cid", cid);
	session.setAttribute("username", username);
	session.setAttribute("isAdmin", isAdmin);
	
	// re direct user to page they were at before logging in
	response.sendRedirect(last_page);
%>