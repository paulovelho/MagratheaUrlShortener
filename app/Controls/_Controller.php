<?php
class BaseControl extends MagratheaController {
	public static function Go404(){
		return;
	}
	public static function DisplayError($error){
		echo $error->getMessage();
		return;
	}
}
?>
