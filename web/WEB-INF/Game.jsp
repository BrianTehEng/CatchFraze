<%-- 
    Document   : Game
    Created on : 18-Apr-2016, 2:50:54 PM
    Author     : CodeFletcher
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      
    <style>
        
        textarea{
            font-size: 24px; 
        }
    </style>
    
    <h1>CatchFraze</h1>
    <h2> How to play: AVOID the red characters and CAPTURE the phrase in the right order!  <input type="button" value="NEW GAME" onClick="location.reload(true)"> </h2>
     
    <textarea id="myText" rows="23" readonly="readonly" cols="27">Hint:</textarea> 
    
    <canvas id="c" width="650" height="650"></canvas>
 



<script>
    
    
window.addEventListener('keydown',this.check,false);

var c = document.getElementById("c");
var ctx = c.getContext("2d");
var font_size = 30;
var col = c.width/font_size; 

var x_pos=Math.floor(col/2);
var y_pos=Math.floor(col/2);



function walker(symbol,x,y,font,columns,type){
    
    this.symbol=symbol;
    this.x=x;
    this.y=y;
    this.font=font;
    this.columns=columns;
    this.type=type; //either be "o" for open "a" attack "l" locked
    this.delay=0;
}

walker.prototype.updatePos=function(){
    
    if(this.delay==0){
    
        if(Math.random()>0.5 && this.x<this.columns){
           this.x++;
            
        }else{
            if(this.x>0)
            this.x--;
        }
        
        if(Math.random()>0.5 && this.y<this.columns){
           this.y++;
            
        }else{
            if(this.y>0)
            this.y--;
        }
       
    
    }
    
        this.delay++;
        this.delay%=90;
};

walker.prototype.updateRight=function(){
    
    if(this.x<this.columns-1){
        this.x++;
    }
    
};
walker.prototype.updateLeft=function(){
    
    if(this.x>1){
        this.x--;
    }
    
};
walker.prototype.updateDown=function(){
    
    if(this.y<this.columns-1){
        this.y++;
    }
    
};
walker.prototype.updateUp=function(){
    
    if(this.y >1){
        this.y--;
    }
    
};

walker.prototype.checkOverLap=function(walk){
    
    if(walk.x==this.x && walk.y==this.y){
        return true;
    }
    else{
        return false;
    }
}


function letters(){
    
    this.letter_walkers=[];
}

letters.prototype.createWalkers=function(word){
    
     var mywalker=new walker(word.charAt(0),x_pos,y_pos,"#0FF",col,"o");
     this.letter_walkers.push(mywalker);
     
   for(var i=1;i<word.length;i++){
       
       var mywalker=new walker(word.charAt(i),x_pos,y_pos,"#0FF",col,"l");
       this.letter_walkers.push(mywalker);
   }
    
};



var walkers = [];
var users = [];
var refreshIntervalId;


function check(event){
    
    var key=event.keyCode;
     
     if(key==39){
         users[0].updateRight();
     }
     
     if(key==37){
         users[0].updateLeft();
     }
     if(key==38){
         users[0].updateUp();
     }
     if(key==40){
         users[0].updateDown();
     }
    
    
};


function gameover(){
    

    ctx.clearRect(0, 0, c.width, c.height);
    ctx.fillStyle = "rgba(0, 0, 0, 1)";
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.font = 100 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText("Muahahah!...",0,400);
    
}

function winner(){
    
    ctx.clearRect(0, 0, c.width, c.height);
    ctx.fillStyle = "rgba(0, 0, 0, 1)";
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.font = 100 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText("Nice! XD",60,400);
    
}


function createPhrase(){
    
    var myLetters=new letters();
    myLetters.createWalkers('${phrase}');
    walkers=walkers.concat(myLetters.letter_walkers);
    (document.getElementById('myText').value) +="\n"+'${hint}'+"\n\n";
    
}


function startGame(){
    clearInterval(refreshIntervalId);
    walkers=[];
    users=[];
        
    var walker1=new walker("$",x_pos,y_pos,"#ff0000",col,"a");
    var walker2=new walker("&",x_pos,y_pos,"#ff0000",col,"a");
    var walker3=new walker("@",x_pos,y_pos,"#ff0000",col,"a");
    var walker4=new walker("#",x_pos,y_pos,"#ff0000",col,"a");
    var walker5=new walker("%",x_pos,y_pos,"#ff0000",col,"a");
    var walker6=new walker("^",x_pos,y_pos,"#ff0000",col,"a");
    var walker7=new walker("!",x_pos,y_pos,"#ff0000",col,"a");
    var walker8=new walker("*",x_pos,y_pos,"#ff0000",col,"a");
    var user1=new walker("U",1,1,"#FF0",col,"l");

    walkers.push(walker1);
    walkers.push(walker2);
    walkers.push(walker3);
    walkers.push(walker4);
    walkers.push(walker5);
    walkers.push(walker6);
    walkers.push(walker7);
    walkers.push(walker8);
    users.push(user1);
    
    createPhrase();
    refreshIntervalId = setInterval(draw, 10);
      
}

var is_user_alive=true;
//drawing the characters
function draw()
{
	//Black BG for the canvas
	//translucent BG to show trail
	ctx.fillStyle = "rgba(0, 0, 0, 1)";
	ctx.fillRect(0, 0, c.width, c.height);
	ctx.font = font_size + "px arial";
        
        //update users
        for(var k=0;k<users.length;k++){
            ctx.fillStyle =users[k].font;             
            ctx.fillText(users[k].symbol, users[k].x*font_size, users[k].y*font_size);
        }
           
       //update walkers
       for(var i=0;i<walkers.length;i++){
           walkers[i].updatePos();
           
           //Draw Walkers
            ctx.fillStyle =walkers[i].font;             
            ctx.fillText(walkers[i].symbol, walkers[i].x*font_size, walkers[i].y*font_size);
                      
           //Check overlaps
           if(walkers[i].checkOverLap(users[0])){
               
               if(walkers[i].type=="o"){
               
                document.getElementById('myText').value +=walkers[i].symbol;
               walkers.splice(i,1);
               //make the next letter open
               walkers[i].type="o";
            
             }
             //Check to see if eaten
             else if(walkers[i].type=="a"){
                 for(i=0;i<walkers.length;i++){
                 walkers.splice(0,1);}
                 gameover();
                 is_user_alive=false;
                 clearInterval(refreshIntervalId);
                                              
             }
             }     
             
          
            
        
                    
        }
        
	  
        if(walkers.length==8 && is_user_alive){
            winner();
            clearInterval(refreshIntervalId);
        }
        
}
  startGame();
</script>
</html>
