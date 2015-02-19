$(document).ready(function(){
	var i = 0;
	
	var gmCtrl = parseInt( $('irMaps').attr("ctrls") );
	var gmLink = parseInt( $('irMaps').attr("link") );
	var gmDouble = parseInt( $('irMaps').attr("double") );
	var gmType = $('irMaps').attr("type");
	if(!gmType){ gmType = "p"; }
	$('irMaps').remove();
	
	$('iframe').each(function(){
		var src = $(this).attr('src');
		var url = "maps.google.co";
		if( src && src.indexOf(url) != -1 ){
		
			$(this).next().remove();
			$(this).next().children("a").removeAttr("style");
			$(this).next().children("a").addClass("gmLink");
			$(this).next().addClass("notSmall");
			
			var gmWidth = parseInt($(this).attr("width"));
			var gmHeight = parseInt($(this).attr("height"));
			
			$(this).wrap("<div class='gmHold"+i+" gmH'></div>");
			$(".gmHold"+i).css({"width":gmWidth, "height":gmHeight});
			
			var gmHtml = $(".notSmall").html();
			if( gmLink >= 1 ){
				$(".notSmall").after("<div class='gmLinkHold"+i+" gmLH'></div>");
				$(".gmLinkHold"+i).html(gmHtml);
			}
			$(".notSmall").remove();
			
			$(".gmLinkHold"+i+" a").html("View on Google Maps");
			
			$('.gmHold'+i).next('.gmLinkHold'+i).andSelf().wrapAll("<div class='gmGlobHold"+i+" gmGh'></div>");
			$(".gmGlobHold"+i).css({"position":"relative", "height":gmHeight, "width":gmWidth});
			
			$(".gmLinkHold"+i).css({"position":"absolute", "bottom":"7px", "right":"7px"});
			
			if( gmCtrl >= 2 ){
				$(this).attr("height", gmHeight+40 );
			}
			else if( gmCtrl == 1 ){
				$(this).attr("height", gmHeight+40+62 );
				$(this).attr("width", gmWidth+26 );
				$(this).css({"marginLeft":"-13px", "marginTop":"-62px"});
			}
			else {
				$(this).attr("height", gmHeight+40+62 );
				$(this).attr("width", gmWidth+86 );
				$(this).css({"marginLeft":"-43px", "marginTop":"-62px"});
			}
			
			var gmSrcOrig = $(this).attr("src");
			if( gmSrcOrig.match(/t=[mkhpe]/) ){
				gmSrcOrig = gmSrcOrig.replace(/t=[mkhpe]/,"t=" + gmType);
			}else{
				gmSrcOrig = gmSrcOrig + "&amp;t=" + gmType;
			}
				
			var gmSrcPara = gmSrcOrig.split("&");
			var gmSrcPara1 = gmSrcPara[0].split("?");
			gmSrcPara[0] = gmSrcPara1[1];
			
			for (var j=0; j<gmSrcPara.length; j++) {
				if ( gmSrcPara[j].match("z=") ){
					var gmZindex = j;
					var gmZset = true;
				}
			}
			
			var gmZ = 0;
			
			if( gmZset ){
				gmZ = parseInt( gmSrcPara[gmZindex].replace("z=","") );
				if( gmZ > 15 ){
					gmSrcOrig = gmSrcOrig.replace("z="+gmZ,"z=15");
					gmZ = 15;
				}
			}
			
			$(this).attr("src",gmSrcOrig);
			
			if( gmDouble >= 1 ){
				
				var doubHtml = $('.gmHold'+i).html();
				$('.gmHold'+i).addClass("gmOrig");
				$('.gmHold'+i).after("<div class='gmHold"+i+" gmH gmDoub'>"+doubHtml+"</div>");
				
				$('.gmOrig.gmHold'+i).css({"height": (gmHeight/4)});
				
				$('.gmDoub.gmHold'+i).css({"height": (gmHeight/4)*3 , "width":gmWidth});
				
				$(this).attr("height", (gmHeight/4)+40+62 );
				$(this).attr("width", gmWidth+86 );
				$(this).css({"marginLeft":"-43px", "marginTop":"-62px"});
				
				if( gmCtrl >= 2 ){
					
					$('.gmDoub.gmHold'+i+' iframe').attr("height", ((gmHeight/4)*3)+40 );
				}
				else if( gmCtrl == 1 ){
				
					$('.gmDoub.gmHold'+i+' iframe').attr("height", ((gmHeight/4)*3)+40+62 );
					$('.gmDoub.gmHold'+i+' iframe').attr("width", gmWidth+26 );
					$('.gmDoub.gmHold'+i+' iframe').css({"marginLeft":"-13px", "marginTop":"-62px"});
				}
				else {
					
					$('.gmDoub.gmHold'+i+' iframe').attr("height", ((gmHeight/4)*3)+40+62 );
					$('.gmDoub.gmHold'+i+' iframe').attr("width", gmWidth+86 );
					$('.gmDoub.gmHold'+i+' iframe').css({"marginLeft":"-43px", "marginTop":"-62px"});
				}
				
				gmSrcOrig = gmSrcOrig.replace("iwloc=A","iwloc=near");
				
				if( gmZset ){
					var gmZnew = gmZ - gmDouble;
					if( gmZnew < 1 ){ gmZnew = 1; }
					
					gmSrcOrig = gmSrcOrig.replace("z="+gmZ,"z="+gmZnew);
				}else{
					gmSrcOrig = gmSrcOrig + "&amp;z=10";
				}
				
				$('.gmOrig.gmHold'+i+' iframe').attr("src",gmSrcOrig);
				
				$(".gmGlobHold"+i).css({"height":gmHeight+5});
				
			}
			
			i=i+1;
		}
	});
});