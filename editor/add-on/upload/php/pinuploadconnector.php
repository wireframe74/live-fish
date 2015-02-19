<?php
include("pinupload.class.php");
$pu = new pinUpload();

$action = ($_REQUEST['action'])? $_REQUEST['action']:$_GET['action'];
switch ($action) {
  case "remove":
	  if(check($_REQUEST["path"]) == true) {
      $pu->deleteFileFolder($_REQUEST["path"]);
    }
    break;
  case "rename":
	  if(check($_REQUEST["newpath"]) == true) {
      $pu->renameFileFolder($_REQUEST["oldpath"], $_REQUEST["newpath"]);
    }
    break;
  case "newfolder":
	  if(check($_REQUEST["path"]) == true) {
      $pu->newFolder($_REQUEST["path"]);
    }
    break;
  case "parsedir":
	  if(check($_REQUEST["dir"]) == true) {
      header( 'Cache-Control: no-cache' );
      header( 'Pragma: no-cache' );
      header( 'content-type: text/xml' );
      echo $pu->parseDir($_REQUEST["dir"],'',$_REQUEST["displayfiles"]);
    }
    break;
  case "upload":
	  if(check($_REQUEST["dir"]) == true) {
      $pu->uploadFiles($_FILES, $_REQUEST["dir"],$_REQUEST["imagesize"]);
    }
    break;
  case "imagesize":
    $pu->getImageSize($_REQUEST["path"]);
    break;
  case "getMaxFileSize":
    $pu->getMaxFileSize();
    break;
}

function readLimitPath($path)
{
  //load the parser and document
	$xmlDoc = new DOMDocument();
	$xmlDoc->load($path);
	$paths = $xmlDoc->getElementsByTagName('limitpath');
	
  $allPaths = array();
	//loop through the languages and get the required info
	foreach ($paths as $path) {
		$value = $path->getAttribute('value');
		$allPaths[] = strtr(strtolower($value),"/","\\");
	}
	return $allPaths;
}	

function check($path)
{
  $filePath = $_SERVER['SCRIPT_FILENAME'];
  $filePath = strtr($filePath,"/","\\");
  $pos = strpos($filePath, '\\editor\\');
  $filePath = substr($filePath, 0, $pos);
  $curPath = strtolower($path);
  $curPath = strtr($curPath,"/","\\");
  if( strpos($curPath,'..\\') === false && strpos($curPath,'../') === false) {
  } else {
    return false;
  }

  //$allPaths = array('d:\\data\\');
  $allPaths = readLimitPath($filePath . '\editor\config\security.xml');
	$isAllowed = false;

	for ($i = 0; $i < count($allPaths); $i++) {
	  $pathElement = $allPaths[$i];
    $pos = strpos($curPath,$pathElement);
	  if($pos === false) {
	  } else {
	    if($pos == 0) {
  	    $isAllowed = true;
  	  }
	  }
	}
	
	return $isAllowed; 
}


?>
