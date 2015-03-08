$(document).ready(function(){
						   
	//function for top search bar
	
	function topsearch() {
		if ($("#contactForm").is(":hidden")){
			
			if($('#destination').val() !="" && $('#checkin').val() !="" && $('#checkout').val() !="" && $('#Adult').val() !=""){
				$("#contactForm").slideDown("slow");
				$("#backgroundPopup").css({"opacity": "0.04"});
				$("#backgroundPopup").fadeIn("slow"); 
			}
		}
		
	}
	
	//
	function afterguestemail() {
		if ($("#contactForm").is(":hidden")){
			
			if($('#employee1').val() !=""){
			
			$("#contactForm").slideDown("slow");
			$("#backgroundPopup").css({"opacity": "0.04"});
			$("#backgroundPopup").fadeIn("slow"); 
			}
		}
		
	}
	
	//
	function price() {
						
			$("#contactForm").slideDown("slow");
			$("#backgroundPopup").css({"opacity": "0.04"});
			$("#backgroundPopup").fadeIn("slow"); 
			
	}
	 
	
	$(".topsearch").click(function(){topsearch()});
	$(".afterguestemail").click(function(){afterguestemail()});
	$(".afterguestemail1").click(function(){afterguestemail1()});
	//$("#locality").change(function(){afterguestemail()});
	
	$(".go").click(function(){price()});
	
	
	//only need force for IE6  
	$("#backgroundPopup").css({  
		"height": document.documentElement.clientHeight 
	});  
});