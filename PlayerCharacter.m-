//
//  PlayerCharacter.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerCharacter.h"

#import "Constants.h"
#import "GameScreen.h"
#import "DynamiteIngame.h"
#import "TitleScreen.h"
#import "Spray.h"
#import "DeviceSettings.h"
#import "PlayerStats.h"
#import "SoundManager.h"


@interface NodeInfo : NSObject

@property (assign, nonatomic) CCNode *node;
@property (assign) CGPoint point;

@end

@implementation NodeInfo

@synthesize node;
@synthesize point;

@end

@implementation PlayerCharacter

@synthesize m_curvePoints;
@synthesize springDamper;

- (id)initWithPosition : (CGPoint)p_position
        withGameScreen : (GameScreen*)p_gameScreen
{
    if( (self=[super init])) {
        
        self.springDamper = nil;
        B_IsJolting=NO;
        m_gameScreen = p_gameScreen;  
      
        
        [self loadCart];
        
        //--clamp object
        m_clamp = [[PlayerClamp alloc] initWithPlayerRef:self gameScreenRef:m_gameScreen];
        [self addChild:m_clamp];
        [m_clamp release];
        
        //temporary constructor
        /*CCSprite* claw=[m_clamp->m_clampObj getClaw];
        CGPoint  clawpoint=[m_clamp->m_clampObj getAnchorPoint];
        
        m_sprite1= [CCSprite spriteWithFile:@"icon.png"];
        m_sprite2=[CCSprite spriteWithFile:@"icon.png"];
        [m_clamp addChild:m_sprite1];
        [claw addChild:m_sprite2];
        [m_sprite2 setAnchorPoint:clawpoint];*/
        //[m_sprite2 setAnchorPoint: clawpoint];

        // get plist
        NSString * plistPath = [[NSBundle mainBundle] pathForResource: m_gameScreen.m_stage ofType:@"plist"];
        plistContents = [NSDictionary dictionaryWithContentsOfFile:plistPath];    
        m_ropeOffset = CGPointFromString([plistContents objectForKey: @"Clamp Position"]);
        // -
        
        //---------------------
        
        //--default to movinbg state
        state = STATE_MOVE;

        //--range in center(default)
        m_currentRange = 0.5;
        
        //--default to dynamite ready(temp)
        m_bIsDynamiteReady = true;
        
        //--default to spray ready(temp)
        m_bIsSprayReady = true;
        
        self.position = p_position;
        
        //--- add item buttons menu, set position on top of miner
        m_itemButtonsMenu = [CCMenu menuWithItems:nil];
        [m_gameScreen addToGameLayer:m_itemButtonsMenu withZ:100];
        m_itemButtonsMenu.position = ccp(self.position.x-10, self.position.y+50);
        [self ropeObject];
        [self scheduleUpdate];
       
    }
    
    return self;
}

-(void) update:(ccTime)dt
{
    //--Jolt Rope POsition
    if(B_IsJolting)
    {
        m_joltropeposition = ccpSub(m_assetNode.position, m_joltposition);
    }
    else return; 
    if (m_gameScreen->m_playerMovementOrientation == MOVEMENT_VERTICAL)
    {
        //m_pos=ccpAdd ( m_assetNode.position, m_ropeOffset );
        m_pos= ccpAdd(m_joltropeposition, m_ropeOffset);
    }
    else 
    {
        m_pos= ccpAdd(m_joltropeposition, m_ropeOffset);
    }
    
}


//--Rope
-(CGPoint)getJolting
{
    return m_joltropeposition;
}

-(CGPoint)getAssetNode
{
    return m_assetNode.position;
}


-(CGPoint)getRopePositionwhileJolting
{
    return m_pos;
}

-(void)ropeObject
{
    m_assetNode=[self->m_cart getAssetCartLayer];
}

-(CGPoint) getOffset
{
    return m_ropeOffset;
}

-(CGPoint) getRopePosition
{
    return ccpAdd ( m_assetNode.position, m_ropeOffset );
}

-(float)getRotation
{
    float rot = m_clamp.rotation;
    return rot;
}
-(float)getRotwhileJolt
{
    return m_joltrot;
}

-(PlayerClamp*)getClamp
{
    return m_clamp;
}

-(Claw*) getClamObj
{

    return m_clamp->m_clampObj;
}

-(BOOL) getJolt
{
    return B_IsJolting;
}
//---




// Loads the correct cart asset depending on stage
-(void) loadCart
{
    if ( !m_gameScreen )
    {
        return;
    }
    
    minerSprite = [[Miner alloc]init];
    minerSprite.scale = 0.75f*CC_CONTENT_SCALE_FACTOR();
    [self setContentSize:minerSprite.contentSize];
    //minerSprite.scale = SCREEN_SIZE.width / IPAD_SCREEN_SIZE.width;
    
    NSString *stage = m_gameScreen.m_stage;
    [self loadCartStageBased:stage];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:stage ofType:@"plist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    plistContents = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    minerSprite.position = CGPointFromString([plist objectForKey:@"Miner Position"]);
    if(!IS_IPAD()&&(m_gameScreen->m_level==kStage_desert)){
        if([DeviceSettings isRetina]){
            minerSprite.position = CGPointFromString([plist objectForKey:@"Miner Position Iphone"]);
            [minerSprite setScale:[([plistContents objectForKey:@"Miner Scale"]) floatValue]];
        }
        else{
            [minerSprite setScale:1];
            CGPoint pos = CGPointFromString([plist objectForKey:@"Miner Position Iphone"]);
            pos.y +=3;
            minerSprite.position = pos;
        }
    }
    if(!IS_IPAD() && ([[plistContents objectForKey:@"Orientation"] integerValue] == 3))
       {
           if(!(m_gameScreen->m_level ==kStage_zengarden)){
               if([DeviceSettings isRetina]){
                   if(m_gameScreen->m_level ==kStage_oasis){
                       minerSprite.scale = 2.12;
                       minerSprite.position = ccp(5,15);
                   }
                   else{
                       minerSprite.scale = 2.2;
                       minerSprite.position = ccp(0,70);
                   }
               }
               else{
                   if(m_gameScreen->m_level ==kStage_oasis){
                       minerSprite.scale = 1.1;
                       minerSprite.position = ccp(10,15);
                   }
                   else{
                       minerSprite.scale = 1.1;
                       minerSprite.position = ccp(0,70);}
               }
           }
       }
    /*int minerZ = [[plistContents objectForKey:@"Miner Z"] intValue];
    
    if (minerZ == 0)
    {
        [self addChild: minerSprite z:-2];
        [self addChild: m_cart z:-1]; 
    }
    else
    {
        [self addChild: minerSprite z:-1];
        [self addChild: m_cart z:-2]; 
    }*/
}

-(void) loadCartStageBased: (NSString*) stage 
{
    //
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:stage ofType:@"plist"];
    plistContents = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *cart = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"Cart"];
    
//## TODO: use correct cart asset
    //m_cart = [CCSprite spriteWithFile:[[plistContents objectForKey:@"Cart"] objectAtIndex:0]];
    m_cart = [[CartLayer alloc] initWithStage:stage];
    
    m_cart.position = CGPointFromString([cart objectAtIndex:3]);
    initialY=m_assetNode.position.y;
    //m_cart.scale = CC_CONTENT_SCALE_FACTOR();
    
//## TODO: fix miner's anchor point
    //minerSprite.anchorPoint = CGPointFromString([[plistContents objectForKey:@"Cart"] objectAtIndex:4]); 
    //[minerSprite setAnimationAnchorPoints:CGPointFromString([[plistContents objectForKey:@"Cart"] objectAtIndex:2])];
    
    // scale for iphone miner
    if(!IS_IPAD()){
        
        [m_cart setScale:[([plistContents objectForKey:@"Player Scale"]) floatValue]];
    }
    [self addChild:m_cart];
    [(CartLayer*)m_cart addMiner:minerSprite];
}

-(void) move
{
    if(m_bIsMoving)
    {
        [self moveToCurve];         //move miner in curve
    }
}

- (void) moveCharacterTo:(CGPoint)p_touchPos cartSpeed:(float)p_cartSpeed
{
    if(state == STATE_MOVE)
    {
        [self stopAllActions];

        short direction = 1;
        CGPoint targetPoint = p_touchPos;
        float duration = ccpDistance(targetPoint, self.position) / p_cartSpeed;
        CCMoveTo* move = [CCMoveTo actionWithDuration:duration position:targetPoint];
        CCCallFunc *playIdle = [CCCallFunc actionWithTarget:self selector:@selector(playIdle)];
        CCCallFunc *playAnimation;

    // determine direction
        if(targetPoint.x - self.position.x > 0) direction *= kCartDirection_right;
        else if(targetPoint.x - self.position.x <= 0)   direction *= kCartDirection_left;
    
        if ( m_gameScreen->m_playerMovementOrientation == MOVEMENT_VERTICAL )
        {
            [m_cart commenceAction:0];
            [self runAction:[CCSequence actions:move,playIdle,nil]];
           
        }
        else 
        {
            // determine miner animation to play
            if ( m_cart->m_animationType == kCartAnimation_chopper ||
                m_cart->m_animationType == kCartAnimation_airplane )
                playAnimation = direction>kCartDirection_left ? 
                    [CCCallFunc actionWithTarget:self selector:@selector(playHappyRight)] :
                    [CCCallFunc actionWithTarget:self selector:@selector(playHappyLeft)];
            else
                playAnimation = direction>kCartDirection_left ? 
                    [CCCallFunc actionWithTarget:self selector:@selector(playRight)] :
                    [CCCallFunc actionWithTarget:self selector:@selector(playLeft)];
            CCLOG(@"direction %i",direction);
            // play animations
            [m_cart commenceAction:direction];
            [self runAction:[CCSequence actions:playAnimation,move,playIdle,nil]];
        }
    }
}

- (void) curveCharacterTo: (CGPoint)p_touchPos
{
    if(state == STATE_MOVE)
    {
        [self stopAllActions];
        
        m_targetPosition = p_touchPos;
        
        /*if(m_targetPosition.x - self.position.x > 0)
        {
            m_moveDirection = DIRECTION_RIGHT;
        }
        else if(m_targetPosition.x - self.position.x <= 0)
        {
            m_moveDirection = DIRECTION_LEFT;
        }*/
        
    // determine direction
        short direction = 1;
        if(m_targetPosition.x - self.position.x > 0) 
        {
            m_moveDirection = DIRECTION_RIGHT;
            direction *= kCartDirection_right;
            [self playRight];
        }
        else if(m_targetPosition.x - self.position.x <= 0)   
        {
            m_moveDirection = DIRECTION_LEFT;
            direction *= kCartDirection_left;
            [self playLeft];
        }
        
        // play animations
        [m_cart commenceAction:direction];
        
        m_bIsMoving = true;
    }    
}

- (void) moveToCurve
{
    if(m_moveDirection == DIRECTION_LEFT){
        m_currentRange -= PLAYER_RANGE_ADDITIVE;
        
        if(self.position.x < m_targetPosition.x)
        {
            m_bIsMoving = false;
            [self playIdle];
        }
    }    
    else if(m_moveDirection == DIRECTION_RIGHT){
        m_currentRange += PLAYER_RANGE_ADDITIVE;       
       
        if(self.position.x > m_targetPosition.x)
        {
            m_bIsMoving = false;
            [self playIdle];
        }        
    }
    
    if(m_bIsMoving)
    {
        CGPoint tempPosition = [self getBezierWithRange:m_currentRange];    
        //CCLOG(@"b4:%f",self.position.y);
        self.position = CGPointMake(tempPosition.x, tempPosition.y);
        //CCLOG(@"after:%f",self.position.y);
    }
}

-(CGPoint) getBezierWithRange: (float)range
{
    CGPoint originPoint = [[m_curvePoints objectAtIndex:0] CGPointValue];
    CGPoint controlPoint1 = [[m_curvePoints objectAtIndex:1] CGPointValue];
    CGPoint controlPoint2 = [[m_curvePoints objectAtIndex:2] CGPointValue];
    CGPoint destPoint = [[m_curvePoints objectAtIndex:3] CGPointValue];
    
    CGPoint pos =ccpAdd(
                        ccpAdd( ccpMult(originPoint, powf(1-range, 3)),
                               ccpMult(controlPoint1, 3 * powf(1-range, 2) * range)), 
                        
                        ccpAdd(ccpMult(controlPoint2, powf(range, 2)*(1 - range) * 3),
                               ccpMult(destPoint, powf(range, 3))));
    
    return pos;
    //--return bezier position given range(0 to 1)
}

- (void) stopAndReleaseClamp
{
    if(state == STATE_MOVE)
    {    
    
        [m_cart stopAllActions];
        [self stopAllActions];
        m_bIsMoving = false;
        [m_clamp launchClamp];
        [self playDropAnimation];
      
        //--temporary reset
        m_bIsDynamiteReady = true;
        
        //--temporary reset
        m_bIsSprayReady = true;
    }
}

- (void) playStunAnimation
{
    state = STATE_PARALYZE;
    [minerSprite MinerStung:self setMethod:@selector(playIdle)];
}

-(void) playCantPullAnimation
{
    [SoundManager playEffect:AUDIO_GRUNT];
    state = STATE_STUN;
    [minerSprite MinerTooHeavy:m_gameScreen setMethod:@selector(cantPullAnimationCallback)];
    [m_clamp->m_clampObj stopAllActions];
}

-(void) playDropAnimation
{
    [minerSprite MinerDown:nil setMethod:nil];
}

-(void) playGrabAnimation
{
    [minerSprite MinerGrabbed:self setMethod:@selector(playIdle)];
}

-(void) playPullAnimation
{
    [minerSprite MinerUpisLooping:YES setDelegate:nil setMethod:nil];
  
}

-(void) playStrAnimation
{
//## TODO: implement me
    [minerSprite MinerStrength:nil setMethod:nil];
}

-(void) playThrowAnimation:(id)p_delegate
{
    [minerSprite MinerThrow:p_delegate setMethod:@selector(launchDynamite)];
}

-(void) playIdle
{
    [m_cart stopAllActions];
    [minerSprite MinerIdle];
}

-(void) playRight       {   [minerSprite MinerRight];       }
-(void) playLeft        {   [minerSprite MinerLeft];        }
-(void) playHappyLeft   {   [minerSprite playHappyLeft];    }
-(void) playHappyRight  {   [minerSprite playHappyRight];   }

-(void) setClampPosition:(CGPoint) p_clampPos
{
    m_clamp.position = p_clampPos;
}

-(void) setClampScale:(GLfloat)p_scale
{
    m_clamp.scale = p_scale;
}

-(void) jolt
{
    
    if (m_gameScreen->m_playerMovementOrientation == MOVEMENT_STATIC) return;
    if (m_gameScreen->m_playerMovementOrientation == MOVEMENT_CURVE) return;
    
     m_direction = m_clamp.rotation < 0 ? 1 : -1;
    B_IsJolting=YES;
    if (m_gameScreen->m_playerMovementOrientation == MOVEMENT_VERTICAL)
    {
        //before jolt save
        m_joltposition=m_cart.position;
        float lastX = m_cart.position.x;
        [m_cart stopAnimation];
        
        self.springDamper =
        [RK4SpringDamper nodeWithNode:m_assetNode andVelocity:ccp(-m_direction * 300, 0) andDampingRatio:0.5 andSpringConstantToMassRatio:10 andBlock:
         ^{
             m_assetNode.position = ccp(lastX, m_cart.position.y);
             [m_cart continueAnimation];

            
         }];
        
     
         B_IsJolting=NO;
        return;
    }

    if (m_gameScreen->m_playerMovementOrientation == MOVEMENT_HORIZONTAL)
    {
        
        CGPoint adjustment = ccp(m_direction * 75, 15);
        
        //before jolt save
        m_joltposition=adjustment;
        
        
        NSMutableArray *children = [[NSMutableArray alloc] init];
        for (CCNode *child in m_cart.children)
        {
            NodeInfo *info = [[NodeInfo alloc] init];
            info.node = child;
            info.point = [child.parent convertToWorldSpace:child.position];
            [children addObject:info];
            [info release];
        }

        m_cart.position = ccpSub(m_cart.position, adjustment);
      
        
        for (NodeInfo *info in children)
        {
            info.node.position = [info.node.parent convertToNodeSpace:info.point];
            
        }
        
        [m_cart stopAnimation];

        [m_cart runAction:
         [CCSequence actions:
          [CCEaseExponentialOut actionWithAction:[CCRotateBy actionWithDuration:0.25f angle:0.3f * m_clamp.rotation]],
          [CCEaseBounceOut actionWithAction:[CCRotateBy actionWithDuration:0.5f angle:-0.3f * m_clamp.rotation]],
          [CCCallBlock actionWithBlock:
           ^{
               m_cart.position = ccpAdd(m_cart.position, adjustment);
              
               for (NodeInfo *info in children)
               {
                   info.node.position = [info.node.parent convertToNodeSpace:info.point];
               }
               
               
               [children release];
               if(m_cart->m_animationType==kCartAnimation_raft)
               {
                   m_assetNode.position=ccp(m_assetNode.position.x,initialY);
               }
             
               B_IsJolting=NO;
               [m_cart continueAnimation];
           }],
          nil]];
        
        
        return;
    }

   /* CGPoint adjustment = ccp(direction * 75, 15);
    
    NSMutableArray *children = [[NSMutableArray alloc] init];
    for (CCNode *child in m_cart.children)
    {
        NodeInfo *info = [[NodeInfo alloc] init];
        info.node = child;
        info.point = [child.parent convertToWorldSpace:child.position];
        [children addObject:info];
        [info release];
    }
    
    m_cart.position = ccpSub(m_cart.position, adjustment);
    
    for (NodeInfo *info in children)
    {
        info.node.position = [info.node.parent convertToNodeSpace:info.point];
    }
    
    [m_cart stopAnimation];
    
    [m_cart runAction:
     [CCSequence actions:
      [CCEaseExponentialOut actionWithAction:[CCRotateBy actionWithDuration:0.25f angle:0.3f * m_clamp.rotation]],
      [CCEaseBounceOut actionWithAction:[CCRotateBy actionWithDuration:0.5f angle:-0.3f * m_clamp.rotation]],
      [CCCallBlock actionWithBlock:
       ^{
           m_cart.position = ccpAdd(m_cart.position, adjustment);
           
           for (NodeInfo *info in children)
           {
               info.node.position = [info.node.parent convertToNodeSpace:info.point];
           }
           
           [children release];
           
           [m_cart continueAnimation];
       }],
      nil]];*/
    
}

- (void) dealloc
{
    [minerSprite release];
    [m_curvePoints release];
    m_curvePoints = nil;
	[super dealloc];
}

-(void) stopAllActions
{
    if (self.springDamper != nil)
    {
        [self.springDamper runBlock];
        self.springDamper = nil;
    }
    [super stopAllActions];
}

@end
