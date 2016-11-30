<%
	// log out
	session.removeAttribute("cid");
	session.removeAttribute("username");
	session.removeAttribute("isAdmin");
	
	// go back to prev page
	String last_page = request.getParameter("last");
	// re direct user to page they were at before logging out
	response.sendRedirect(last_page);
%>