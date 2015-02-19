/* basket and product detail quantity changer */
function qty_plus(whichLayer, max) {
	var qty = document.getElementById(whichLayer);
	
	if (!max) {
		max = 99;
	}
	
	if (qty.value < max) {
		qty.value = parseInt(qty.value) + 1;
	}
}

function qty_minus(whichLayer, min) {
	var qty = document.getElementById(whichLayer);
	
	if (!min) {
		min = 0;
	}
	
	if (qty.value > min) {
		qty.value = parseInt(qty.value) - 1;
	}
}
