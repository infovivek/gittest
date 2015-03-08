var Demo = {};

$(document).ready(function() {
	
});




Demo.showBusinessTab = function(object){

	$('.image-row .image').css("border","0px");
	$(object).css("border","2px solid #dcdcdc");
	$('.ss-footer-contacts-image').css("background","#ededed");
	$('.demo-page.pc .arrow-up, .side-image, .page-popups').hide();
	$('.business .arrow-up').show();
	$('#business-popup').show();

}.bind(Demo);


Demo.showAgentTab = function(object){
	$('.image-row .image').css("border","0px");
	$(object).css("border","2px solid #dcdcdc")
	$('.ss-footer-contacts-image').css("background","#ededed");
	$('.demo-page.pc .arrow-up, .side-image, .page-popups').hide();
	$('.agent .arrow-up').show();
	$('#agent-popup').show();
}.bind(Demo);

Demo.showManagerTab = function(object){
	$('.image-row .image').css("border","0px");
	$(object).css("border","2px solid #dcdcdc")
	$('.ss-footer-contacts-image').css("background","#ededed");
	$('.demo-page.pc .arrow-up, .side-image, .page-popups').hide();
	$('.manager .arrow-up').show();
	$('#manager-popup').show();
}.bind(Demo);
