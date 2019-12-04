var i = 0;
var text = " ";

function tick() {
  	$("div.console").text("test");
	//	document.getElementById("console").innerHTML = " ";
		i = 0;
		var file = "alert.txt";
	  $.get(file, function(data){
			text = data;
		});
		//updateText();
		//setInterval(tick, 10000);
		//alert("I am being called.");
}

function updateText() {
	var length;
	if (text)
		length = text.length;
	else
		length = 0;
	if (i < text.length) {
		document.getElementById("console").innerHTML += text.charAt(i);
		i++;
		setTimeout(updateText, 25);
	}
}

tick();
document.getElementById("console").appendChild("test");

function display(msg) {
    var p = document.createElement('p');
    p.innerHTML = msg;
    document.body.appendChild(p);
}
