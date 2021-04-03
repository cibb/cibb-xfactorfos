
$(function() {    
    window.addEventListener("message", function(event) {
      if(event.type !== "message"){
        return;
      }

      console.log(JSON.stringify(event.data))
      
      if(event.data.type === "startup"){
        $("#loading").remove();

        event.data.judges.forEach((value,key) => {          
          $( ".judges" ).append( `
          <div class="judge" data-id="${key}">
            <div class="cross">
              <span>X</span>
            </div>
            <div class="name">
              <span>${value.name}</span>
            </div>
          </div>` );
        })
      }

      if(event.data.type === "xUpdate"){
        
        $(".pressed").removeClass("pressed");
        $(".golden").removeClass("golden");          

        event.data.xPressed.forEach(item => {          
          if(item === null || item === undefined){
            return;
          }                    
          // Judge ID is the receibed id minus one due differences between index in LUA and Javascript
          let judgeId = item.internalIdentifier-1;
          let className = item.button === "x" ? 'pressed' : 'golden';
          
          $(`.judge[data-id="${judgeId}"]`).children().addClass(className);
        })        
      }
    })
  })