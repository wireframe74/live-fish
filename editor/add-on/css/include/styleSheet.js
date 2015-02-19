function StyleSheet()
{
	this.rules = new Array();
	this.getRules = __ss_getrules;
	this.getClasses = __ss_getclasses;
	this.getIds = __ss_getids;
	this.getElements = __ss_getelements;
	this.getRuleByName = __ss_getrulebyname;
  this.ruleExist = __ss_ruleexist;
	this.addRule = __ss_addrule;
	this.updateRule = __ss_updaterule;	
	this.deleteRule = __ss_deleterule;	
	this.renameRule = __ss_renamerule;		
	this.cssText = __ss_csstext;
	this.getColors = __ss_getcolors;
}

function __ss_getrules()
{
	var elements = new Array();
	var classes = new Array();
	var ids = new Array();
	var rules = new Array();
	
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].type == "id") {
      ids[ids.length] = this.rules[i];
		} else if (this.rules[i].type == "element") {
      elements[elements.length] = this.rules[i];
		} else if (this.rules[i].type == "class") {
      classes[classes.length] = this.rules[i];
		}
	}
	classes.sort(__style_sort);
	elements.sort(__style_sort);
	ids.sort(__style_sort);

	for (var i=0;i<elements.length;i++) {
    rules[rules.length] = elements[i];
	}
	for (var i=0;i<classes.length;i++) {
    rules[rules.length] = classes[i];
	}
	for (var i=0;i<ids.length;i++) {
    rules[rules.length] = ids[i];
	}
	
  this.rules = rules;
	return rules;
}

function __ss_csstext(type)
{
  if (type == "formatted") {
    beforeRule = "<div class='rulename'>";
    afterRuleName = "</div>\n<div>{</div>";
    afterRule = "<div class='rulename'>}</div><br>\n\n";
    beforeStyle = "<div class='stylename'>";
    afterStyleName = ":<span class='stylevalue'>";
    afterStyle = "</span>;</div>\n";
  } else if (type == "structured") {
    beforeRule = "";
    afterRuleName = " {\n";
    afterRule = "}\n\n";
    beforeStyle = "\t";
    afterStyleName = ":";
    afterStyle = ";\n";
  } else {
    beforeRule = "";
    afterRuleName = "{";
    afterRule = "}";
    beforeStyle = "";
    afterStyleName = ":";
    afterStyle = ";";
  }
  var temp = '';
  for (var i = 0; i<this.rules.length; i++) {
    temp = temp + beforeRule + this.rules[i].name + afterRuleName;
		for (var j = 0; j<this.rules[i].styles.length; j++) {
			temp = temp + beforeStyle + this.rules[i].styles[j].name + afterStyleName + this.rules[i].styles[j].value + afterStyle;
		}
		temp = temp + afterRule;
	}
	return temp ;
}


function __ss_getclasses()
{
	var classes = new Array();
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].type == "class") {
      classes[classes.length] = this.rules[i];
		}
	}
	classes.sort(__style_sort);
  return classes;
}

function __ss_getelements()
{
	var elements = new Array();
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].type == "element") {
      elements[elements.length] = this.rules[i];
		}
	}
	elements.sort(__style_sort);
  return elements;
}

function __ss_getids()
{
	var ids = new Array();
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].type == "id") {
      ids[ids.length] = this.rules[i];
		}
	}
	ids.sort(__style_sort);
  return ids;
}

function __ss_getrulebyname(name)
{
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].name.toLowerCase() == name.toLowerCase()) {
			return this.rules[i];
		}
	}
}

function __ss_ruleexist(name)
{
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].name.toLowerCase() == name.toLowerCase()) {
			return true;
		}
	}
	return false;
}

function __ss_addrule(rule)
{
	this.rules[this.rules.length] = rule;
}

function __ss_updaterule(name, text, newName)
{
	var tempRule = new Rule("temp");
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].name.toLowerCase() == name.toLowerCase()) {
			split1 = text.split(";");
			for (var y=0;y<split1.length;y++) {
				if (split1[y].length > 0) {
					split2 = split1[y].split(":");
					newStyle = new Style(split2[0].trim(), split2[1].trim());
					tempRule.addStyle(newStyle);
				}
			}
			this.rules[i].styles = tempRule.styles;
		}		
	}
}

function __ss_deleterule(name)
{
	var tempRules = new Array();
	for (var i=0;i<this.rules.length;i++) {
		if (!(this.rules[i].name.toLowerCase() == name.toLowerCase())) {
			tempRules[tempRules.length] = this.rules[i];
		}		
	}
	this.rules = tempRules;
}

function __ss_renamerule(oldName, newName) {
	for (var i=0;i<this.rules.length;i++) {
		if (this.rules[i].name.toLowerCase() == oldName.toLowerCase()) {
			this.rules[i].name = newName;
		}		
	}
}

function __ss_getcolors()
{
  var temp = new Array();
  var z = 0;
  var y = false;
  for(var i=0;i<this.rules.length;i++) {
  	for (var j=0;j<this.rules[i].styles.length;j++) {
  		if (this.rules[i].styles[j].name.toLowerCase() == "background-color" || this.rules[i].styles[j].name.toLowerCase() == "color") {
  			for (var k=0;k<temp.length;k++) {
  				if (temp[k] == this.rules[i].styles[j].value.toLowerCase()) y=true;
  			}
  			if (y==false) {
  				temp[z] = this.rules[i].styles[j].value.toLowerCase();
  				z++;
  			}
  			y=false;
  		}
  	}
  }
  return temp;
}

function Rule(name, type)
{
	this.name = name;
	this.type = type;
	this.cssText = __rule_csstext;
	this.styles = new Array();
	this.addStyle = __rule_addstyle;
	this.updateStyle = __rule_updatestyle;
	this.deleteStyle = __rule_deletestyle;
	this.getStyles = __rule_getstyles;	
}

function __rule_csstext(clean)
{
	var temp = "";
	var name = "";

	for (var i = 0; i<this.styles.length; i++) {
    name = this.styles[i].name.toLowerCase();
    if(clean == true) {
      if (!(name == "position" || name == "width" || name == "top" || name == "left")) {
        temp = temp + this.styles[i].name + ":" + this.styles[i].value + ";";
      }
    } else {
		  temp = temp + this.styles[i].name + ":" + this.styles[i].value + ";";
    }
	}
	return temp;
}

function __rule_getstyles()
{
	return this.styles;
}

function __rule_addstyle(style)
{
	this.styles[this.styles.length] = style;
}

function __rule_updatestyle(name, value) 
{
  var m=0;
  var temp=null;
  
	for (var i=0;i<this.styles.length;i++) {
		if (this.styles[i].name == name) {
			this.styles[i].value = value;
			m=1;
		}		
	}
	//Add new style if exist
	if (m==0) {
	  temp = new Style(name, value);
	  this.styles[this.styles.length] = temp;
	}
}

function __rule_deletestyle(name) 
{
	var tempRule = new Rule("temp");
	for (var i=0;i<this.styles.length;i++) {
		if (!(this.styles[i].name.trim().toLowerCase() == name.trim().toLowerCase())) {
			tempRule.styles[tempRule.styles.length] = this.styles[i];
		}		
	}
	this.styles = tempRule.styles;
}

function Style(name, value)
{
	this.name = name;
	this.value = value;
}

function __style_sort(a,b)
{
 if (a.name < b.name) return -1;
  if (a.name>b.name) return 1;
  return 0;
}
