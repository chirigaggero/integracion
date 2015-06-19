$(function(){
  $.scrollIt({topOffset: -70});
  hljs.initHighlightingOnLoad();

	$("#azucar").change(function(){
		$("#azucar_buy").attr("href", "/ecommerce/shoppingcart/azucar/"+$("#azucar").val());
	});

	$("#madera").change(function(){
		$("#madera_buy").attr("href", "/ecommerce/shoppingcart/madera/"+$("#madera").val());
	});

	$("#celulosa").change(function(){
		$("#celulosa_buy").attr("href", "/ecommerce/shoppingcart/celulosa/"+$("#celulosa").val());
	});

	$("#chocolate").change(function(){
		$("#chocolate_buy").attr("href", "/ecommerce/shoppingcart/chocolate/"+$("#chocolate").val());
	});

	$("#pastadesemola").change(function(){
		$("#pastadesemola_buy").attr("href", "/ecommerce/shoppingcart/pastadesemola/"+$("#pastadesemola").val());
	});

	window.setTimeout(function() {
	    $("#alert-message").fadeTo(500, 0).slideUp(500, function(){
	        $(this).remove(); 
	    });
	}, 5000);


});