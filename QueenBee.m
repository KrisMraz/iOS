//
//  QueenBee.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "QueenBee.h"

#import "GameScreen.h"

@implementation QueenBee
-(id)initStartPoint:(CGPoint)p_start EndPoint:(CGPoint)p_stop duration:(ccTime *)p_time initDelegate:(GameScreen *)p_delegate
{
    if(self=[super initStartPoint:p_start EndPoint:p_stop duration:p_time initDelegate:p_delegate])
    {
        float assetScale = 1.0;
        if ( !IS_IPAD() && [DeviceSettings isRetina])
        {   
            assetScale = 0.5;
        }
        if(!IS_IPAD())
        {      if ([DeviceSettings isRetina])
        {
            m_movement=1*iPAD2iPHONE_WIDTH_RATIO;
        }
        else
        {
            m_movement=0.25*iPAD2iPHONE_WIDTH_RATIO;
        }
        }
        else
        {
            m_movement=1;
        }

     
        isHostile=true;
        m_size=kCollectibleSize_med;
        m_itemWeight=40;
        m_points=900;
        m_itemSellPrice=900;
        //Perch Walk
        m_queenwalkbatch=[CCSpriteBatchNode batchNodeWithFile:@"queenbee.png"];
        m_queenwalk=[CCSprite spriteWithTexture:m_queenwalkbatch.texture rect:CGRectMake(0, 0,90*assetScale,82*assetScale)];
        m_queenwalk.visible=FALSE;
        m_frameswalk=[[NSMutableArray alloc] init];
        
        m_queenturnbatch=[CCSpriteBatchNode batchNodeWithFile:@"queenbee.png"];
        m_queenturn=[CCSprite spriteWithTexture:m_queenturnbatch.texture rect:CGRectMake(0, 0,90*assetScale,82*assetScale)];
        m_queenturn.visible=FALSE;
        m_framesturn=[[NSMutableArray alloc] init];
        
        m_queengrabbedbatch=[CCSpriteBatchNode batchNodeWithFile:@"queenbee.png"];
        m_queengrabbed=[CCSprite spriteWithTexture:m_queengrabbedbatch.texture rect:CGRectMake(0, 0,90*assetScale,82*assetScale)];
        m_queengrabbed.visible=FALSE;
        m_framesgrabbed=[[NSMutableArray alloc] init];
        
        m_queenattackbatch=[CCSpriteBatchNode batchNodeWithFile:@"queenbee.png"];
        m_queenattack=[CCSprite spriteWithTexture:m_queenattackbatch.texture rect:CGRectMake(0, 0,90*assetScale,83*assetScale)];
        m_queenattack.visible=FALSE;
        m_framesattack=[[NSMutableArray alloc] init];

        
        int counter=0;
        for(int i=0;i<4;i++)
        {
            for(int j=0;j<11;j++)
            {
                counter++;
                if(counter>=10&&counter<=16)
                {
                    [m_frameswalk addObject:[CCSpriteFrame frameWithTexture:m_queenwalk.texture rect:CGRectMake(j*90*assetScale, i*82*assetScale,90*assetScale, 82*assetScale)]];
                }
                else if(counter>=31&&counter<=35)
                {
                    [m_framesturn addObject:[CCSpriteFrame frameWithTexture:m_queenturn.texture rect:CGRectMake(j*90*assetScale, i*82*assetScale,90*assetScale, 82*assetScale)]]; 
                }
                else if(counter>=36&&counter<=39)
                {
                    [m_framesgrabbed addObject:[CCSpriteFrame frameWithTexture:m_queengrabbed.texture rect:CGRectMake(j*90*assetScale, i*82*assetScale,90*assetScale, 82*assetScale)]]; 
                }
                else if(counter>=17&&counter<=30)
                {
                    [m_framesattack addObject:[CCSpriteFrame frameWithTexture:m_queenattack.texture rect:CGRectMake(j*90*assetScale, i*82*assetScale,90*assetScale, 82*assetScale)]]; 
                }

            }
            
        }
        
        m_animwalk=[CCAnimation animationWithFrames:m_frameswalk delay:0.09f ];
        m_animatewalk=[[CCAnimate actionWithAnimation:m_animwalk restoreOriginalFrame:NO] retain];
        m_repeatwalk=[[CCRepeatForever actionWithAction:m_animatewalk ]retain];
        [self addChild:m_queenwalk];
        
        m_animturn=[CCAnimation animationWithFrames:m_framesturn delay:0.09f ];
        m_animateturn=[[CCAnimate actionWithAnimation:m_animturn restoreOriginalFrame:NO] retain];
        [self addChild:m_queenturn];
        
        m_animgrabbed=[CCAnimation animationWithFrames:m_framesgrabbed delay:0.04f ];
        m_animategrabbed=[[CCAnimate actionWithAnimation:m_animgrabbed restoreOriginalFrame:NO] retain];
        [self addChild:m_queengrabbed];
        
        m_animattack=[CCAnimation animationWithFrames:m_framesattack delay:0.09f ];
        m_animateattack=[[CCAnimate actionWithAnimation:m_animattack restoreOriginalFrame:NO] retain];
        [self addChild:m_queenattack];

        //Position Whale
        
        if(endPoint.x<startPoint.x)
        {
            
            m_movetoend=YES;
            m_changeDirection=NO;
            
            [self QueenWalk:YES setDelegate:nil setMethod:nil isFacingOpposite:NO];
        }
        else if(endPoint.x>startPoint.x)
        {
            
            
            m_movetoend=YES;
            m_changeDirection=YES;
          
            
            [self QueenWalk:YES setDelegate:nil setMethod:nil isFacingOpposite:YES];
            
        }
        
        
        
        
        [self schedule:@selector(QueenWalking)];
    
                 
                 
                 
    }
             return self;
}
             


-(void)actionChecker:(RUNNING_ACTION_QUEEN)p_willrun
{
    if(isRunning==QUEEN_WALK)
    {
        [m_queenwalk stopAllActions];
        
    }
    else if(p_willrun==isRunning&&isRunning==QUEEN_TURN)
    {
        [m_queenturn stopAllActions];
    }
    else if(p_willrun==isRunning&&isRunning==QUEEN_GRABBED)
    {
        [m_queengrabbed stopAllActions];
    }
    else if(p_willrun==isRunning&&isRunning==QUEEN_ATTACK)
    {
        [m_queenattack stopAllActions];
    }
    
    isRunning=p_willrun;
}



-(void)QueenWalk:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face
    {
        
        [self actionChecker:QUEEN_WALK];
        if(p_face==YES)
        {
            m_queenwalk.scaleX=-1;    
        }
        else{
            m_queenwalk.scaleX=1;
        }
        
        m_queenwalk.visible=TRUE;
        m_queenturn.visible=FALSE;
        m_queengrabbed.visible=FALSE;
        m_queenattack.visible=FALSE;
        
        
        
        
        if(p_loop==YES)
        {
            [m_queenwalk runAction:m_repeatwalk];
        }
        else
        {
            if(p_delegate!=nil)
            {
                id callbackwalk=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
                [m_queenwalk runAction:[CCSequence actions:m_animatewalk,callbackwalk, nil]];
            }
            else
            {
                [m_queenwalk runAction:m_animatewalk];   
            }
        }

        
        
        
    }

-(void)QueenTurn:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face
{
    m_queenturn.anchorPoint=ccp(0.40,0.5);
    [self actionChecker:QUEEN_TURN];
    if(p_face==YES)
    {
        
        m_queenturn.scaleX=-1;
    }
    else
    {
        m_queenturn.scaleX=1;
    }
    
    m_queenwalk.visible=FALSE;
    m_queenturn.visible=TRUE;
    m_queengrabbed.visible=FALSE;
    m_queenattack.visible=FALSE;
    
    
    if(p_delegate!=nil)
    {
        id callbackturn=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
        [m_queenturn runAction:[CCSequence actions:m_animateturn,callbackturn, nil]];
    }
    else
    {
        [m_queenturn runAction:m_animateturn];   
    }
    

    
}
-(void)QueenGrabbed:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face angle:(int)p_angle
{
    [self actionChecker:QUEEN_GRABBED];
    if(p_face==YES)
    {
        m_queengrabbed.scaleX=-1;    
    }
    else
    {
        m_queengrabbed.scaleX=1; 
    }
    
    
    
    m_queenwalk.visible=FALSE;
    m_queenturn.visible=FALSE;
    m_queengrabbed.visible=TRUE;
    m_queenattack.visible=FALSE;
    
    CCCallBlock *grabmusic= [CCCallBlock actionWithBlock:
                             ^{
                                 [SoundManager playEffect:@"bees.mp3"];
                             }];
    


    
    if(p_delegate!=nil){
        
        //CCRotateTo *rotateAction = [CCRotateTo actionWithDuration:COLLECTIBLES_TRANSFORM_DURATION angle:p_angle];
        
        CCCallFunc* c=[CCCallFunc actionWithTarget:self selector:@selector(CheatFunction)];
        [m_queengrabbed runAction:[CCSequence actions:[CCSpawn actions:m_animategrabbed,grabmusic,nil],c, nil]];
    }
    

}



-(void)QueenWalkCall
{
    
    [self QueenWalk:YES setDelegate:nil setMethod:nil isFacingOpposite:m_changeDirection]; 
}

-(void)animalGrabbed:(id)p_delegate setMethod:(SEL)p_method angle:(int)p_angle
{   [self unscheduleAllSelectors];
    [self stopAllActions];
    [self QueenGrabbed:p_delegate setMethod:p_method isFacingOpposite:m_changeDirection angle:p_angle];
    m_delegategame=p_delegate;
    m_delegate=p_delegate;
}
-(float)getRadius
{
    float ratio = ((GameScreen*)m_delegategame).worldScale;
    float radius;
    if(!IS_IPAD()&&![DeviceSettings isRetina])
    {
        radius = ([m_queenwalk boundingBox].size.height/2)/2;
    }
    else
    {
        radius = [m_queenwalk boundingBox].size.height/2;
    }
    return radius/ratio;
}



-(void)QueenAttack:(BOOL)p_loop setDelegate:(id)p_delegate setMethod:(SEL)p_method isFacingOpposite:(BOOL)p_face targetPosition:(CGPoint)p_target;

{
    [self actionChecker:QUEEN_ATTACK];
    if(p_face==YES)
    {
        m_queenattack.scaleX=-1;    
    }
    else
    {
        m_queenattack.scaleX=1;
    }
    
    m_queenwalk.visible=FALSE;
    m_queenturn.visible=FALSE;
    m_queengrabbed.visible=FALSE;
    m_queenattack.visible=TRUE;
    
    
    
    
    
    if(p_delegate!=nil)
    {
        
        CGPoint toPosition2 = CGPointZero;
        CCMoveTo* mineMove2 = [CCMoveTo actionWithDuration:0.8 position:toPosition2];
        CCEaseSineOut* easeMineMove2 = [CCEaseSineOut actionWithAction:mineMove2]; 
        CCScaleTo* mineScale = [CCScaleTo actionWithDuration:0.8 scale:0];
        CCSpawn* mineMoveScale = [CCSpawn actions:easeMineMove2, mineScale, nil];
        
        id callbackattack=[CCCallFunc actionWithTarget:p_delegate selector:p_method];
        id remove=[CCCallFunc actionWithTarget:self selector:@selector(Remove)];
        [m_queenattack runAction:[CCSequence actions:m_animateattack,callbackattack,mineMoveScale,remove, nil]];
    }
    else
    {
        [m_queenattack runAction:m_animateattack];   
    }

    
}

-(void)AnimalWithAttack:(id)p_delegate setMethod:(SEL)p_method targetPosition:(CGPoint)p_target
{
    CGPoint toPosition1 = p_target;
    CCMoveTo* mineMove1 = [CCMoveTo actionWithDuration:0.5 position:toPosition1];
    CCEaseSineOut* easeMineMove1 = [CCEaseSineOut actionWithAction:mineMove1];
    [self runAction:easeMineMove1];
    [self QueenAttack:NO setDelegate:p_delegate setMethod:p_method isFacingOpposite:YES targetPosition:p_target];
}
-(void)Remove
{
    CCCallFuncND* callRemove = [CCCallFuncND actionWithTarget:m_delegate selector:@selector(removeMine:) data:self];    
    [self runAction:callRemove];
}


-(void)QueenWalking
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
                    [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                    
                }
                else{
                     [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
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
                    [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                    
                }
                else{
                     [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
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
                    [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                }
                else
                {
                   [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
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
                     [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=NO;
                }
                else
                {
                    [self QueenTurn:self setMethod:@selector(QueenWalkCall) isFacingOpposite:m_changeDirection];
                    m_changeDirection=YES;
                    
                }
                
            }
            
            
        }
        
        
    }
    
}






            

@end
