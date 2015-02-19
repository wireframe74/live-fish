function Browser()
{
    agent  = navigator.userAgent.toLowerCase();
    this.major = parseInt(navigator.appVersion);
    this.minor = parseFloat(navigator.appVersion);
    this.ns    = ((agent.indexOf('mozilla')   !=   -1) &&
                 ((agent.indexOf('spoofer')   ==   -1) &&
                 (agent.indexOf('compatible') ==   -1)));
    this.ns4   = (this.ns && (this.major      ==    4));
    this.ns6   = (this.ns && (this.major      >=    5));
    this.ie    = (agent.indexOf("msie")       !=   -1);
    this.ie3   = (this.ie && (this.major      < 4));
    this.ie4   = (this.ie && (this.major      ==    4) &&
                 (agent.indexOf("msie 5.0")   ==   -1) &&
                 (agent.indexOf("msie 6.0")   ==   -1));
    this.ie5   = (this.ie && (this.major      ==    4) &&
                 (agent.indexOf("msie 5.0")   !=   -1));
    this.ie55  = (this.ie && (this.major      ==    4) &&
                 (agent.indexOf("msie 5.5")   !=   -1));
    this.ie6   = (this.ie && (agent.indexOf("msie 6.0")!=-1) );
    this.opera = (agent.indexOf("opera")       !=   -1);

    if( this.ns )
            this.browser = "Netscape";
    if( this.ie)
            this.browser = "Internet Explorer";
    if( this.opera) {
            this.browser = "Opera";
            this.ie = false;
            this.ie5 = false;
    }
    if(this.ie4) this.version = "4.x";
    if(this.ie5) this.version = "5.0";
    if(this.ie55) this.version = "5.5";
    if(this.ie6) this.version = "6.0";
    if(this.opera) this.version = "5.x";

    if(this.ns4) this.version = "4.x";
    if(this.ns6) this.version = "6.x";
    if(this.opera) this.version = "5.x"

    if(this.ie5 || this.ie55 || this.ie6 || this.ns6 || this.opera)
            this.dom = true
    else
            this.dom = false

    this.info = this.browser + " " + this.version + "\r\n" + this.major + "." + this.minor + "   \r\n" + agent + "  \r\n" + navigator.appVersion
    this.browser = (this.ie6 || this.ie5 || this.ns4 || this.ns6);
};
var browser = new Browser();