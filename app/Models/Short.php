<?php

class Short {

	public $url;
	public $clicks;

	public function addhttp($url) {
		if (!preg_match("~^(?:f|ht)tps?://~i", $url)) {
			$url = "http://" . $url;
		}
		return $url;
	}

	public function Build($name, $data){
		$this->name = $name;
		$this->url = $this->addhttp($data["url"]);
		$this->clicks = (@$data["clicks"] ? $data["clicks"] : 0);
	}

	public function Visit(){
		header("Location: ".$this->url);
		if($this->name == "default") return;
		$db = ShortControlDatabase::Instance()->GetDatabase();
		$allConfigs = $db->getConfig();
		@$allConfigs[$this->name]["clicks"] ++;
		$db->setConfig($allConfigs)->Save();
	}

	public function GetArray(){
		return array("url" => $this->url, "clicks" => $this->clicks);
	}

}

class ShortControl {

	public function __construct(){
	}

	public function GetShort($short_name){
		$arr_obj = @ShortControlDatabase::Instance()->GetDatabase()->getConfig($short_name);
		if(count($arr_obj)==0 && $short_name != "default")
			return $this->GetShort("default");
		$short = new Short();
		$short->Build($short_name, $arr_obj);
		return $short;
	}

	public function GetAllShorts(){
		$all = array();
		$arr_all = ShortControlDatabase::Instance()->GetDatabase()->getConfig();
		foreach ($arr_all as $name => $data) {
			$s = new Short();
			$s->Build($name, $data);
			array_push($all, $s);
		}
		return $all;
	}

	public function Add($short){
		$db = ShortControlDatabase::Instance()->GetDatabase();
		$arr_all = $db->getConfig();
		$arr_all[$short->name] = $short->GetArray();
		$arr_all[$short->name]["clicks"] = "0";
		$db->setConfig($arr_all);
		$db->Save();
	}

	public function Remove($short_name){
		$db = ShortControlDatabase::Instance()->GetDatabase();
		$arr_all = $db->getConfig();
		unset($arr_all[$short_name]);
		$db->setConfig($arr_all);
		$db->Save();

	}


}

class ShortControlDatabase {

	protected static $databasePath;
	protected static $databaseFile = "novo.short_url.magratheaDB";

	protected static $inst = null;
	private function __construct(){
		self::$databasePath = MagratheaConfig::Instance()->GetFromDefault("site_path")."/../database";
	}

	public static function Instance(){
		if(self::$inst == null) {
			self::$inst = new ShortControlDatabase();
		}
		return self::$inst;
	}

	public static function GetDatabase(){
		$db = new MagratheaConfigFile();
		$db->setPath(self::$databasePath)
			->setFile(self::$databaseFile);
		return $db;
	}

}


?>