var Ajax = new Ajax();

function Ajax()
{
  this.isError = false;
  this.method = "GET";
  this.xml = null;
  this.text = "";
  this.xmlString = "";
  this.httpRequest = null;

  this.request = __ajax_request;
  this.callback = null; //function() {};

};

function __ajax_request(url, params) 
{
  var parameters = null;
  
  if (window.XMLHttpRequest) { 
    this.httpRequest = new XMLHttpRequest();
    if (this.httpRequest.overrideMimeType) {
      this.httpRequest.overrideMimeType('text/xml');
    }
  } else if (window.ActiveXObject) { 
    try {
      this.httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        this.httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (e) {}
    }
  }

  if (!this.httpRequest) {
    alert('Cannot create an XMLHTTP instance');
    return false;
  }

  this.httpRequest.onreadystatechange = function() { __ajax_onreadystatechange(); };
  
  // if we have parameters to pass then use post
  if(this.method == "POST") {
    // set header
    this.httpRequest.open('POST',url, true);
    this.httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    // build params
    parameters = "";
    for(var i=0;i<params.length;i++) {
      var pair = params[i];
      parameters += pair.key + "=" + escape(pair.value) + "&";
    }
//parameters = escape(parameters);
//alert(parameters);
  } else {
    this.httpRequest.open('GET',url, true);
  }
  this.httpRequest.send(parameters);
}

function __ajax_onreadystatechange()
{
  if(Ajax.httpRequest.readyState == 4) {
    if(Ajax.httpRequest.status == 200) {
      // now we have data 
      try {
        Ajax.isError = false;
        Ajax.text = Ajax.httpRequest.responseText;
        Ajax.xml = Ajax.httpRequest.responseXML;
        Ajax.xmlString = Ajax.httpRequest.responseXML.xml;
      } catch(e) {}
      if(Ajax.callback)
        Ajax.callback();
      Ajax.callback = null;
    } else {
      Ajax.isError = true;
    }
    Ajax.httpRequest.onreadystatechange = function() {};
  }
}
