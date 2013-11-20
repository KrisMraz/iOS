//
//  MinerRope.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 4/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MinerRope.h"
#import "DeviceSettings.h"
#import "PlayerStats.h"
#import "PlayerCharacter.h"
#import "GameScreen.h"



#define ROPE_LENGTH m_ropelength

#define ROPE_LENGTH2 m_ropelength2


const int SEMI_CURVE_SPEED[3] = { 10,8,5 };

enum ROPE_MODE
{
    kRope_idle,
    kRope_straight,
    kRope_semiCurve,
    kRope_curve
};

@implementation MinerRope
-(id) initwithPlayercharacter:(PlayerCharacter *)p_delegate
//-(id) init
{
    if ( (self=[super init]) )
    {
        
        m_playernode=p_delegate;
        m_counter=0;
        m_deltaY = 1;
        int value1;
        int value2;
        int value3;
        if (!IS_IPAD()) 
        {
            
            value1=256*0.5;
            value2=64*0.5;
            value3=256*0.5;
            scale1=3.1;
            scale2=-3.1;
            
        }
        else
        {
            value1=256;
            value2=64;
            value3=256;
            scale1=1.5;
            scale2=-1.5;        
        }

        NSString *fileToUse2 = g_playerThresholds.str == kStr_steelCable ? @"rope_steel.png" : @"rope.png";
        m_ropeAfterCurveBatchNode = [CCSpriteBatchNode batchNodeWithFile:fileToUse2];
        m_ropeAfterCurve = [[CCSprite spriteWithBatchNode:m_ropeAfterCurveBatchNode rect:CGRectMake(value1, 0, value2, value3)] retain];
        [self addChild: m_ropeAfterCurveBatchNode];
        [m_ropeAfterCurveBatchNode addChild: m_ropeAfterCurve];
        
        NSString *fileToUse3 = g_playerThresholds.str == kStr_steelCable ? @"rope_steel.png" : @"rope.png";
        m_ropeAfterCurveBatchNode2 = [CCSpriteBatchNode batchNodeWithFile:fileToUse3];
        m_ropeAfterCurve2 = [[CCSprite spriteWithBatchNode:m_ropeAfterCurveBatchNode rect:CGRectMake(value1, 0, value2, value3)] retain];
        
        [self addChild: m_ropeAfterCurveBatchNode2];
        [m_ropeAfterCurveBatchNode2 addChild: m_ropeAfterCurve2];
        
        
        NSString *fileToUse = g_playerThresholds.str == kStr_steelCable ? @"rope_steel.png" : @"rope.png";
        m_ropeBatchNode = [CCSpriteBatchNode batchNodeWithFile:fileToUse];
        m_ropeSprite = [CCSprite spriteWithBatchNode:m_ropeBatchNode rect:CGRectMake(0, 0, 0, 0)];
        
        
        if ( !IS_IPAD() )
        {
            if ([DeviceSettings isRetina])
            {
                m_ropelength=64*0.5;
                m_height=30;
                m_speed=0.8;
                m_offset=2.15;
                [m_ropeSprite setScaleX:2.14];
                m_ropeAfterCurve2.anchorPoint=CGPointMake(0.5, 1);
                m_ropeAfterCurve.anchorPoint=CGPointMake(0.5, 1);
                [m_ropeAfterCurve2 setScale:2.15];
                [m_ropeAfterCurve setScale:2.15];
                
                
                m_deltaykRope_idle = 0;             //kRope_idle 
                deltaykRope_straight -= 30;         //kRope_straight
                deltaykRope_semiCurve =0 ;          //5+SEMI_CURVE_SPEED[m_currentObjectSize] * m_direction; 
                deltaykRope_curve -= 0;             //kRope_curve
            }
            else
            {
                //m_ropelength=30;
                [m_ropeSprite setContentSizeInPixels:CGSizeMake(128, 32)];
                m_ropelength=m_ropeSprite.contentSizeInPixels.width;
                m_ropelength=m_ropeSprite.contentSizeInPixels.height;
                m_offset=2.15;
                m_height=30;
                m_speed=1;
                [m_ropeSprite setScaleX:2.14];
                m_ropeAfterCurve2.anchorPoint=CGPointMake(0.5, 1);
                m_ropeAfterCurve.anchorPoint=CGPointMake(0.5, 1);
                [m_ropeAfterCurve2 setScale:2.15];
                [m_ropeAfterCurve setScale:2.15];
                
                
                m_deltaykRope_idle = 0;                 //kRope_idle 
                deltaykRope_straight -= 50;             //kRope_straight
                deltaykRope_semiCurve = 0;              //SEMI_CURVE_SPEED[m_currentObjectSize] * m_direction; 
                deltaykRope_curve -= 0;                 //kRope_curve
            }
        }
        else
        {
            m_ropelength=64;
            m_height=1;
            m_speed=1;
            m_offset=1;
            m_ropeAfterCurve2.anchorPoint=CGPointMake(0.5, 1);
            m_ropeAfterCurve.anchorPoint=CGPointMake(0.5, 1);
            m_deltaykRope_idle = 0;                     //kRope_idle 
            deltaykRope_straight -= 10;                 //kRope_straight
            deltaykRope_semiCurve =0;                   // SEMI_CURVE_SPEED[m_currentObjectSize] * m_direction; //kRope_semiCurve
            deltaykRope_curve = 0;                      //kRope_curve
        }
        
        [m_ropeBatchNode addChild:m_ropeSprite];
        [self addChild:m_ropeBatchNode];
        m_ropeSprite.anchorPoint = ccp(0.5,1.0);
        
        // make the texture repeat
        ccTexParams textureparams=(ccTexParams){GL_LINEAR, GL_LINEAR , GL_REPEAT, GL_REPEAT};
        [[m_ropeSprite texture] setTexParameters:&textureparams];
        
        [self defaultMode];
        [m_ropeAfterCurve setVisible:NO];
        [m_ropeAfterCurve setVisible:NO];
        [self scheduleUpdate];
        
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
    [m_ropeAfterCurve release];
}


-(void) straightMode
{
    m_deltaY = 0;
    m_state = kRope_straight;
    m_currentRect = ccp(m_ropelength,0);
    
}

-(void) semiCurveMode:(enum ROPE_DIRECTION)p_direction objectSize:(enum COLLECTIBLE_SIZE)p_size
{
   
    m_currentObjectSize = p_size;
    m_direction = p_direction;
    m_deltaY = 0;
    if ( p_direction != kRopeDirection_retract)
    {
        m_state = kRope_semiCurve;
        m_currentRect = ccp(2*m_ropelength,0); // set semi curve texture rect
        
    }
    else
    {
        m_state = kRope_straight;
        m_currentRect = ccp(0,0);       
        
    }
}

-(void) curvedMode
{
    
    m_deltaY = 0;
    m_state = kRope_curve;
    m_currentRect = ccp(3*m_ropelength,0);   // set curve texture rect
}

-(void) defaultMode
{
    m_deltaY = 0;
    m_state = kRope_idle;
    m_currentRect = ccp(0,0);               // set default texture rect
}

-(void)setLenght: (float) p_length
{
    m_deltaHeight=p_length;
}


                                        
-(void) update:(ccTime)dt
{
    //--getter
    float rot= [m_playernode getRotation];
    Claw * clawobj= [m_playernode getClamObj];
    PlayerClamp * clamp=[m_playernode getClamp];

    
    if([m_playernode getJolt])
    {
        CGPoint cartPoint= [m_playernode getRopePositionwhileJolting];
        CGPoint converted = ccp(sinf(M_PI/180*rot),cosf(M_PI/180*rot));
        converted = ccpMult(converted,(clawobj.position.y )); 
        CGPoint clawPoint = ccpAdd(converted, clamp.position);
        
      
        CGFloat distance= ccpDistance( cartPoint, clawPoint);
        m_deltaHeight= distance+CLAMP_DEFAULT_DISTANCE;
    }
    else
    {
        //--claw rotation
        CGPoint cartPoint= [m_playernode getRopePosition];
        CGPoint converted = ccp(sinf(M_PI/180*rot),cosf(M_PI/180*rot));
        converted = ccpMult(converted,(clawobj.position.y )); 
        CGPoint clawPoint = ccpAdd(converted, clamp.position);
        
        //--set rope rotation
        CGPoint direction = ccpSub(  clawPoint, cartPoint);
        float rot2 = atan2f( direction.x, direction.y );
        self.rotation = 180/M_PI *rot2;
        
        //--set distance
        CGFloat distance= ccpDistance( cartPoint, clawPoint);
        m_deltaHeight= distance+CLAMP_DEFAULT_DISTANCE;   
    }
    //--state
    switch (m_state)
    {
        case kRope_idle:        m_deltaY = m_deltaykRope_idle;   break;
        case kRope_straight:    m_deltaY -= deltaykRope_straight; break;
        case kRope_semiCurve:   m_deltaY -= deltaykRope_semiCurve; break;
        case kRope_curve:       m_deltaY -= deltaykRope_curve; break;
    }

    //--semi curve animation
    if (m_state==kRope_semiCurve) 
    {
 
        m_counter2=(m_counter2+1)%6;
        
        if (m_counter2==0) 
        {
            m_offset=-m_offset;
        }
        [m_ropeSprite setScaleX:m_offset];
    }
    
    //--after curvedmode animation
    if ( m_direction == kRopeDirection_retract )
    {
        m_counter=m_counter+1;
        scale1=scale1-0.1;
        scale2=scale1+0.1;
        int fade;
        fade=455/m_counter;
        if (m_counter<5) 
        {
            m_state = kRope_straight;      
            [m_ropeAfterCurve setVisible:YES];
            [m_ropeAfterCurve2 setVisible:YES];
            [m_ropeAfterCurve setScaleX:scale1];
            [m_ropeAfterCurve2 setScaleX:-scale2];
            [m_ropeAfterCurve setPosition:ccp(m_ropeSprite.position.x-10, m_ropeSprite.position.y)];
            [m_ropeAfterCurve2 setPosition:ccp(m_ropeSprite.position.x+10, m_ropeSprite.position.y)];
            [m_ropeAfterCurve setScaleY: (m_ropelength- m_deltaHeight)/m_ropeAfterCurve.contentSize.height];
            [m_ropeAfterCurve2 setScaleY: (m_ropelength- m_deltaHeight)/m_ropeAfterCurve2.contentSize.height];
            [m_ropeAfterCurve2 setOpacity:fade];
            [m_ropeAfterCurve setOpacity:fade];

        }
        else if (m_counter<10)
        {
            test=m_ropelength- m_deltaHeight;
            [m_ropeAfterCurve2 setVisible:NO];
            [m_ropeAfterCurve setVisible:NO];
        }
    }
    else 
    {
        m_counter=0;
        scale1=1.5;
        scale2=-1.5;
        [m_ropeAfterCurve2 setVisible:NO];
        [m_ropeAfterCurve setVisible:NO];
    }


    //-- update texture rect
    [m_ropeSprite setTextureRect:CGRectMake(m_currentRect.x, m_currentRect.y + m_deltaY*m_speed, m_ropelength, m_ropelength-m_deltaHeight+m_height)];
    
}


@end
