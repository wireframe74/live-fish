$(document).ready(function(){

	var t=new Date;
	var x=new Array(7);
	x[0]="Sun";
	x[1]="Mon";
	x[2]="Tue";
	x[3]="Wed";
	x[4]="Thu";
	x[5]="Fri";
	x[6]="Sat";
	
	var r="day"+x[t.getDay()];
	var o="date"+t.getDate();
	var s="month"+(t.getMonth()+1);
	var e=""+t.getFullYear();
	
	$("body").addClass(r);
	$("body").addClass(o);
	$("body").addClass(s);
	$("body").addClass(e);

});