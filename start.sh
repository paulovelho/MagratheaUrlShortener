#!/bin/bash
clear

echo -e "Nice to have you here! Welcome to Magrathea!\n"
echo -e "We are now going through the proccess of creating the project! Let's go!\n\n"
sleep 1

echo -e "\n\nCreating folder structure... "
mkdir "Admin"
mkdir "Admin/css"
mkdir "app"
cd app
	mkdir "Controls"
	mkdir "css"
	mkdir "css/_compressed"
	chmod 777 css/_compressed
	mkdir "images"
	mkdir "images/medias"
	chmod 777 images/medias
	mkdir "images/medias/generated"
	chmod 777 images/medias/generated
	mkdir "inc"
	mkdir "javascript"
	mkdir "javascript/_compressed"
	chmod 777 javascript/_compressed
	mkdir "Models"
	chmod 777 Models
	mkdir "Models/Base"
	chmod 777 Models/Base
	mkdir "plugins"
	chmod 777 plugins
	mkdir "Views"
	mkdir "Views/_cache"
	chmod 777 Views/_cache
	mkdir "Views/_compiled"
	chmod 777 Views/_compiled
	mkdir "Views/configs"
	cd ..
mkdir "configs"
chmod 777 configs
mkdir "database"
mkdir "logs"
chmod 777 logs
mkdir "Tests"
echo -e "DONE!\n"
sleep 1


echo -e "\nIndex.htmling everything... "
cat <<EOF >index.html
Magrathea - by Platypus Technology
EOF
cp index.html app/css/
cp index.html app/javascript/
cp index.html app/Models/
cp index.html app/Models/Base
cp index.html app/plugins/
cp index.html config/
cp index.html database/
echo -e "DONE!\n"
sleep 1



echo -e "\nSetting up initial config... "
PWD=$(pwd)
cat <<EOF >configs/magrathea.conf
# generated by Magrathea from start.sh
[general]
	use_environment = "dev"
	time_zone = "America/Sao_Paulo"

[dev]
	db_host = "127.0.0.1"
	db_name = "database"
	db_user = "root"
	db_pass = "password"
	site_path = "$PWD/app"
	magrathea_path = "$PWD/Magrathea"
	compress_js = "false"
	compress_css = "false"
	url = "http://localhost.com"

[prod]
	db_host = "127.0.0.1"
	db_name = "database"
	db_user = "root"
	db_pass = "password"
	site_path = "prod_path/app"
	magrathea_path = "prod_path/Magrathea"
	compress_js = "false"
	compress_css = "false"
	url = "http://localhost.com"
EOF
cp configs/magrathea.conf configs/magrathea.conf.sample
cat <<EOF >app/Views/configs/site.conf
#global:
siteName="Magrathea New Project"
siteDomain="" 
EOF
cat <<EOF >app/Views/_cache/readme.txt
this folder is for use of Smarty framework!
EOF
cat <<EOF >app/Views/_compiled/readme.txt
this folder is for use of Smarty framework!
EOF
echo -e "DONE!\n"
sleep 1


echo -e "\nBasic code (just helping you a little bit more!)... "
cat <<EOF >app/inc/global.php
<?php
	// start session:
	session_start();
 
	// error reporting level:
	error_reporting(E_ALL ^ E_STRICT);

	include("config.php");
 
	// looooooaaaadddiiiiiinnnnnnggggg.....
	include(\$magrathea_path."/LOAD.php");
 
	// initialize Smarty. eh.. I don't think there is a more beautiful way of doing this
	\$Smarty = new Smarty;
	\$Smarty->template_dir = \$site_path."/app/Views/";
	\$Smarty->compile_dir  = \$site_path."/app/Views/_compiled";
	\$Smarty->config_dir   = \$site_path."/app/Views/configs";
	\$Smarty->cache_dir    = \$site_path."/app/Views/_cache";
	\$Smarty->error_reporting = E_ALL & ~E_NOTICE; 
	\$Smarty->configLoad("site.conf");

	// initialize the MagratheaView and sets it to Smarty	
	\$Smarty->assign("View", MagratheaView::Instance());
 
	// for printing the paths of your css and javascript (that will be included in the index.php)
	MagratheaView::Instance()->IsRelativePath(false);
 
	// debugging settings:
	// options: dev; debug; log; none;
	MagratheaDebugger::Instance()->SetType(MagratheaDebugger::LOG)->LogQueries(false);
?>
EOF
cat <<EOF >app/inc/config.php
<?php

	// set the path of magrathea framework (this way is possible to have only one instance of the framework for multiple projects)
	\$magrathea_path = "path/to/MagratheaPHP/Magrathea";
	// set the path of your site (you can set this manually as well)
	\$site_path = __DIR__."/../..";

?>
EOF
cp app/inc/config.php app/inc/config.php.sample
cat <<EOF >app/index.php
<?php
	include("inc/global.php");
	echo "Welcome to Magrathea!";

	MagratheaController::IncludeAllControllers();
	MagratheaModel::IncludeAllModels();

	// css & javascript
	try{
		MagratheaView::Instance()
			->IncludeCSS("css/style.css")
			->IncludeJavascript("javascript/scripts.js");
	} catch(Exception \$ex){
		BaseControl::DisplayError(\$ex);
	}
	
	MagratheaRoute::Instance()
		->Route(\$control, \$action, \$params);

	try{
		// looooooaad!
		MagratheaController::Load(\$control, \$action, \$params);
	} catch (Exception \$ex) {
		BaseControl::Go404();
	}
?>
EOF
cat <<EOF >app/Controls/_Controller.php
<?php
class BaseControl extends MagratheaController {
	public static function Go404(){
		return;
	}
	public static function DisplayError(\$error){
		echo \$error->getMessage();
		return;
	}
}
?>
EOF
cat <<EOF >app/.htaccess
RewriteEngine On
 
<IfModule mod_rewrite.c>
	RewriteEngine On
	RewriteBase /
 
	# Do not do anything for already existing files and folders
	RewriteCond %{REQUEST_FILENAME} -f [OR]
	RewriteCond %{REQUEST_FILENAME} -d
	RewriteRule .+ - [L]
 
	#Respect this rules for redirecting:
	RewriteRule ^([a-zA-Z0-9_-]+)/([a-zA-Z0-9_-]+)/(.*)\$ index.php?magrathea_control=\$1&magrathea_action=\$2&magrathea_params=\$3 [QSA,L]
	RewriteRule ^([a-zA-Z0-9_-]+)/(.*)\$ index.php?magrathea_control=\$1&magrathea_action=\$2 [QSA,L]
	RewriteRule ^(.*)\$ index.php?magrathea_control=\$1 [QSA,L]
 
</IfModule>
EOF

echo -e "\nadmin.php... "
cat <<EOF >app/admin.php
<?php
	include("inc/global.php");
	include(\$magrathea_path."/MagratheaAdmin.php"); // \$magrathea_path should already be declared

	\$admin = new MagratheaAdmin(); // adds the admin file
	\$admin->Load(); // load!

?>
EOF


echo -e "\n.gitignore file... "
cat <<EOF >.gitignore
configs/magrathea.conf
app/inc/config.php
_cache/
_compiled/
_compressed/
*_compressed.js
*_compressed.css
app/plugins/
logs
medias
EOF


echo -e "Everything was installed successfully!\n\n Now, start coding! =)\n\n"


