//
//  Parrot.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 5/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Parrot.h"

#import "GameScreen.h"

@implementation Parrot

-(id)initStartPoint:(CGPoint)p_start EndPoint:(CGPoint)p_stop duration:(ccTime *)p_time initDelegate:(GameScreen *)p_delegate
{
    if(self=[super initStartPoint: p_start EndPoint: p_stop duration: p_time initDelegate:p_delegate])
    {
        float assetScale = 1.0;
        if ( !IS_IPAD() && [DeviceSettings isRetina])
        {   
            assetScale = 0.5;
        } 
        if(!IS_IPAD())
        {      
            if ([DeviceSettings isRetina])
            {
                m_movement=1*iPAD2iPHONE_WIDTH_RATIO;
            }
            else
            {
                m_movement=0.2*iPAD2iPHONE_WIDTH_RATIO;
            }
        }
        else
        {
            m_movement=1;
        }
        isHostile = true;
        m_size=kCollectibleSize_small;
        m_itemWeight=10;
        m_points=1000;
        m_itemSellPrice=1000;
        isRunning=PARROT_ANIMATION;
        
        
        
        //PArrot Fly
        m_parrotflybatch=[CCSpriteBatchNode batchNodeWithFile:@"parrotfly.png"];
        m_parrotfly=[CCSprite spriteWithTexture:m_parrotflybatch.texture rect:CGRectMake(0, 0, 71*assetScale, 61*assetScale)];
        m_parrotfly.visible=FALSE;
        m_framesfly=[[NSMutableArray alloc] init];
        
        for(int i=0;i<1;i++)
        {
            for(int j=0;j<6;j++)
            {
                
                [m_framesfly addObject:[CCSpriteFrame frameWithTexture:m_parrotfly.texture rect:CGRectMake(j*71*assetScale, i*61*assetScale, 71*assetScale, 61*assetScale)]];
            }
            
        }
        
        m_animfly=[CCAnimation animationWithFrames:m_framesfly delay:0.09f ];
        m_animatefly=[[CCAnimate actionWithAnimation:m_animfly restoreOriginalFrame:NO] retain];
        m_repeatfly=[[CCRepeatForever actionWithAction:m_animatefly ]retain];
        [self addChild:m_parrotfly];
        
        
        //Parrot Attack
        m_parrotattackbatch=[CCSpriteBatchNode batchNodeWithFile:@"parrotattack.png"];
        m_parrotattack=[CCSprite spriteWithTexture:m_parrotattackbatch.texture rect:CGRectMake(0, 0, 71*assetScale, 61*assetScale)];
        m_parrotattack.visible=FALSE;
        m_framesattack=[[NSMutableArray alloc] init];
        
        for(int i=0;i<2;i++)
        {
            for(int j=0;j<14;j++)
            {
                if(j==5&&i==1){
                    break;
                }
                
                [m_framesattack addObject:[CCSpriteFrame frameWithTexture:m_parrotattack.texture rect:CGRectMake(j*71*assetScale, i*61*assetScale, 71*assetScale, 61*assetScale)]];
            }
            
        }
        
        m_animattack=[CCAnimation animationWithFrames:m_framesattack delay:0.09f ];
        m_animateattack=[[CCAnimate actionWithAnimation:m_animattack restoreOriginalFrame:NO] retain];
        
        [self addChild:m_parrotattack];
        
        //PArrot Turn
        
        m_parrotturnbatch=[CCSpriteBatchNode batchNodeWithFile:@"parrotturn.png"];
        m_parrotturn=[CCSprite spriteWithTexture:m_parrotturnbatch.texture rect:CGRectMake(0, 0, 71*assetScale, 61*assetScale)];
        m_parrotturn.visible=FALSE;
        m_framesturn=[[NSMutableArray alloc] init];
        
        for(int i=0;i<1;i++)
        {
            for(int j=0;j<7;j++)
            {
                
                
                [m_framesturn addObject:[CCSpriteFrame frameWithTexture:m_parrotturn.texture rect:CGRectMake(j*71*assetScale, i*61*assetScale, 71*assetScale, 61*assetScale)]];
            }
            
        }
        
        m_animturn=[CCAnimation animationWithFrames:m_framesturn delay:0.09f ];
        m_animateturn=[[CCAnimate actionWithAnimation:m_animturn restoreOriginalFrame:NO] retain];
        
        [self addChild:m_parrotturn];
        
        
        
        
        //PArrot Grabbed
        
        m_parrotgrabbedbatch=[CCSpriteBatchNode batchNodeWithFile:@"parrotgrabbed.png"];
        m_parrotgrabbed=[CCSprite spriteWithTexture:m_parrotgrabbedbatch.texture rect:CGRectMake(0, 0, 71*assetScale, 61*assetScale)];
        m_parrotgrabbed.visible=FALSE;
        m_framesgrabbed=[[NSMutableArray alloc] init];
        
        for(int i=0;i<1;i++)
        {
            for(int j=0;j<4;j++)
            {
                
                
                [m_framesgrabbed addObject:[CCSpriteFrame frameWithTexture:m_parrotgrabbed.texture rect:CGRectMake(j*71*assetScale, i*61*assetScale, 71*assetScale, 61*assetScale)]];
            }
            
        }
        
        m_animgrabbed=[CCAnimation animationWithFrames:m_framesgrabbed delay:0.04f ];
        m_animategrabbed=[[CCAnimate actionWithAnimation:m_animgrabbed restoreOriginalFrame:NO] retain];
        m_repeatgrabbed=[[CCRepeatForever actionWithAction:m_animategrabbed] retain];
        
        
        [self addChild:m_parrotgrabbed];
        
        if(endPoint.x<startPoint.x)
        {
            m_movetoend=YES;
            m_changeDirection=NO;
          
            [self ParrotFly:YES setDelegate:nil setMethod:nil isFacingOpposite:NO];
        }
        else if(endPoint.x>startPoint.x)
        {
            m_movetoend=YES;
            m_changeDirection=YES;
      
            
            [self ParrotFly:YES setDelegate:nil setMethod:nil isFacingOpposite:YES];
            
        }
        
        [self schedule:@selector(ParrotWalking)];
    }
    return self;
    
    
}

//Dealloc
-(void)dealloc
{
    [m_repeatgrabbed release];
    
    [m_framesgrabbed release];
    
    [m_parrotgrabbed release];
    
    [m_framesattack release];
    
    [m_framesfly release];
    
    [m_framesturn release];
    
    [m_animateattack release];
    
    [m_animateturn release];
    
    [m_animatefly release];
    
    [super dealloc];
}
//PArrot
-(void)AnimalWithAttack:(id)p_delegate setMethod:(SEL)p_method targetPosition:(CGPoint)p_target
{
    CGPoint toPosition1 = p_target;
    CCMoveTo* mineMove1 = [CCMoveTo actionWithDuration:0.5 position:toPosition1];
    CCEaseSineOut* easeMineMove1 = [CCEaseSineOut actionWithAction:mineMove1];
    [self runAction:easeMineMove1];
    [self ParrotAttack:p_delegate setMethod:p_method isFacingOpposite:YES angle:p_target];
}
//Over Ride GetRAdius in PArrot
-(float)getRadius
{
    float ratio = ((GameScreen*)m_delegategame).worldScale;
    float radius;
    if(!IS_IPAD()&&![DeviceSettings isRetina])
    {
        radius = ([m_parrotfly boundingBox].size.height-10)/2;
    }
    else
    {
        radius = [m_parrotfly boundingBox].size.height-10;
    }
    return radius/ratio;
}


//Remove Animal
-(void)Remove
{
    CCCallFuncND* callRemove = [CCCallFuncND actionWithTarget:m_delegate selector:@selector(removeMine:) data:self];    
    [self runAction:callRemove];
}


//OverRide ANIMAL GRABBED

-(void)animalGrabbed:(id)p_delegate setMethod:(SEL)p_method angle:(int)p_angle
{   [self unscheduleAllSelectors];
    [self stopAllActions];
    [self ParrotGrabbed:NO setDelegate:p_delegate setMethod:p_method isFacingOpposite:m_changeDirection angle:p_angle];
    m_delegategame=p_delegate;
    m_delegate=p_delegate;
}

//Change Direction PArrot


-(void)ParrotFlyCall
{
    
    
    [self ParrotFly:YES setDelegate:nil setMethod:nil isFacingOpposite:m_changeDirection];    
    
    
    
}

-(void)actionChecker:(RUNNING_ACTION_PARROT)p_willrun
{
    if(p_willrun!=isRunning&&isRunning==PARROT_ATTACK)
    {
        [m_parrotattack stopAllActions];
    }
    else if(p_willrun!=isRunning&&isRunning==PARROT_TURN)
    {
        [m_parrotturn stopAllActions];
    }
    else if(p_willrun!=isRunning&&isRunning==PARROT_FLY)
    {
        [m_parrotfly stopAllActions];
    }
    else if(p_willrun!=isRunning&&isRunning==PARROT_GRABBED)
    {
        [m_parrotgrabbed stopAllActions];
    }
    
    
    isRunning=p_willrun;
    
}

//PArrot FLy
-(void)ParrotFly:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face
{
    [self actionChecker:PARROT_FLY];
    if(p_face==YES)
    {
        m_parrotfly.scaleX=-1;    
    }
    else{
        m_parrotfly.scaleX=1;
    }
    m_parrotfly.visible=TRUE;
    m_parrotattack.visible=FALSE;
    m_parrotturn.visible=FALSE;
    m_parrotgrabbed.visible=FALSE;
    
    if(p_loop==YES)
    {
        [m_parrotfly runAction:m_repeatfly];
    }
    else
    {
        if(p_delegate!=nil)
        {
            id callbackfly=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
            [m_parrotfly runAction:[CCSequence actions:m_animatefly,callbackfly, nil]];
        }
        else
        {
            [m_parrotfly runAction:m_animatefly];   
        }
    }
    
    
}

-(void)ParrotAttack:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face angle:(CGPoint)p_target
{
    [self actionChecker:PARROT_ATTACK];
    
    if(p_face==YES)
    {
        m_parrotattack.scaleX=-1;    
    }
    else
    {
        m_parrotattack.scaleX=1;
    }
    m_parrotfly.visible=FALSE;
    m_parrotattack.visible=TRUE;
    m_parrotturn.visible=FALSE;
    m_parrotgrabbed.visible=FALSE;
    if(p_delegate!=nil)
    {
        
        CGPoint toPosition2 = CGPointZero;
        CCMoveTo* mineMove2 = [CCMoveTo actionWithDuration:0.8 position:toPosition2];
        CCEaseSineOut* easeMineMove2 = [CCEaseSineOut actionWithAction:mineMove2]; 
        CCScaleTo* mineScale = [CCScaleTo actionWithDuration:0.8 scale:0];
        CCSpawn* mineMoveScale = [CCSpawn actions:easeMineMove2, mineScale, nil];
        
        id callbackattack=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
        id remove=[CCCallFunc actionWithTarget:self selector:@selector(Remove)];
        [m_parrotattack runAction:[CCSequence actions:m_animateattack,callbackattack,mineMoveScale,remove, nil]];
    }
    else
    {
        [m_parrotattack runAction:m_animateattack];   
    }
    
}

-(void)ParrotTurn:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face
{
    [self actionChecker:PARROT_TURN];
    if(p_face==YES){
        m_parrotturn.scaleX=-1;
    }
    else
    {
        m_parrotturn.scaleX=1;
    }
    m_parrotfly.visible=FALSE;
    m_parrotattack.visible=FALSE;
    m_parrotturn.visible=TRUE;
    m_parrotgrabbed.visible=FALSE;
    
    if(p_delegate!=nil)
    {
        id callbackturn=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
        [m_parrotturn runAction:[CCSequence actions:m_animateturn,callbackturn, nil]];
    }
    else
    {
        [m_parrotturn runAction:m_animateturn];   
    }
    
    
}
-(void)ParrotGrabbed:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face angle:(int)p_angle
{
    [self actionChecker:PARROT_TURN];
    if(p_face==YES)
    {
        m_parrotgrabbed.scaleX=-1;
    }
    else{
        m_parrotgrabbed.scaleX=1;
    }
    m_parrotfly.visible=FALSE;
    m_parrotattack.visible=FALSE;
    m_parrotturn.visible=FALSE;
    m_parrotgrabbed.visible=TRUE;
    
    if(p_loop==YES){
        [m_parrotgrabbed runAction:m_repeatgrabbed];
    }
    
    else{ 
        if(p_delegate!=nil)
        {
           // CCRotateTo *rotateAction = [CCRotateTo actionWithDuration:COLLECTIBLES_TRANSFORM_DURATION angle:p_angle];
            
            CCCallFunc* c=[CCCallFunc actionWithTarget:self selector:@selector(CheatFunction)];
            
            [m_parrotgrabbed runAction:[CCSequence actions:[CCSpawn actions:m_animategrabbed, nil],c, nil]];
        }
        else
        {
            [m_parrotgrabbed runAction:m_animategrabbed];   
        }
    }
}



-(void)ParrotWalking
{
    
    
    if(m_movetoend==YES){
        if(startPoint.x<endPoint.x)
        {
            float distancex=fabsf(self.position.x-endPoint.x);
            if(distancex>3){
                CGPoint pos=self.position;
                pos.x+=m_movement;
                self.position=pos;
            }
            else 
            {
                m_movetoend=NO;
                if(m_changeDirection==YES){
                    [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                    
                }
                else{
                      [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=YES;
                    
                }
                
            }
        }
        else
        {
            float distancex=fabsf(self.position.x-endPoint.x);
            if(distancex>3){
                CGPoint pos=self.position;
                pos.x-=m_movement;
                self.position=pos;
            }
            else 
            {
                m_movetoend=NO;
                if(m_changeDirection==YES){
                  [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                    
                }
                else{
                     [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=YES;
                    
                }
                
            }
            
        }
    }
    else
    {
        if(startPoint.x<endPoint.x)
        {
            float distancex=fabsf(self.position.x-startPoint.x);
            if(distancex>3){
                CGPoint pos=self.position;
                pos.x-=m_movement;
                self.position=pos;
            }
            else 
            {
                m_movetoend=YES;
                if(m_changeDirection==YES)
                {
                      [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                }
                else
                {
                    [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=YES;
                    
                }
                
            }
        }
        else
        {
            float distancex=fabsf(self.position.x-startPoint.x);
            if(distancex>3){
                CGPoint pos=self.position;
                pos.x+=m_movement;
                self.position=pos;
            }
            else 
            {
                m_movetoend=YES;
                if(m_changeDirection==YES)
                {
                      [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                }
                else
                {
                      [self ParrotTurn:self setMethod:@selector(ParrotFlyCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=YES;
                    
                }
                
            }
            
            
        }
        
        
    }
    
}





@end
