//You should implement your assign4 here.
PImage fighter, enemy, treasure, hpBar, bg1, bg2, bgGameStart, bgGameStart_light, bgGameOver, bgGameOver_light, bullet ;
PImage [] explodeFlame = new PImage [5] ;


final int GAME_START = 1, GAME_RUN = 2, GAME_OVER = 3;
final int FIGHTER_SPEED = 4, ENEMY_SPEED = 3, BG_SPEED = 1, BULLET_SPEED = 5 ;
final int GAME_WIDTH = 640, GAME_HEIGHT = 480 ;
final int FIGHTER_WIDTH = 50, FIGHTER_HEIGHT = 50 ;
final int ENEMY_WIDTH = 60, ENEMY_HEIGHT = 60 ;
final int TREASURE_WIDTH = 40, TREASURE_HEIGHT = 40 ;
final int HP_Max = 200;
final int LIVE = 0, DEAD = 1, EXPLODE = 2, OUT_FIELD = 0, IN_FIELD = 1; //enemy's or bullet's state
final int X = 0, Y = 1, STATE = 2, FLAMETIMES = 3; //use in array
final int BULLET_WIDTH = 30, BULLET_HEIGHT = 26 ;

boolean upPressed = false ;
boolean downPressed = false ;
boolean leftPressed = false ;
boolean rightPressed = false ;
boolean fire = false ;

int bg1X, bg2X, enemyX, enemyY, treasureX, treasureY, fighterX, fighterY, bulletX, bulletY;
int hpLength ;
int gameState, enemyWave;
int i, j;//counter
int [][]firstWaveEnemy = new int [5][4] ;
int [][]secondWaveEnemy = new int [5][4] ;
int [][]thirdWaveEnemy = new int [8][4] ;
int [][]magazine = new int [5][3];
int flameCunter, flameTimeCunter ;

void setup () {
  size(640, 480) ;
  fighter = loadImage("img/fighter.png");
  enemy = loadImage("img/enemy.png");
  treasure = loadImage("img/treasure.png");
  hpBar = loadImage("img/hp.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  bgGameStart = loadImage("img/start2.png");
  bgGameStart_light = loadImage("img/start1.png");
  bgGameOver = loadImage("img/end2.png");
  bgGameOver_light = loadImage("img/end1.png");
  bullet = loadImage("img/shoot.png");
  for(i=0;i<5;i++)explodeFlame[i] = loadImage("img/flame"+(i+1)+".png");
  
  gameState = GAME_START ;
  bg1X = -640;
  bg2X = 0;
  fighterX = 590 ;
  fighterY = 240;
  enemyX = -300 ; 
  enemyY = (int)random(45,420) ;
  treasureX = (int)random(0,540) ;
  treasureY = (int)random(45,440) ;
  hpLength = HP_Max/5 ;  
  enemyWave = 0;
  bulletX = 0 ;
  bulletY = 0 ;
  flameCunter = 0 ;
  
  for(i = 0 ; i < 5 ; i++){
    for(j = 0 ; j < 4 ; j++){
      firstWaveEnemy[i][j] = 0 ;
      secondWaveEnemy[i][j] = 0 ;
    }//for
  }//for
  for(i = 0 ; i < 8 ; i++){
    for(j = 0 ; j < 4 ; j++){
      thirdWaveEnemy[i][j] = 0 ;
    }//for
  }//for
  for(i = 0 ; i < 5 ; i++){
    for(j = 0 ; j < 3 ; j++){
      magazine[i][j] = 0 ;
    }//for
  }//for
  
  frameRate(50);

}//set up

void draw() {
  switch(gameState){    
    case GAME_START :
      image(bgGameStart,0,0);
      if( 208 <= mouseX && mouseX <= 453 && 378 <= mouseY && mouseY <= 412){
        image(bgGameStart_light,0,0) ;
        if(mousePressed)gameState = GAME_RUN ;
      }//if
      break;
      
    case GAME_RUN :
      image(bg1,bg1X,0); 
      image(bg2,bg2X,0);
      image(treasure,treasureX,treasureY) ;
      image(fighter,fighterX,fighterY);

      //----update each enemy location----//
      if(enemyWave==0){
        for(i = 0 ; i < 5 ; i++){
          if(firstWaveEnemy[i][STATE]==LIVE){
            firstWaveEnemy[i][X] = enemyX + i*ENEMY_WIDTH ;
            firstWaveEnemy[i][Y] = enemyY ;
            image(enemy,firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
          }//if
        }//for
      }//if
      if(enemyWave==1){
        for(i = 0 ; i < 5 ; i++){
          if(secondWaveEnemy[i][STATE]==LIVE){
            secondWaveEnemy[i][X] = enemyX + i*ENEMY_WIDTH ;
            secondWaveEnemy[i][Y] = enemyY - i*ENEMY_HEIGHT ;
            image(enemy,secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
          }//if
        }//for
      }//if
      if(enemyWave==2){
        for(i = 0 ; i < 4 ; i++){
          if(thirdWaveEnemy[i][STATE]==LIVE){
            thirdWaveEnemy[i][X] = enemyX + i*ENEMY_WIDTH ;
            if(i!=3)thirdWaveEnemy[i][Y] = enemyY - i*ENEMY_HEIGHT;
            else thirdWaveEnemy[i][Y] = enemyY - ENEMY_HEIGHT; 
            image(enemy,thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
          }//if
          if(thirdWaveEnemy[4+i][STATE]==LIVE){
            thirdWaveEnemy[4+i][X] = enemyX+4*ENEMY_WIDTH - i*ENEMY_WIDTH;
            if(i!=3)thirdWaveEnemy[4+i][Y] = enemyY + i*ENEMY_HEIGHT;
            else thirdWaveEnemy[4+i][Y] = enemyY + ENEMY_HEIGHT;
           image(enemy,thirdWaveEnemy[4+i][X],thirdWaveEnemy[4+i][Y]);
          }//if
        }//for
      }//if
      
      //----draw hp bar----//
      fill(#FF0000);
      rect(21,19,hpLength,16);
      image(hpBar,15,15);          
     
      //----enemy collision----//
      if(enemyWave==0){
        for(i=0;i<5;i++){  
          //if fighter hit enemy
          if( firstWaveEnemy[i][STATE]==LIVE && fighterX <= firstWaveEnemy[i][X]+ENEMY_WIDTH && fighterX+FIGHTER_WIDTH >= firstWaveEnemy[i][X] && fighterY <= firstWaveEnemy[i][Y]+ENEMY_HEIGHT && fighterY+FIGHTER_HEIGHT >= firstWaveEnemy[i][Y] ){
            hpLength -= HP_Max/5 ;
            firstWaveEnemy[i][STATE]=EXPLODE;
          }//if 
          //----if bullet hit enemy----//
          for(j=0;j<5;j++){
            if(magazine[j][STATE]==IN_FIELD && firstWaveEnemy[i][STATE]==LIVE && magazine[j][X] <= firstWaveEnemy[i][X]+ENEMY_WIDTH && magazine[j][X]+BULLET_WIDTH >= firstWaveEnemy[i][X] && magazine[j][Y] <= firstWaveEnemy[i][Y]+ENEMY_HEIGHT && magazine[j][Y]+BULLET_HEIGHT >= firstWaveEnemy[i][Y] ){
              firstWaveEnemy[i][STATE]=EXPLODE;
              magazine[j][STATE] = OUT_FIELD ;
            }//if
          }//for
        }//for
      }//if      
      if(enemyWave==1){
        for(i=0;i<5;i++){
          //if fighter hit enemy
          if( secondWaveEnemy[i][STATE]==LIVE && fighterX <= secondWaveEnemy[i][X]+ENEMY_WIDTH && fighterX+FIGHTER_WIDTH >= secondWaveEnemy[i][X] && fighterY <= secondWaveEnemy[i][Y]+ENEMY_HEIGHT && fighterY+FIGHTER_HEIGHT >= secondWaveEnemy[i][Y] ){
            hpLength -= HP_Max/5 ;            
            secondWaveEnemy[i][STATE]=EXPLODE;
          }//if
          //----if bullet hit enemy----//
          for(j=0;j<5;j++){
            if(magazine[j][STATE]==IN_FIELD && secondWaveEnemy[i][STATE]==LIVE && magazine[j][X] <= secondWaveEnemy[i][X]+ENEMY_WIDTH && magazine[j][X]+BULLET_WIDTH >= secondWaveEnemy[i][X] && magazine[j][Y] <= secondWaveEnemy[i][Y]+ENEMY_HEIGHT && magazine[j][Y]+BULLET_HEIGHT >= secondWaveEnemy[i][Y] ){
              secondWaveEnemy[i][STATE]=EXPLODE;
              magazine[j][STATE] = OUT_FIELD ;
            }//if
          }//for
          
        }//for
      }//if
      if(enemyWave==2){
        for(i=0;i<8;i++){
          //if fighter hit enemy
          if( thirdWaveEnemy[i][STATE]==LIVE && fighterX <= thirdWaveEnemy[i][X]+ENEMY_WIDTH && fighterX+FIGHTER_WIDTH >= thirdWaveEnemy[i][X] && fighterY <= thirdWaveEnemy[i][Y]+ENEMY_HEIGHT && fighterY+FIGHTER_HEIGHT >= thirdWaveEnemy[i][Y] ){
            hpLength -= HP_Max/5 ; 
            thirdWaveEnemy[i][STATE]=EXPLODE;
          }//if
          //----if bullet hit enemy----//
          for(j=0;j<5;j++){
            if(magazine[j][STATE]==IN_FIELD && thirdWaveEnemy[i][STATE]==LIVE && magazine[j][X] <= thirdWaveEnemy[i][X]+ENEMY_WIDTH && magazine[j][X]+BULLET_WIDTH >= thirdWaveEnemy[i][X] && magazine[j][Y] <= thirdWaveEnemy[i][Y]+ENEMY_HEIGHT && magazine[j][Y]+BULLET_HEIGHT >= thirdWaveEnemy[i][Y] ){
              thirdWaveEnemy[i][STATE]=EXPLODE;
              magazine[j][STATE] = OUT_FIELD ;
            }//if
          }//for
        }//for
      }//if     
      
      //----enemy explode----//
           if(enemyWave==0){   
              for(i = 0; i<5 ;i++){
                if(firstWaveEnemy[i][STATE]==EXPLODE){
                  if(0<=firstWaveEnemy[i][FLAMETIMES]&&firstWaveEnemy[i][FLAMETIMES]<5){                    
                      image(explodeFlame[0],firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
                      firstWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(5<=firstWaveEnemy[i][FLAMETIMES]&&firstWaveEnemy[i][FLAMETIMES]<10){                    
                      image(explodeFlame[1],firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
                      firstWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(10<=firstWaveEnemy[i][FLAMETIMES]&&firstWaveEnemy[i][FLAMETIMES]<15){                    
                      image(explodeFlame[2],firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
                      firstWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(15<=firstWaveEnemy[i][FLAMETIMES]&&firstWaveEnemy[i][FLAMETIMES]<20){                    
                      image(explodeFlame[3],firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
                      firstWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(20<=firstWaveEnemy[i][FLAMETIMES]&&firstWaveEnemy[i][FLAMETIMES]<25){                    
                      image(explodeFlame[4],firstWaveEnemy[i][X],firstWaveEnemy[i][Y]);
                      firstWaveEnemy[i][FLAMETIMES]++;
                  }//if  
                }//if
           }//for              
           }//if
           
           if(enemyWave==1){   
              for(i = 0; i<5 ;i++){
                if(secondWaveEnemy[i][STATE]==EXPLODE){
                  if(0<=secondWaveEnemy[i][FLAMETIMES]&&secondWaveEnemy[i][FLAMETIMES]<5){                    
                      image(explodeFlame[0],secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
                      secondWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(5<=secondWaveEnemy[i][FLAMETIMES]&&secondWaveEnemy[i][FLAMETIMES]<10){                    
                      image(explodeFlame[1],secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
                      secondWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(10<=secondWaveEnemy[i][FLAMETIMES]&&secondWaveEnemy[i][FLAMETIMES]<15){                    
                      image(explodeFlame[2],secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
                      secondWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(15<=secondWaveEnemy[i][FLAMETIMES]&&secondWaveEnemy[i][FLAMETIMES]<20){                    
                      image(explodeFlame[3],secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
                      secondWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(20<=secondWaveEnemy[i][FLAMETIMES]&&secondWaveEnemy[i][FLAMETIMES]<25){                    
                      image(explodeFlame[4],secondWaveEnemy[i][X],secondWaveEnemy[i][Y]);
                      secondWaveEnemy[i][FLAMETIMES]++;
                  }//if  
                }//if
           }//for              
           }//if
           
           if(enemyWave==2){   
              for(i = 0; i<8 ;i++){
                if(thirdWaveEnemy[i][STATE]==EXPLODE){
                  if(0<=thirdWaveEnemy[i][FLAMETIMES]&&thirdWaveEnemy[i][FLAMETIMES]<5){                    
                      image(explodeFlame[0],thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
                      thirdWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(5<=thirdWaveEnemy[i][FLAMETIMES]&&thirdWaveEnemy[i][FLAMETIMES]<10){                    
                      image(explodeFlame[1],thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
                      thirdWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(10<=thirdWaveEnemy[i][FLAMETIMES]&&thirdWaveEnemy[i][FLAMETIMES]<15){                    
                      image(explodeFlame[2],thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
                      thirdWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(15<=thirdWaveEnemy[i][FLAMETIMES]&&thirdWaveEnemy[i][FLAMETIMES]<20){                    
                      image(explodeFlame[3],thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
                      thirdWaveEnemy[i][FLAMETIMES]++;
                  }//if
                  if(20<=thirdWaveEnemy[i][FLAMETIMES]&&thirdWaveEnemy[i][FLAMETIMES]<25){                    
                      image(explodeFlame[4],thirdWaveEnemy[i][X],thirdWaveEnemy[i][Y]);
                      thirdWaveEnemy[i][FLAMETIMES]++;
                  }//if  
                }//if
           }//for              
           }//if
      
      //----get treasure----//
      if( fighterX <= treasureX+TREASURE_WIDTH && fighterX+FIGHTER_WIDTH >= treasureX && fighterY <= treasureY+TREASURE_HEIGHT && fighterY+FIGHTER_HEIGHT >= treasureY ){
        if( hpLength < HP_Max ) hpLength += HP_Max/10 ;
        treasureX = (int)random(0,540) ;
        treasureY = (int)random(45,440) ;
      }//if end
      
      //----bg move----//
      bg1X += BG_SPEED; bg2X += BG_SPEED; 
      if(640 < bg1X) bg1X = -640 ; 
      if(640 < bg2X) bg2X = -640 ;  
      
      //----fighter move----//
      if(upPressed)
        fighterY -= FIGHTER_SPEED ;        
      if(downPressed)
        fighterY += FIGHTER_SPEED ;        
      if(leftPressed)
        fighterX -= FIGHTER_SPEED ;        
      if(rightPressed)
        fighterX += FIGHTER_SPEED ;
        
      //----bullet fire----//
       if(fire){         
           for(i=0;i<5;i++){
             if(magazine[i][STATE]==OUT_FIELD){
               magazine[i][STATE]=IN_FIELD;
               magazine[i][X]=fighterX-BULLET_WIDTH ;
               magazine[i][Y]=fighterY + (FIGHTER_HEIGHT-BULLET_HEIGHT)/2 ;               
               fire = false ;
               break;
             }//if
           }//for
         }//if
      
      //----bullet fly----//
        for(i=0;i<5;i++){
          if(magazine[i][STATE]==IN_FIELD){
            image(bullet,magazine[i][X],magazine[i][Y]);
            magazine[i][X]-=BULLET_SPEED;
          }//if
          if(magazine[i][X]<0-BULLET_WIDTH){
            magazine[i][STATE]=OUT_FIELD;
          }//if
        }//for
        
      //----boundary detection----//  
      if(fighterX <=0)
        fighterX = 0 ;
      if( fighterX >= GAME_WIDTH-FIGHTER_WIDTH )
        fighterX = GAME_WIDTH - FIGHTER_WIDTH ;
      if(fighterY <=0)
        fighterY = 0 ;
      if( fighterY >= GAME_HEIGHT-FIGHTER_HEIGHT )
        fighterY = GAME_HEIGHT -FIGHTER_HEIGHT ;     
          
      //----enemy move----//
      enemyX +=  ENEMY_SPEED ;
      if(enemyX > 640){        
       enemyWave++;
       enemyWave = enemyWave%3 ;
        if(enemyWave == 0){
          enemyY = (int)(random(0,420));
          for(i=0;i<5;i++){
            firstWaveEnemy[i][STATE]=LIVE ;
            firstWaveEnemy[i][FLAMETIMES] = 0;
          }//for
        }//if
        else if(enemyWave == 1){
          enemyY = (int)(random(300,420));
          for(i=0;i<5;i++){
            secondWaveEnemy[i][STATE]=LIVE ;
            secondWaveEnemy[i][FLAMETIMES] = 0;
          }//for
        }//if
        else if(enemyWave ==2){
          enemyY = (int)(random(120,300));
          for(i=0;i<8;i++){
            thirdWaveEnemy[i][STATE]=LIVE ;
            thirdWaveEnemy[i][FLAMETIMES] = 0;
          }//for
        }//if
        enemyX = -300 ;  
      }//if

      //----out of hp----//
      if(hpLength <= 0)
        gameState = GAME_OVER ;   

      if(flameTimeCunter>=25)flameTimeCunter=0;
      break ;
      
    case GAME_OVER :
      image(bgGameOver,0,0) ;
      if( (mouseX>=209 && mouseX<= 433) && (mouseY>=311 && mouseY <=345) ){
        image(bgGameOver_light,0,0) ;
        if(mousePressed) {
          gameState = GAME_RUN ;
          bg1X = -640;
          bg2X = 0;
          fighterX = 590 ;
          fighterY = 240;
          enemyX = -300 ; 
          enemyY = (int)random(45,420) ;
          treasureX = (int)random(0,540) ;
          treasureY = (int)random(45,440) ;
          hpLength = HP_Max/5 ;  
          enemyWave = 0;
          bulletX = 0 ;
          bulletY = 0 ;
          flameCunter = 0 ;
          
          for(i = 0 ; i < 5 ; i++){
            for(j = 0 ; j < 4 ; j++){
              firstWaveEnemy[i][j] = 0 ;
              secondWaveEnemy[i][j] = 0 ;
            }//for
          }//for
          for(i = 0 ; i < 8 ; i++){
            for(j = 0 ; j < 4 ; j++){
              thirdWaveEnemy[i][j] = 0 ;
            }//for
          }//for
          for(i = 0 ; i < 5 ; i++){
            for(j = 0 ; j < 3 ; j++){
              magazine[i][j] = 0 ;
            }//for
          }//for
        }//if 
      }//if 
      break ;  
  }//switch
}//draw
void keyPressed(){
  if(key == CODED){
    switch(keyCode){      
      case UP :
        upPressed = true ;
        break ;         
      case DOWN :
        downPressed = true ;
        break ;        
      case LEFT :
        leftPressed = true ;
        break ;        
      case RIGHT :
        rightPressed = true ;
        break ;
    }//swtich  
  }//if
  if(key==' ')
    fire = true ;
}//keyPressed

void keyReleased(){  
  if(key == CODED){
    switch(keyCode){      
      case UP :
        upPressed = false ;
        break ;      
      case DOWN :
        downPressed = false ;
        break ;       
      case LEFT :
        leftPressed = false ;
        break ;      
      case RIGHT :
        rightPressed = false ;
        break ;
    }//swtich
  }//if
  if(key==' ')
    fire = false ;
}//keyReleased
