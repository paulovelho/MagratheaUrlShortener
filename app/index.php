<?php

	include("inc/global.php");

	MagratheaModel::IncludeAllModels();
	$shorts = new ShortControl();
	$all = $shorts->GetAllShorts();

	p_r($all);

?>
