<?php
	include("inc/global.php");

	MagratheaModel::IncludeAllModels();

	$route = $_GET["magrathea_control"];

	$shorts = new ShortControl();
	$short = $shorts->GetShort($route);

	$short->Visit();
?>
