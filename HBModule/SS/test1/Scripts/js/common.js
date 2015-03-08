var Common = {};

$(document).ready(function() {Common.onReady()});

Common.onReady = function() {
	Common.popUpAlert("Message","App is Ready !!!!");
}.bind(Common);


Common.popUpAlert = function(title,message){
  $('#basicModal').modal(options);
  $('#basicModal #myModalLabel').html(""+title)
  $('#basicModal #error-message').html(""+message)
  var options = {
      "backdrop" : "static"
  }
}.bind(Common);



Common.globalAjax = function(pageName,data){
	$.ajax({
	    url: "./ajax/" + pageName+".php",
	    type: "POST",
    	data: "",
    	dataType: "html",
    	cache: false,
	    beforeSend: function(){
	        $("#content").append('<div class="spinner-background"><div class="spinner-card"><img src="img/loader.GIF"><h5>Loading...</h5></div></div>');
	    },
	    success: function (html) {
	        alert(html);
	    }
  });
}.bind(Common);