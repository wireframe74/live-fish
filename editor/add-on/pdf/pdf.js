/*
Modification or decryption of this file is strictly forbidden - Pintexx GmbH
*/
var __comm_pdf;var __data_pdf;var __tmp_pdf_loaded=false;var __tmp_pdf_name="";function pdf(){this.receive=__pdf_receive;};function __pdf_receive(fileName){__tmp_pdf_loaded=true;};function editPDFCreate(name){name=name ? name : "";__tmp_pdf_loaded=false;__comm_pdf=new pdf();if(globalPDFPage==""){if(globalDebug)alert("Please specify parameter 'globalPDFPage' !");return;}if(globalPDFFileName==""){var rnd=Math.random()+"";filename=rnd.substring(2,10);}else{filename=globalPDFFileName;}__tmp_pdf_name=filename+".pdf";html="<html>";html+="<head>";html+="<meta http-equiv='content-type' content='text/html; charset=utf-8'>";html+="</head>";html+="<body>";html+="<form name='frmComm' id='frmComm' name='frmComm' method ='POST' action='"+globalPDFPage+"'>";html+="<input type='hidden' id='pineditkey' name='pineditkey' value=''>";html+="<input type='hidden' id='pineditpdfkey' name='pineditpdfkey' value=''>";html+="<input type='hidden' id='html' name='html' value=''>";html+="<input type='hidden' id='filename' name='filename' value=''>";html+="<input type='hidden' id='path' name='path' value=''>";html+="<input type='hidden' id='papersize' name='papersize' value=''>";html+="<input type='hidden' id='orientation' name='orientation' value=''>";html+="<input type='hidden' id='resolution' name='resolution' value=''>";html+="<input type='hidden' id='title' name='title' value=''>";html+="<input type='hidden' id='author' name='author' value=''>";html+="<input type='hidden' id='subject' name='subject' value=''>";html+="<input type='hidden' id='creator' name='creator' value=''>";html+="<input type='hidden' id='keywords' name='keywords' value=''>";html+="<input type='hidden' id='header' name='header' value=''>";html+="<input type='hidden' id='footer' name='footer' value=''>";html+="<input type='hidden' id='compression' name='compression' value=''>";html+="<input type='hidden' id='marginleft' name='marginleft' value=''>";html+="<input type='hidden' id='margintop' name='margintop' value=''>";html+="<input type='hidden' id='marginright' name='marginright' value=''>";html+="<input type='hidden' id='marginbottom' name='marginbottom' value=''>";html+="<input type='hidden' id='headerheight' name='headerheight' value=''>";html+="<input type='hidden' id='footerheight' name='footerheight' value=''>";html+="<input type='hidden' id='convertforms' name='convertforms' value=''>";html+="<input type='hidden' id='convertlinks' name='convertlinks' value=''>";html+="<input type='hidden' id='ownerpassword' name='ownerpassword' value=''>";html+="<input type='hidden' id='userpassword' name='userpassword' value=''>";html+="<input type='hidden' id='version' name='version' value=''>";html+="<input type='hidden' id='unit' name='unit' value=''>";html+="</form>";html+="</body>";html+="</html>";var iframe=null;iframe=document.createElement("IFRAME");document.body.appendChild(iframe);iframe.id="__remote_frame_pdf";iframe.style.visibility="hidden";iframe.src="dummy.html";var doc=null;try{doc=iframe.contentWindow.document;}catch(Error){iframe.src="dummy.html";doc=iframe.contentWindow.document;}doc.open();doc.write(html);doc.close();__editHideSymbols();__editRemoveMSMetaTag();var temp=getDoc().documentElement.innerHTML;if(globalTechnology.toLowerCase()!="aspx")temp=__editConvertCode(temp);doc.getElementById("html").value=temp;__editShowSymbols();doc.getElementById("pineditkey").value=globalLicenceKey;doc.getElementById("pineditpdfkey").value=globalPDFLicenseKey;doc.getElementById("filename").value=filename;doc.getElementById("path").value=globalPDFOutputPath;doc.getElementById("papersize").value=globalPDFPaperSize;doc.getElementById("orientation").value=globalPDFOrientation;doc.getElementById("resolution").value=globalPDFResolution;doc.getElementById("title").value=globalPDFTitle;doc.getElementById("author").value=globalPDFAuthor;doc.getElementById("subject").value=globalPDFSubject;doc.getElementById("creator").value=globalPDFCreator;doc.getElementById("keywords").value=globalPDFKeyWords;doc.getElementById("header").value=globalPDFHeader;doc.getElementById("footer").value=globalPDFFooter;doc.getElementById("compression").value=globalPDFJPEGCompression;doc.getElementById("marginleft").value=parseFloat(globalPDFMarginLeft);doc.getElementById("margintop").value=parseFloat(globalPDFMarginTop);doc.getElementById("marginright").value=parseFloat(globalPDFMarginRight);doc.getElementById("marginbottom").value=parseFloat(globalPDFMarginBottom);doc.getElementById("headerheight").value=parseFloat(globalPDFHeaderHeight);doc.getElementById("footerheight").value=parseFloat(globalPDFFooterHeight);doc.getElementById("convertforms").value=globalPDFConvertForms;doc.getElementById("convertlinks").value=globalPDFConvertLinks;doc.getElementById("ownerpassword").value=globalPDFOwnerPassword;doc.getElementById("userpassword").value=globalPDFUserPassword;doc.getElementById("version").value=globalPDFVersion;doc.getElementById("unit").value=globalPDFUnit;if(browser.ie){iframe.attachEvent("onload",__tmp_pdf_onload);}else{iframe.addEventListener("load",__tmp_pdf_onload,false);}doc.getElementById("frmComm").submit();};function __tmp_pdf_onload(){try{var doc=document.getElementById("__remote_frame_pdf").contentWindow.document;var ret=doc.getElementById("data").value;if(ret!="OK"){alert(ret);return;}}catch(Error){}try{eventOnPDFCreated(__tmp_pdf_name);}catch(Error){}};function editPDFSettings(){var attribute="";var file=__editGetEditorUrl()+"add-on/pdf/frame.html";__editMozParam=new Array();__editMozParam[0]=language;__editMozParam[1]=design;__editMozParam[2]=globalPDFPaperSize;__editMozParam[3]=globalPDFOrientation;__editMozParam[4]=globalPDFResolution;__editMozParam[5]=globalTechnology;__editMozParam[6]=globalPDFTitle;__editMozParam[7]=globalPDFAuthor;__editMozParam[8]=globalPDFSubject;__editMozParam[9]=globalPDFKeyWords;__editMozParam[10]=globalPDFCreator;__editMozParam[11]=globalPDFHeader;__editMozParam[12]=globalPDFFooter;__editMozParam[13]=0;__editMozParam[14]=__editLanguage;__editMozParam[15]=globalPDFMarginLeft;__editMozParam[16]=globalPDFMarginTop;__editMozParam[17]=globalPDFMarginRight;__editMozParam[18]=globalPDFMarginBottom;__editMozParam[19]=globalPDFHeaderHeight;__editMozParam[20]=globalPDFFooterHeight;__editMozParam[21]=globalPDFConvertForms;__editMozParam[22]=globalPDFConvertLinks;__editMozParam[23]=globalPDFOwnerPassword;__editMozParam[24]=globalPDFUserPassword;__editMozParam[25]=globalPDFVersion;__editMozParam[26]=globalPDFUnit;var width;var height;width=475;height=600;if(browser.ie){attribute="dialogHeight:"+(height+globalDialogOffset)+"px;dialogWidth:"+width+"px;resizable:0;status:0;scroll:0";var params=window.showModalDialog(file,__editMozParam,attribute);editPDFUpdateSettings(params);}else{var left=screen.width/2-width/2;var top=screen.height/2-height/2;var win=window.open(file,"table","left="+left+",top="+top+",height="+height+",width="+width+",resizable=0,status=0,scrollbars=0");win.focus();}};function editPDFUpdateSettings(params){globalPDFPaperSize=params[2];globalPDFOrientation=params[3];globalPDFResolution=params[4];globalPDFTitle=params[6];globalPDFAuthor=params[7];globalPDFSubject=params[8];globalPDFKeyWords=params[9];globalPDFCreator=params[10];globalPDFHeader=params[11];globalPDFFooter=params[12];globalPDFMarginLeft=params[15];globalPDFMarginTop=params[16];globalPDFMarginRight=params[17];globalPDFMarginBottom=params[18];globalPDFHeaderHeight=params[19];globalPDFFooterHeight=params[20];globalPDFConvertForms=params[21];globalPDFConvertLinks=params[22];globalPDFOwnerPassword=params[23];globalPDFUserPassword=params[24];};