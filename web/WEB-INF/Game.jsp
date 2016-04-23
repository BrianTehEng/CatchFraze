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
    <input type="button" value="New Fraze" onClick="newPhrase()" > <br><br>
    
    <textarea id="myText" rows="22" readonly="readonly" cols="27">Hint:</textarea>
    <canvas id="c" width="650" height="650"></canvas>
    <textarea id="myScore" rows="22" readonly="readonly" cols="27"></textarea> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script src="js/extraObjects.js"></script>
    
<script>
    
    
window.addEventListener('keydown',this.check,false);

//get canvas context for drawing methods
var c = document.getElementById("c");
var ctx = c.getContext("2d");
var font_size = 30;

//number of columns in canvas
var col = c.width/font_size; 

//inital x/y position of walkers
var x_pos=Math.floor(col/2);
var y_pos=Math.floor(col/2);

//arrays for walkers and users
var walkers = [];
var users = [];

//create timer for game
var myTimer=new stopWatch();


var refreshIntervalId;
var is_user_alive=true;

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


function newPhrase(){
    
    location.reload();
       
}

function gameover(){
    

    ctx.clearRect(0, 0, c.width, c.height);
    ctx.fillStyle = "rgba(0, 0, 0, 1)";
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.font = 50 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText("Muahahah!...",25,70);
    ctx.font = 60 + "px arial";
    ctx.fillText("Click to try again!",25,200);
    
    //Start Game by click
    $(document).ready(function(){
    $("#c").on("click",function(){
      startGame();
        
    });
    });
    
}

function checkHighScores(data){
    
    
    var completionTime=myTimer.getCurrent();
    
    completionTime=Math.floor(completionTime/100);
    
    var first=data['first_time'];
    var second=data['second_time'];
    var third=data['third_time'];
    
    if(completionTime<third){
       place="third";
     
     if(completionTime<second){
         place ="second";
        
    }
    if(completionTime<first){
        
        place="first";
        }
    
    var name=prompt("New Record!\nPlease enter your name", place);
      
        $.post("",{name: name,time: completionTime,place:place,id:'${id}'}).done(function(){
        getData().done(handleData);
                           
        }); 
    
    }         
}

//gets highscore data from servlet
function getData(){

    return $.get("getData",{id:'${id}'});
}

//send data to create Leader Board
function handleData(data){
  
    createLeaderBoard(data);
    
}

function winner(){
    
    
    getData().done(checkHighScores);
    
    //draw winning message on canvas
    ctx.clearRect(0, 0, c.width, c.height);
    ctx.fillStyle = "rgba(0, 0, 0, 1)";
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.font = 50 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText("Nice! XD",10,100);
    ctx.fillText("Click to try again",10,200);
    
    //Start Game by click turned on
    $(document).ready(function(){
    $("#c").on("click",function(){
      startGame();
        
    });
    });
       
}

function drawTime(){
   
   
   var time=myTimer.getCurrent();
   var seconds=Math.floor(time/1000);
   var tenths=Math.floor((time-seconds*1000)/100);
 
    ctx.font = 24 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText(seconds+"."+tenths,c.width-60,60);
     
}


function createPhrase(){
    //reset Hint Text
    (document.getElementById('myText').value) ="|------Hint------|\n";
    
    var myLetters=new letters();
    myLetters.createWalkers('${phrase}');
    walkers=walkers.concat(myLetters.letter_walkers);
    (document.getElementById('myText').value) +="\n"+'${hint}'+"\n\n";
    (document.getElementById('myText').value) +="\n\n|----Phrase----|\n";

        
}


function createLeaderBoard(data){
    
    //format times
     var first_seconds=Math.floor(data['first_time']/10);
     var first_tenths=data['first_time']-first_seconds;
     
     var second_seconds=Math.floor(data['second_time']/10);
     var second_tenths=data['second_time']-second_seconds;
     
     var third_seconds=Math.floor(data['third_time']/10);
     var third_tenths=data['third_time']-third_seconds;
  
  
    
    (document.getElementById('myScore').value) ="\n|=====|~Leader Board~|=====|\n";
    (document.getElementById('myScore').value) +="\n1. "+data['first']+"   "+first_seconds+"."+first_tenths+"s\n";
    (document.getElementById('myScore').value) +="\n2. "+data['second']+"  "+second_seconds+"."+second_tenths+"s\n";
    (document.getElementById('myScore').value) +="\n3. "+data['third']+"   "+third_seconds+"."+third_tenths+"s\n";

 
    
    }

function showRules(){
    
    
    //Start Game by click
    $(document).ready(function(){
    $("#c").on("click",function(){
      startGame();
        
    });
    });
    
    ctx.clearRect(0, 0, c.width, c.height);
    ctx.fillStyle = "rgba(0, 0, 0, 1)";
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.font = 30 + "px arial";
    ctx.fillStyle ="#808080";             
    ctx.fillText("Use Arrow Keys",25,60);
    ctx.fillText("Avoid Red Characters",25,140);
    ctx.fillText("Capture the Phrase",25,220);
    ctx.fillText("In Order",25,300);
    
    
     ctx.font = 50 + "px arial";
     ctx.fillText("Click to Start",55,460);
    
    }


function startGame(){
    
    //turn off click to start    
    $('#c').off("click");
    //clear draw interval
    clearInterval(refreshIntervalId);
    //empty walkers and users
    walkers=[];
    users=[];
    is_user_alive=true;
     
    //Initialize Timer
    myTimer.startTime=Date.now();
    
    //create walkers and user    
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
    //start draw function
    refreshIntervalId = setInterval(draw, 10);
      
}

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
        
        drawTime();
        
        //check to see if user won
	if(walkers.length==8 && is_user_alive){
            winner();
            clearInterval(refreshIntervalId);
            drawTime();
        }
        
} //initialize game
  showRules();
  //show highscores
  getData().done(handleData);
  //show phrase
  createPhrase();
  
 
</script>
</html>
