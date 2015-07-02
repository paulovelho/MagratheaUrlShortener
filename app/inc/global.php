<?php
	// start session:
	session_start();
 
	// error reporting level:
	error_reporting(E_ALL ^ E_STRICT);

	include("config.php");
 
	// looooooaaaadddiiiiiinnnnnnggggg.....
	include($magrathea_path."/LOAD.php");
 
	// initialize Smarty. eh.. I don't think there is a more beautiful way of doing this
	$Smarty = new Smarty;
	$Smarty->template_dir = $site_path."/app/Views/";
	$Smarty->compile_dir  = $site_path."/app/Views/_compiled";
	$Smarty->config_dir   = $site_path."/app/Views/configs";
	$Smarty->cache_dir    = $site_path."/app/Views/_cache";
	$Smarty->error_reporting = E_ALL & ~E_NOTICE; 
	$Smarty->configLoad("site.conf");

	// initialize the MagratheaView and sets it to Smarty	
	$Smarty->assign("View", MagratheaView::Instance());
 
	// for printing the paths of your css and javascript (that will be included in the index.php)
	MagratheaView::Instance()->IsRelativePath(false);
 
	// debugging settings:
	// options: dev; debug; log; none;
	MagratheaDebugger::Instance()->SetType(MagratheaDebugger::DEV)->LogQueries(false);
?>
