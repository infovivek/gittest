
		function hr() 
		{
	
		$("#contactForm").slideDown("slow");
		$("#backgroundPopup").css({"opacity": "0.04"});
		$("#backgroundPopup").fadeIn("slow"); 		
		
		var x = document.getElementById("hrpolicy").checked;
	
		if(x == true){
		
			window.location.assign("<?php echo base_url(); ?>index.php/page/search_result/1/");
		
		}else{
	
   			window.location.assign("<?php echo base_url(); ?>index.php/page/search_result/2/");
		}
	}
	
	function price() 
		{
	
		$("#contactForm").slideDown("slow");
		$("#backgroundPopup").css({"opacity": "0.04"});
		$("#backgroundPopup").fadeIn("slow"); 
		
	}
	
	</script>
<script>
	var jq = $.noConflict();
	jq(document).ready(function(){
	 jq("#destination").autocomplete("<?php echo base_url(); ?>index.php/page/destinations", {
		selectFirst: true
	});
});

jq(document).ready(function(){
	 jq("#destination1").autocomplete("<?php echo base_url(); ?>index.php/page/destinations", {
		selectFirst: true
	});
});

	jq(document).ready(function(){
	 jq("#employee1").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
		selectFirst: true
	});
});

jq(document).ready(function(){
 jq("#employee2").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee3").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee4").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee5").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee6").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee7").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee8").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee9").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#employee10").autocomplete("<?php echo base_url(); ?>index.php/page/employee1", {
	selectFirst: true
});
});


jq(document).ready(function(){
 jq("#acity").autocomplete("<?php echo base_url(); ?>index.php/page/destinations", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#acity1").autocomplete("<?php echo base_url(); ?>index.php/page/destinations", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#property").autocomplete("<?php echo base_url(); ?>index.php/page/autoloadproperties", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#property2").autocomplete("<?php echo base_url(); ?>index.php/page/autoloadproperties", {
	selectFirst: true
});
});

jq(document).ready(function(){
 jq("#propertyname").autocomplete("<?php echo base_url(); ?>index.php/page/propertyname", {
	selectFirst: true
});
});



//jq(document).ready(function(){

  /*jq(document).ajaxStart(function(){
    jq("#preloader").css("display","block");
  });
  jq(document).ajaxComplete(function(){
    jq("#preloader").css("display","none");
  });  */

 // jq("button").click(function(){
	
 //   jq("#preloader").css("display","block");
//	 jq("#body").css("opacity","0.09");
//	 jq("#preloader").css("opacity","1");
//  });
 
//});


function locality(){
	
	
		$("#contactForm").slideDown("slow");
		$("#backgroundPopup").css({"opacity": "0.04"});
		$("#backgroundPopup").fadeIn("slow"); 		
	
		var lid = document.getElementById('locality').value;
		
		window.location.assign("<?php echo base_url(); ?>index.php/page/locality_result/"+lid);			
	
	}
	
	
function getrooms_guest(count)
{
 var rooms = document.getElementById('Adult').value;
 
 

	$.ajax({
		   type: "POST",
		   url: "<?php echo base_url();?>index.php/page/load_rooms",
		   data: {
		   rooms:rooms
		   },
		   success: function(msg){
		   
			 $('#rooms_grid').html(msg);
		   }
		 });
		 
			var destination = document.getElementById('destination').value;
			
			var checkin = document.getElementById('checkin').value;
			
			var checkout = document.getElementById('checkout').value;
			
			var guests = document.getElementById('Adult').value;
			
				
			if(destination !="" && checkin !="" && checkout !="" && guests !=""){
			
				document.getElementById('next').style.display = "none";
			
				document.getElementById('next_room').style.display = "block";
			}	
}




function star_rating(rate)
{

			$("#contactForm").slideDown("slow");
			$("#backgroundPopup").css({"opacity": "0.04"});
			$("#backgroundPopup").fadeIn("slow"); 		
			
			window.location.assign("<?php echo base_url(); ?>index.php/page/star_rating/"+rate);			
			
	/*$.ajax({
		   type: "POST",
		   url: "<?php echo base_url();?>index.php/page/star_rating",
		   data: {
		   rate:rate
		   },
		   success: function(msg){
		   
		   	$("#contactForm").slideUp("slow");
			$("#backgroundPopup").css({"opacity": "0"});
			$("#backgroundPopup").fadeOut("slow"); 		

		   		 $('#ajax_load').html(msg);		   
		  
		   }
		 });
		 */
			
}

/*function pname_search()
{

			$("#contactForm").slideDown("slow");
			$("#backgroundPopup").css({"opacity": "0.04"});
			$("#backgroundPopup").fadeIn("slow"); 	
			
}*/

			function final_validation(){
			
			
			var rooms = document.getElementById('Adult').value;
			
				if(rooms == 1){
						 var room1 = document.getElementById('room1').value;
							if(room1 == ""){

                   				alert("Fill the number of Guest(s) for room 1");
								document.getElementById('room1').focus();
                    			return false;

               			 }
			
				}
				
				if(rooms == 2){
						 var room1 = document.getElementById('room1').value;
						 var room2 = document.getElementById('room2').value;
							if(room1 == ""){

                   				alert("Fill the number of Guest(s) for room 1");
								document.getElementById('room1').focus();
                    			return false;

               			 }
						 if(room2 == ""){
								alert("Fill the number of Guest(s) for room 2");
								document.getElementById('room2').focus();
								return false;
			
						}
			
				}
				
				if(rooms == 3){
						 var room1 = document.getElementById('room1').value;
						 var room2 = document.getElementById('room2').value;
						 var room3 = document.getElementById('room3').value;
							if(room1 == ""){

                   				alert("Fill the number of Guest(s) for room 1");
								document.getElementById('room1').focus();
                    			return false;

               			 }
						 if(room2 == ""){
								alert("Fill the number of Guest(s) for room 2");
								document.getElementById('room2').focus();
								return false;
			
						}
						if(room3 == ""){
								alert("Fill the number of Guest(s) for room 3");
								document.getElementById('room3').focus();
								return false;
			
						}
			
				}
				
				if(rooms == 4){
				
						 var room1 = document.getElementById('room1').value;
						 var room2 = document.getElementById('room2').value;
						 var room3 = document.getElementById('room3').value;
						 var room4 = document.getElementById('room4').value;
						 
						if(room1 == ""){

                   				alert("Fill the number of Guest(s) for room 1");
								document.getElementById('room1').focus();
                    			return false;

               			 }
						 if(room2 == ""){
								alert("Fill the number of Guest(s) for room 2");
								document.getElementById('room2').focus();
								return false;
			
						}
						if(room3 == ""){
								alert("Fill the number of Guest(s) for room 3");
								document.getElementById('room3').focus();
								return false;
			
						}
						if(room4 == ""){
								alert("Fill the number of Guest(s) for room 4");
								document.getElementById('room4').focus();
								return false;
			
						}
			
				}
				
				if(rooms == 5){
						 var room1 = document.getElementById('room1').value;
						 var room2 = document.getElementById('room2').value;
						 var room3 = document.getElementById('room3').value;
						 var room4 = document.getElementById('room4').value;
						 var room5 = document.getElementById('room5').value;
						 
						if(room1 == ""){

                   				alert("Fill the number of Guest(s) for room 1");
								document.getElementById('room1').focus();
                    			return false;

               			 }
						 if(room2 == ""){
								alert("Fill the number of Guest(s) for room 2");
								document.getElementById('room2').focus();
								return false;
			
						}
						if(room3 == ""){
								alert("Fill the number of Guest(s) for room 3");
								document.getElementById('room3').focus();
								return false;
			
						}
						if(room4 == ""){
								alert("Fill the number of Guest(s) for room 4");
								document.getElementById('room4').focus();
								return false;
			
						}
						if(room5 == ""){
								alert("Fill the number of Guest(s) for room 5");
								document.getElementById('room5').focus();
								return false;
			
						}
			
				}
			
			}

			function gen_validate(){

                var destination = document.getElementById('destination').value;

                var checkin = document.getElementById('checkin').value;

                var checkout = document.getElementById('checkout').value;

                var guests = document.getElementById('Adult').value;
				
                if(destination == ""){

                    alert("Destination cant be empty");
					document.getElementById('destination').focus();
                    return false;

                }

                if(checkin == ""){
                    alert("Check in Date cant be empty");
					document.getElementById('checkin').focus();
                    return false;

                }

                if(checkout == ""){

                    alert("Check out Date cant be empty");
					document.getElementById('checkout').focus();
                    return false;
                }
                if(guests == ""){

                    alert("Please select number of guests ");
					document.getElementById('Adult').focus();
                    return false;

                }


            }
            function validate(){

				
                var destination = document.getElementById('destination').value;

                var checkin = document.getElementById('checkin').value;

                var checkout = document.getElementById('checkout').value;

                var guests = document.getElementById('Adult').value;
				
                if(destination == ""){

                    alert("Destination cant be empty");
					document.getElementById('destination').focus();
                    return false;

                }

                if(checkin == ""){
                    alert("Check in Date cant be empty");
					document.getElementById('checkin').focus();
                    return false;

                }

                if(checkout == ""){

                    alert("Check out Date cant be empty");
					document.getElementById('checkout').focus();
                    return false;
                }
                if(guests == ""){

                    alert("Please select number of guests ");
					document.getElementById('Adult').focus();
                    return false;

                }
				
				        				
				if(destination !="" && checkin !="" && checkout !="" && guests !=""){
				
				$.ajax({
					   type: "POST",
					   url: "<?php echo base_url();?>index.php/page/load_rooms",
					   data: {
					   rooms:guests
					   },
					   success: function(msg){
					   
						 $('#rooms_grid').html(msg);
					   }
				});
		 
				
					document.getElementById('next').style.display = "none";
					
					document.getElementById('next_room').style.display = "block";
				}
				
            }
			
			
			function rooms_validate(){

                var room1 = document.getElementById('room1').value;

                var room2 = document.getElementById('room2').value;

                var room3 = document.getElementById('room3').value;

                var room4 = document.getElementById('room4').value;
				
                if(room1 == ""){

                    alert("Destination cant be empty");
					document.getElementById('room1').focus();
                    return false;

                }

                if(room2 == ""){
                    alert("Check in Date cant be empty");
					document.getElementById('room2').focus();
                    return false;

                }

                if(room3 == ""){

                    alert("Check out Date cant be empty");
					document.getElementById('room3').focus();
                    return false;
                }
                if(room4 == ""){

                    alert("Please select number of guests ");
					document.getElementById('room4').focus();
                    return false;

                }


            }
			
			function check_for_button(){

			
                var destination = document.getElementById('destination').value;

                var checkin = document.getElementById('checkin').value;

                var checkout = document.getElementById('checkout').value;

                var guests = document.getElementById('Adult').value;
				
				var rooms = document.getElementById('Adult').value;
                		
								
				if(destination !="" && checkin !="" && checkout !="" && guests !=""){
				
				$.ajax({
					   type: "POST",
					   url: "<?php echo base_url();?>index.php/page/load_rooms",
					   data: {
					   rooms:rooms
					   },
					   success: function(msg){
					   
						 $('#rooms_grid').html(msg);
					   }
				 });
				
					document.getElementById('next').style.display = "none";
					
					document.getElementById('next_room').style.display = "block";
				}


            }

       
            function booking_validate(){

                var firstname = document.getElementById('firstname').value;

                var lastname = document.getElementById('lastname').value;

                var empcode = document.getElementById('empcode').value;

                var empdesi = document.getElementById('empdesi').value;
				
				var empemail = document.getElementById('empemail').value;
				
				var empmobile = document.getElementById('empmobile').value;

				
				
                if(firstname == ""){

                    alert("Firstname cant be empty");
					document.getElementById('firstname').focus();
                    return false;
                }

                if(lastname == ""){
                    alert("Lastname cant be empty");
					document.getElementById('lastname').focus();
                    return false;
                }

                if(empcode == ""){

                    alert("Employee code cant be empty");
					document.getElementById('empcode').focus();
                    return false;
                }
                if(empdesi == ""){

                    alert("Designation cant be empty");
					document.getElementById('empdesi').focus();
                    return false;
                }
				if(empemail == ""){

                    alert("Email cant be empty");
					document.getElementById('empemail').focus();
                    return false;
                }
				if(empmobile == ""){

                    alert("Mobile number cant be empty");
					document.getElementById('empmobile').focus();
                    return false;

                }
				if(!document.getElementById('terms').checked){
				
					alert("Accept our terms and conditions");
					return false;
				}
				
            }
			
			
			  function registration_validate(){

                var firstname = document.getElementById('first_name').value;

                var lastname = document.getElementById('last_name').value;

                var empcode = document.getElementById('empcode').value;
				
				var empemail = document.getElementById('email').value;
				
				var empmobile = document.getElementById('mobile').value;

				
				
                if(firstname == ""){

                    alert("First name cant be empty");
					document.getElementById('first_name').focus();
                    return false;
                }

                if(lastname == ""){
                    alert("Last name cant be empty");
					document.getElementById('last_name').focus();
                    return false;
                }

                if(empcode == ""){

                    alert("Employee code cant be empty");
					document.getElementById('empcode').focus();
                    return false;
                }
                
				if(empemail == ""){

                    alert("Email cant be empty");
					document.getElementById('email').focus();
                    return false;
                }
				if(empmobile == ""){

                    alert("Mobile number cant be empty");
					document.getElementById('empmobile').focus();
                    return false;

                }
								
            }

      