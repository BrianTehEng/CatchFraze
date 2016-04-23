/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


//Keeps time for highscores
function stopWatch(startTime){
    this.startTime=startTime;
    this.current=startTime;    
            
};
//get the current time since start
stopWatch.prototype.getCurrent=function(){
    
    this.current=Date.now()-this.startTime;
   
   return this.current;
};



//random walkers on canvas
function walker(symbol,x,y,font,columns,type){
    
    this.symbol=symbol;     //symbol displayed canvas
    this.x=x;               //x-coordinate
    this.y=y;               //y-coordinate
    this.font=font;         //font color
    this.columns=columns;   //number
    this.type=type; //either "o" for open letter "a" attacking walker "l" locked letter
    this.delay=0;   //delay walker from updating position
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
};

//container for walking phrase letters
function letters(){
    
    this.letter_walkers=[];
}

//create the walking letters of phrase
letters.prototype.createWalkers=function(word){
    
    //make the first letter open for capture
     var mywalker=new walker(word.charAt(0),x_pos,y_pos,"#0FF",col,"o");
     this.letter_walkers.push(mywalker);
     
   for(var i=1;i<word.length;i++){
       //close all other letters
       var mywalker=new walker(word.charAt(i),x_pos,y_pos,"#0FF",col,"l");
       this.letter_walkers.push(mywalker);
   }
    
};