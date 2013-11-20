//
//  Thief.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 5/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Thief.h"

#import "GameScreen.h"

@implementation Thief

-(id)initStartPoint:(CGPoint)p_start initDelegate:(GameScreen *)p_delegate
{
    if(self=[super init])
    {
        
        float assetScale = 1.0;
        if ( !IS_IPAD() && [DeviceSettings isRetina])
        {   
            assetScale = 0.5;
        } 
        if(!IS_IPAD())
        {      if ([DeviceSettings isRetina])
        {
            m_movement=0.25*iPAD2iPHONE_WIDTH_RATIO;
        }
        else
        {
            m_movement=0.25*iPAD2iPHONE_WIDTH_RATIO*0.5;
        }
        }
        else
        {
            m_movement=0.25;
        }

        self.position=p_start;
        
        //LEft and Turn
        m_delegategame=p_delegate;
        m_size=kCollectibleSize_small;
        m_itemWeight=20;
        m_points=1000;
        m_itemSellPrice=1000;
        m_thiefleftbatch=[CCSpriteBatchNode batchNodeWithFile:@"thief_set1.png"];
        m_thiefleft=[CCSprite spriteWithTexture:m_thiefleftbatch.texture rect:CGRectMake(0, 0, 100*assetScale, 117*assetScale)];
        m_thiefleft.visible=FALSE;
        m_framesleft=[[NSMutableArray alloc] init];
        
        m_thiefturnbatch=[CCSpriteBatchNode batchNodeWithFile:@"thief_set1.png"];
        m_thiefturn=[CCSprite spriteWithTexture:m_thiefturnbatch.texture rect:CGRectMake(0, 0, 100*assetScale, 117*assetScale)];
        m_thiefturn.visible=FALSE;
        m_framesturn=[[NSMutableArray alloc] init];
        
        int counter=0;
        for(int i=0;i<7;i++)
        {
            for(int j=0;j<10;j++)
            {
                counter++;
                if(counter>=1&&counter<=23)
                {
                    [m_framesleft addObject:[CCSpriteFrame frameWithTexture:m_thiefleft.texture rect:CGRectMake(j*100*assetScale, i*117*assetScale,100*assetScale, 117*assetScale)]];
                }
                else if(counter>=24&&counter<=37)
                 {
                      [m_framesturn addObject:[CCSpriteFrame frameWithTexture:m_thiefturn.texture rect:CGRectMake(j*100*assetScale, i*117*assetScale,100*assetScale, 117*assetScale)]];
                 }
            }
        }
            
              
      
        
        
        m_animleft=[CCAnimation animationWithFrames:m_framesleft delay:0.09f ];
        m_animateleft=[[CCAnimate actionWithAnimation:m_animleft restoreOriginalFrame:NO] retain];
        m_repeatleft=[[CCRepeatForever actionWithAction:m_animateleft ]retain];
        
        [self addChild:m_thiefleft];
        
        
        m_animturn=[CCAnimation animationWithFrames:m_framesturn delay:0.09f ];
        m_animateturn=[[CCAnimate actionWithAnimation:m_animturn restoreOriginalFrame:NO] retain];
        m_repeatturn=[[CCRepeatForever actionWithAction:m_animateturn ]retain];
        
        [self addChild:m_thiefturn];
        
        //Thief UP
        m_thiefupbatch=[CCSpriteBatchNode batchNodeWithFile:@"thief_set1.png"];
        m_thiefup=[CCSprite spriteWithTexture:m_thiefupbatch.texture rect:CGRectMake(0, 0, 100*assetScale, 117*assetScale)];
        m_thiefup.visible=FALSE;
        m_framesup=[[NSMutableArray alloc] init];
        
         counter=0;
        for(int i=0;i<7;i++)
        {
            for(int j=0;j<10;j++)
            {
                counter++;
                if(counter>=38&&counter<=61)
                {
                    [m_framesup addObject:[CCSpriteFrame frameWithTexture:m_thiefup.texture rect:CGRectMake(j*100*assetScale, i*117*assetScale,100*assetScale, 117*assetScale)]];
                }
             
            }
        }
        
        m_animup=[CCAnimation animationWithFrames:m_framesup delay:0.09f ];
        m_animateup=[[CCAnimate actionWithAnimation:m_animup restoreOriginalFrame:NO] retain];
        m_repeatup=[[CCRepeatForever actionWithAction:m_animateup ]retain];
        
        [self addChild:m_thiefup];
        
        //Thief grab and grabbed
        m_thiefgrabbatch=[CCSpriteBatchNode batchNodeWithFile:@"thief_set2.png"];
        m_thiefgrab=[CCSprite spriteWithTexture:m_thiefgrabbatch.texture rect:CGRectMake(0, 0, 100*assetScale, 117*assetScale)];
        m_thiefgrab.visible=FALSE;
        m_framesgrab=[[NSMutableArray alloc] init];
        
        m_thiefgrabbedbatch=[CCSpriteBatchNode batchNodeWithFile:@"thief_set2.png"];
        m_thiefgrabbed=[CCSprite spriteWithTexture:m_thiefgrabbedbatch.texture rect:CGRectMake(0, 0, 100*assetScale, 117*assetScale)];
        m_thiefgrabbed.visible=FALSE;
        m_framesgrabbed=[[NSMutableArray alloc] init];

        
        counter=0;
        for(int i=0;i<4;i++)
        {
            for(int j=0;j<10;j++)
            {
                counter++;
                if(counter>=1&&counter<=28)
                {
                    [m_framesgrab addObject:[CCSpriteFrame frameWithTexture:m_thiefgrab.texture rect:CGRectMake(j*100*assetScale, i*117*assetScale,100*assetScale, 117*assetScale)]];
                }
                else if(counter>=29&&counter<=34)
                {
                    [m_framesgrabbed addObject:[CCSpriteFrame frameWithTexture:m_thiefgrabbed.texture rect:CGRectMake(j*100*assetScale, i*117*assetScale,100*assetScale, 117*assetScale)]];
                }

                
            }
        }
        m_animgrab=[CCAnimation animationWithFrames:m_framesgrab delay:0.09f ];
        m_animategrab=[[CCAnimate actionWithAnimation:m_animgrab restoreOriginalFrame:NO] retain];
        m_repeatgrab=[[CCRepeatForever actionWithAction:m_animategrab ]retain];
        
        [self addChild:m_thiefgrab];
        
        m_animgrabbed=[CCAnimation animationWithFrames:m_framesgrabbed delay:0.02f ];
        m_animategrabbed=[[CCAnimate actionWithAnimation:m_animgrabbed restoreOriginalFrame:NO] retain];
        m_repeatgrabbed=[[CCRepeatForever actionWithAction:m_animategrabbed ]retain];
        
        [self addChild:m_thiefgrabbed];


        

        
        
        
        
        
        
        
        
    }
    return self;
}



-(void)dealloc
{
    [m_framesup release];
    
    [m_animateup release];
    
    [m_repeatup release];
    
    [m_framesleft release];
    
    [m_animateleft release];
    
    [m_repeatleft release];
    
    [m_repeatturn release];
    
    [m_animateturn release];
    
    [m_repeatturn release];
    
    [m_framesgrab release];
    
    [m_animategrab release];
    
    [m_repeatgrab release];
    
    [m_framesgrabbed release];
    
    [m_animategrabbed release];
    
    [m_repeatgrabbed release];
    
    [super dealloc];
}




//Action Checker
-(void)actionChecker:(RUNNING_ACTION_THIEF)p_willrun
{
    if(isRunning==THIEF_WALK){
        
        [m_thiefleft stopAllActions];
        
    }
    else if(isRunning!=p_willrun&&isRunning==THIEF_GRAB){
        
        [m_thiefgrab stopAllActions];
        
    }
    else if(isRunning!=p_willrun&&isRunning==THIEF_GRABBED){
        
        [m_thiefgrabbed stopAllActions];
        
    }
    else if(isRunning!=p_willrun&&isRunning==THIEF_TURN){
        
        [m_thiefturn stopAllActions];
        
    }
    else if(isRunning==THIEF_UP){
        
        [m_thiefup stopAllActions];
        
    }
    isRunning=p_willrun;
}



-(void)ThiefLeft:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face
{
    
    [self actionChecker:THIEF_WALK];
    if(p_face==YES)
    {
        m_thiefleft.scaleX=-1;    
    }
    else
    {
        m_thiefleft.scaleX=1;     
    }
    
    m_thiefleft.visible=TRUE;
    m_thiefturn.visible=FALSE;
    m_thiefgrab.visible=FALSE;
    m_thiefgrabbed.visible=FALSE;
    m_thiefup.visible=FALSE;
    
    if(p_loop==YES)
    {
        [m_thiefleft runAction:m_repeatleft];
    }
    else
    {
        if(p_delegate!=nil)
        {
            id callbackfly=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
            [m_thiefleft runAction:[CCSequence actions:m_animateleft,callbackfly, nil]];
        }
        else
        {
            [m_thiefleft runAction:m_animateleft];   
        }
    }
    
}

-(void)ThiefUp:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method 
{
    
    [self actionChecker:THIEF_UP];
    
    m_thiefleft.visible=FALSE;
    m_thiefturn.visible=FALSE;
    m_thiefgrab.visible=FALSE;
    m_thiefgrabbed.visible=FALSE;
     m_thiefup.visible=TRUE;
    
    if(p_loop==YES)
    {
        [m_thiefup runAction:m_repeatup];
    }
    else
    {
        if(p_delegate!=nil)
        {
            id callbackfly=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
            [m_thiefup runAction:[CCSequence actions:m_animateup,callbackfly, nil]];
        }
        else
        {
            [m_thiefup runAction:m_animateup];   
        }
    }
    
}

-(void)ThiefTurn:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method
{
    [self actionChecker:THIEF_TURN];
    m_thiefleft.visible=FALSE;
    m_thiefturn.visible=TRUE;
    m_thiefgrab.visible=FALSE;
    m_thiefgrabbed.visible=FALSE;
    m_thiefup.visible=FALSE;
    
    if(p_loop==YES)
    {
        [m_thiefturn runAction:m_repeatturn];
    }
    else
    {
        if(p_delegate!=nil)
        {
            id callbackfly=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
            [m_thiefturn runAction:[CCSequence actions:m_animateturn,callbackfly, nil]];
        }
        else
        {
            [m_thiefturn runAction:m_animateturn];   
        }
    }
    
    
}

-(void)ThiefGrab:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method
{
    [self actionChecker:THIEF_GRAB];
    m_thiefleft.visible=FALSE;
    m_thiefturn.visible=FALSE;
    m_thiefgrab.visible=TRUE;
    m_thiefgrabbed.visible=FALSE;
     m_thiefup.visible=FALSE;
    
    if(p_loop==YES)
    {
        [m_thiefgrab runAction:m_repeatgrab];
    }
    else
    {
        if(p_delegate!=nil)
        {
            CCCallFunc* callbackfly=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
            CCCallFunc* callback=[CCCallFunc actionWithTarget:m_delegate selector:@selector(ScheduletoSteal)];

            [m_thiefgrab runAction:[CCSequence actions:[CCSpawn actions:m_animategrab,callbackfly, nil ],callback, nil]];
        }
        else
        {
            [m_thiefgrab runAction:m_animategrab];   
        }
    }
    
    
    
    
}

-(float)getRadius
{
    float ratio = ((GameScreen*)m_delegategame).worldScale;
    float radius;
    if(!IS_IPAD()&&![DeviceSettings isRetina])
    {
        radius = ([m_thiefleft boundingBox].size.height/2)/2;
    }
    else
    {
        radius = [m_thiefleft boundingBox].size.height/2;
    }
    return radius/ratio;
    
}


-(void)ThiefGrabbed:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method angle:(int)p_angle
{
    [self actionChecker:THIEF_GRABBED];
    
    m_thiefleft.visible=FALSE;
    m_thiefturn.visible=FALSE;
    m_thiefgrab.visible=FALSE;
    m_thiefgrabbed.visible=TRUE;
    m_thiefup.visible=FALSE;
    
    if(p_loop==YES)
    {
        [m_thiefgrabbed runAction:m_repeatgrabbed];
    }
    else
    {
        if(p_delegate!=nil)
        {
            id callbackfly=[CCCallFunc actionWithTarget:self selector:@selector(CheatFunction)];
            [m_thiefgrabbed runAction:[CCSequence actions:m_animategrabbed,callbackfly, nil]];
        }
        else
        {
            [m_thiefgrabbed runAction:m_animategrabbed];   
        }
    }
    
}
-(void)animalGrabbed:(id)p_delegate setMethod:(SEL)p_method angle:(int)p_angle
{
   
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [self ThiefGrabbed:NO setDelegate:p_delegate setMethod:p_method angle:p_angle];
    m_delegategame=p_delegate;
    m_delegate=p_delegate;

    
}
-(void)StopAndEat:(id)p_delegate setMethod:(SEL)p_method
{
    
    [self unschedule:@selector(ThiefStealMove)];
    m_itemtosteal=nil;
    [self ThiefGrab:NO setDelegate:p_delegate setMethod:p_method];
}
-(void)itemtosteal:(id)p_delegate setGameDelegate:(id)p_delegate2
{
    m_delegate=p_delegate2;
    m_itemtosteal=p_delegate;
    [self schedule:@selector(ThiefStealMove)];
    
    float distancex=fabsf(m_itemtosteal.position.x-self.position.x);
    float distancey=fabsf(m_itemtosteal.position.y-self.position.y);
    if(distancex>10.0)
    {
        if(self.position.x<m_itemtosteal.position.x)
        {
        [self ThiefLeft:YES setDelegate:nil setMethod:nil isFacingOpposite:YES];
        }
        else
        {
        [self ThiefLeft:YES setDelegate:nil setMethod:nil isFacingOpposite:NO];
        }
    }
    else
    {
        if(distancey>10.0)
        {
            [self ThiefUp:YES setDelegate:nil setMethod:nil];
        }

        
    }
   
}

-(void)ThiefStealMove
{
   
    
    float distancex=fabsf(m_itemtosteal.position.x-self.position.x);
    float distancey=fabsf(m_itemtosteal.position.y-self.position.y);
    
    if(distancex>10.0)
    {
        if(m_itemtosteal.position.x>self.position.x)
        {
            CGPoint pos=self.position;
            pos.x+=m_movement;
            self.position=pos;
        }
        else
        {
            CGPoint pos=self.position;
            pos.x-=m_movement;
            self.position=pos;
        }
    }
    else
    {
    
        if(distancey>10.0)
        {
            if(isRunning!=THIEF_UP){
                [self ThiefUp:YES setDelegate:nil setMethod:nil];
            }
            if(m_itemtosteal.position.y>self.position.y)
            {
                CGPoint pos=self.position;
                pos.y+=m_movement;
                self.position=pos;
            }
            else
            {
                CGPoint pos=self.position;
                pos.y-=m_movement;
                self.position=pos;
            }
            
        }
        
    }

    
}
-(void)positioninClamp
{
    
    float ratio = ((GameScreen*)m_delegategame).worldScale;
  
    self.position = ccp(-[self getRadius]*ratio*0.2,-[self getRadius]*ratio*0.10);  

}
-(float)customGrab
{
    return [self getRadius]/3;
}
@end
