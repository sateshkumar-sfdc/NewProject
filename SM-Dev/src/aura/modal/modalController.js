({
	myfunction : function(component, event, helper) {
		var a = event.target.src;
        console.log(a);
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
     event.target.src = a;
    }
      else{
          alert(this.status);
      }
  };
  xhttp.open("GET", "a", true);
  xhttp.send();

	}
})