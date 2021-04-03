
$(function() {
    console.log("Started")
    window.addEventListener("message", function(event) {
      if(event.type !== "message"){
        return;
      }
      
      if(event.data.type === "startup"){
        event.data.judges.forEach((value,key) => {
          console.log(value.name + "  -  " + key)
          $( ".judges" ).append( ` <div class="judge" data-id="${key}">
      <div class="cross">
        <span>X</span>
      </div>
      <div class="name">
        <span>${value.name}</span>
      </div>
    </div>` );
        })
      }
    })
  })