<?php

include_once('pinStyle.class.php');

  $pinStyle = new pinStyle;
  $pinStyle->setLanguage($_GET["language"]);
  $pinStyle->setDesign($_GET["design"]);
  $pinStyle->setTechnology($_GET["tech"]);

  if(isset($_GET["url"]))
    $pinStyle->setUrl($_GET["url"]);
  if(isset($_GET["path"]))
    $pinStyle->setPath($_GET["path"]);
  if(isset($_GET["file"]))
    $pinStyle->setFile($_GET["file"]);

  //-----------------------------------------------
  // LICENSEKEY
  //-----------------------------------------------
  $pinStyle->setLicenseKey("<-- here -->");

  $pinStyle->create();

?>
