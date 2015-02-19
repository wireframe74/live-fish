/*
Modification or decryption of this file is strictly forbidden - Pintexx GmbH
*/
var spellLanguage="ENGLISH";var spellDictFile="";var spellUserDictFile="";var __spellPageUrl="";var spellLicenseKey="";var rsTCIntrapidSpellWebLauncher=null;var spellBoot="";var globalSpellSuggestions="";var globalSpellAdd=false;function editSpell(value){if(globalSpellMode==0){spellOnSpell();}else{globalSpellByType=value;if(globalSpellByType){editSpellByType();}else{editSpellClear();RaiseInternalEvent("SPELLOFF");}}}function spellOnSpell(){if(globalSpellPage.toLowerCase().indexOf("http")==0)__spellPageUrl=globalSpellPage;else __spellPageUrl=__editGetEditorUrl()+globalSpellPage;popUpCheckSpelling("rsTCIntrapidSpellWebLauncher");}function spellSetLanguage(lng){if(lng=="DE"){spellLanguage="GERMAN";return;}if(lng=="ES"){spellLanguage="SPANISH";return;}if(lng=="NL"){spellLanguage="DUTCH";return;}if(lng=="FR"){spellLanguage="FRENCH";return;}if(lng=="EN"){spellLanguage="ENGLISH";return;}spellLanguage="ENGLISH";}function spellSetDictFile(path){spellDictFile=path;}function spellSetUserDictFile(path){spellUserDictFile=path;}function spellSetLicense(license){spellLicenseKey=license;}function RSCustomInterface(){this.getText=getText;this.setText=setText;function getText(){var html=editGetDocument().body.innerHTML;return html;}function setText(text){editSetBodyHtml(text);}}function escQuotes(text){var rx=new RegExp("\"","g");return text.replace(rx,"&#34;");}function escEntities(text){var rx=new RegExp("&","g");return text.replace(rx,"&amp;");}function popUpCheckSpelling(interfaceObjectName){var useUserDict="false";if(spellUserDictFile!="")useUserDict="true";if(spellDictFile=="" && spellUserDictFile==""){alert("Warning: There is no dictionary path set. Action aborted !");return;}var message="";if(language=="DE")message="Dokument pr&uuml;fen...";else message="...";var spellBoot="<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body onLoad='document.forms[0].submit();'><font face='arial, helvetica' size=2>"+message+"</font><form action='"+__spellPageUrl+"' method='post' ACCEPT-CHARSET='UTF-8'>";spellBoot+="<input type='hidden' name='LicenseKey' value='"+spellLicenseKey+"'><input type='hidden' name='textToCheck' value=\""+escQuotes(escEntities(eval(interfaceObjectName+'.getText()')))+"\"><input type='hidden' name='InterfaceObject' value='"+interfaceObjectName+"'><input type='hidden' name='mode' value='popup'><input type='hidden' name='UserDictionaryFile' value='"+spellUserDictFile+"'><input type='hidden' name='SuggestionsMethod' value='HASHING_SUGGESTIONS'><input type='hidden' name='SeparateHyphenWords' value='false'>";spellBoot+="<input type='hidden' name='IncludeUserDictionaryInSuggestions' value='"+useUserDict+"'><input type='hidden' name='FinishedListener' value=''><input type='hidden' name='callBack' value=''><input type='hidden' name='IgnoreXML' value='true'><input type='hidden' name='IgnoreCapitalizedWords' value='false'>";spellBoot+="<input type='hidden' name='GuiLanguage' value='"+spellLanguage+"'><input type='hidden' name='LanguageParser' value='ENGLISH'>";spellBoot+="<input type='hidden' name='ShowFinishedMessage' value='false'><input type='hidden' name='ShowNoErrorsMessage' value='true'><input type='hidden' name='ShowXMLTags' value='false'><input type='hidden' name='ShowXMLTags' value='false'>";spellBoot+="<input type='hidden' name='DictFile' value='"+spellDictFile+"'><input type='hidden' name='PopUpWindowName' value=''><input type='hidden' name='CreatePopUpWindow' value='true'><input type='hidden' name='ConsiderationRange' value='80'></form></body></html>";var sc=window.open('blank.html','rspellwin','resizable=yes,scrollbars=auto,dependent=yes,toolbar=no,left=100,top=100,status=no,location=no,menubar=no,width=370,height=400');sc.focus();sc.document.open();sc.document.write(spellBoot);sc.document.close();}if(globalSpellMode==0)rsTCIntrapidSpellWebLauncher=new RSCustomInterface();function editSpellDelay(value){globalSpellDelay=value;};function CreateSpellContextMenu(objMenu,source){var url=globalEditorImagesFolder;objMenu.add(new MenuItem(getString(1089),url+"empty.gif","","IGNORE"));objMenu.add(new MenuItem(getString(1090),url+"empty.gif","","IGNOREALL"));if(globalSpellAdd){objMenu.add(new MenuSeparator());objMenu.add(new MenuItem(getString(1088),url+"empty.gif","","ADD"));}objMenu.add(new MenuSeparator());var aSuggestions=globalSpellSuggestions.split(";");var id=source.id.substring(5);var aSuggestionItems=aSuggestions[id].split(",");if(aSuggestionItems.length==1){if(aSuggestionItems[0]==""){aSuggestionItems=new Array();}}var suggLength=15;if(aSuggestionItems.length < 15){suggLength=aSuggestionItems.length;}if(suggLength > 0){for(var i=0;i<suggLength;i++){objMenu.add(new MenuItem("<b>"+aSuggestionItems[i]+"</b>",url+"empty.gif","","SPELLSET",aSuggestionItems[i]));}}else{objMenu.add(new MenuItem(getString(1091),url+"empty.gif","",""));}};function editSpellAdd(value){globalSpellAdd=value;};function editSpellSuggestions(suggestions){globalSpellSuggestions=suggestions;};function editSpellClear(){try{clearTimeout(globalSpellTimer);var doc=editGetDocument();var spanElements=doc.getElementsByTagName("span");var spellElements=new Array();for(var i=0;i<spanElements.length;i++){var isSpell=(spanElements[i].style.cssText.indexOf("/editor/add-on")> 0);if(spanElements[i].id.substring(0,5)=="pes__" || isSpell){spellElements[spellElements.length]=spanElements[i];}}for(var i=0;i<spellElements.length;i++){var value=spellElements[i].innerHTML;var css=spellElements[i].style.cssText;var aStyle=css.split(";");if(aStyle.length > 1){spellElements[i].style.backgroundImage="";spellElements[i].style.backgroundPositionX="";spellElements[i].style.backgroundPositionY="";spellElements[i].style.backgroundRepeat="";spellElements[i].style.backgroundAttachment="";spellElements[i].removeAttribute("id");}else{value=value.replace(/&amp;/gi,"&");var newText=doc.createTextNode(value);__editReplaceNode(spellElements[i],newText);}}}catch(Error){}};function editSpellGetRoot(){return __editGetEditorUrl()+"add-on/spell/";};function editSpellReplace(value){try{var span=editGetActiveObject();var css=span.style.cssText;var aStyle=css.split(";");if(aStyle.length > 1){span.style.backgroundImage="";span.style.backgroundPositionX="";span.style.backgroundPositionY="";span.style.backgroundRepeat="";span.style.backgroundAttachment="";spellElements[i].removeAttribute("id");}else{value=value.replace(/&amp;/gi,"&");var newText=editGetDocument().createTextNode(value);__editReplaceNode(span,newText);}}catch(Error){}};function onContextSpellMenuItemClick(key,value){try{if(key=="IGNORE"){var span=editGetActiveObject();editSpellReplace(span.innerHTML);}if(key=="IGNOREALL"){value=editGetActiveObject().innerHTML;var doc=editGetDocument();var spanElements=doc.getElementsByTagName("span");var spellElements=new Array();for(var i=0;i<spanElements.length;i++){if(spanElements[i].id.substring(0,5)=="pes__" && spanElements[i].innerHTML==value){spellElements[spellElements.length]=spanElements[i];}}for(var i=0;i<spellElements.length;i++){var value=spellElements[i].innerHTML;var newText=doc.createTextNode(value);if(browser.ie){spellElements[i].replaceNode(newText);}else{spellElements[i].parentNode.replaceChild(newText,spellElements[i]);}}document.getElementById('__editData').value=value;RaiseInternalEvent("SPELLIGNORE");}if(key=="ADD"){var span=editGetActiveObject();value=span.innerHTML;editSpellReplace(value);value=value.replace(/&amp;/gi,"&");document.getElementById('__editData').value=value;RaiseInternalEvent("SPELLADD");}if(key=="SPELLSET"){editSpellReplace(value);}__editHidePopup();}catch(Error){}};function editSpellByType(){setTimeout("editSpellByType_delay()",50);}function editSpellByType_delay(){RaiseInternalEvent("SPELL");};