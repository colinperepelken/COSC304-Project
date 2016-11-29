<?php
	session_start();
	// clear session variables
	unset($_SESSION["cid"]);
	unset($_SESSION["username"]);
	// re direct to previous page
	$last_page = $_SERVER['HTTP_REFERER'];
	header("Location: unsetjspsesh.jsp?last=$last_page"); // log out of jsp session as well
?>