//
//  ParticleManager.m
//  GoldMinerWorld
//
//  Created by KrisJulio on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticleManager.h"

const struct Particle ROCK_RESIDUE_PARTICLE = 
{ 
    .bg.red=0, .bg.green=0, .bg.blue=0, 
    .maxParticles=20/*10*/, .lifespan=0.2/*0.1*/, .lifespanVar=0.30/*0.15*/, .startSize=16, .startSizeVar=4, .finishSize=0, .finishSizeVar=0, .emitAngle=0, .emitAngleVar=180,
    .emitterType.gravity.speed=572, .emitterType.gravity.speedVar=0, .emitterType.gravity.gravityX=0, .emitterType.gravity.gravityY=-3000,
    .emitterType.gravity.radialAccel=0, .emitterType.gravity.radialAccelVar=0, .emitterType.gravity.tanAccel=0, .emitterType.gravity.tanAccelVar=0,
    //.emitterType.radial.maxRadius=0, .emitterType.radial.maxRadiusVar=0, .emitterType.radial.minRadius=0, .emitterType.radial.minRadiusVar=0, .emitterType.radial.degPerSec=0, .emitterType.radial.degPerSecVar=0,
    .emitterMode=kCCParticleModeGravity, .emmitDuration=0.29, .sourcePosY=200, .sourcePosX=157, .filename=@"sRock2.png", .blendFuncSrc=GL_ONE, .blendFuncDest=GL_ONE,
    .startColor={1,1,1,1}, .startColorVar={0,0,0,0}, .finishColor={1,1,1,1}, .finishColorVar={0,0,0,0}, .blendAdditive=NO
};

const struct Particle COPPER_RESIDUE_PARTICLE = 
{ 
    .bg.red=0, .bg.green=0, .bg.blue=0, 
    .maxParticles=20/*10*/, .lifespan=0.2/*0.1*/, .lifespanVar=0.30/*0.15*/, .startSize=16, .startSizeVar=4, .finishSize=0, .finishSizeVar=0, .emitAngle=0, .emitAngleVar=180,
    .emitterType.gravity.speed=572, .emitterType.gravity.speedVar=0, .emitterType.gravity.gravityX=0, .emitterType.gravity.gravityY=-3000,
    .emitterType.gravity.radialAccel=0, .emitterType.gravity.radialAccelVar=0, .emitterType.gravity.tanAccel=0, .emitterType.gravity.tanAccelVar=0,
    //.emitterType.radial.maxRadius=0, .emitterType.radial.maxRadiusVar=0, .emitterType.radial.minRadius=0, .emitterType.radial.minRadiusVar=0, .emitterType.radial.degPerSec=0, .emitterType.radial.degPerSecVar=0,
    .emitterMode=kCCParticleModeGravity, .emmitDuration=0.29, .sourcePosY=200, .sourcePosX=157, .filename=@"mCopper5.png", .blendFuncSrc=GL_ONE, .blendFuncDest=GL_ONE,
    .startColor={1,1,1,1}, .startColorVar={0,0,0,0}, .finishColor={1,1,1,1}, .finishColorVar={0,0,0,0}, .blendAdditive=NO
};

const struct Particle GOLD_RESIDUE_PARTICLE = 
{ 
    .bg.red=0, .bg.green=0, .bg.blue=0, 
    .maxParticles=20/*10*/, .lifespan=0.2/*0.1*/, .lifespanVar=0.30/*0.15*/, .startSize=16, .startSizeVar=4, .finishSize=0, .finishSizeVar=0, .emitAngle=0, .emitAngleVar=180,
    .emitterType.gravity.speed=572, .emitterType.gravity.speedVar=0, .emitterType.gravity.gravityX=0, .emitterType.gravity.gravityY=-3000,
    .emitterType.gravity.radialAccel=0, .emitterType.gravity.radialAccelVar=0, .emitterType.gravity.tanAccel=0, .emitterType.gravity.tanAccelVar=0,
    //.emitterType.radial.maxRadius=0, .emitterType.radial.maxRadiusVar=0, .emitterType.radial.minRadius=0, .emitterType.radial.minRadiusVar=0, .emitterType.radial.degPerSec=0, .emitterType.radial.degPerSecVar=0,
    .emitterMode=kCCParticleModeGravity, .emmitDuration=0.29, .sourcePosY=200, .sourcePosX=157, .filename=@"gold2.png", .blendFuncSrc=GL_ONE, .blendFuncDest=GL_ONE,
    .startColor={1,1,1,1}, .startColorVar={0,0,0,0}, .finishColor={1,1,1,1}, .finishColorVar={0,0,0,0}, .blendAdditive=NO
};

const struct Particle BRONZE_RESIDUE_PARTICLE = 
{ 
    .bg.red=0, .bg.green=0, .bg.blue=0, 
    .maxParticles=20/*10*/, .lifespan=0.2/*0.1*/, .lifespanVar=0.30/*0.15*/, .startSize=16, .startSizeVar=4, .finishSize=0, .finishSizeVar=0, .emitAngle=0, .emitAngleVar=180,
    .emitterType.gravity.speed=572, .emitterType.gravity.speedVar=0, .emitterType.gravity.gravityX=0, .emitterType.gravity.gravityY=-3000,
    .emitterType.gravity.radialAccel=0, .emitterType.gravity.radialAccelVar=0, .emitterType.gravity.tanAccel=0, .emitterType.gravity.tanAccelVar=0,
    //.emitterType.radial.maxRadius=0, .emitterType.radial.maxRadiusVar=0, .emitterType.radial.minRadius=0, .emitterType.radial.minRadiusVar=0, .emitterType.radial.degPerSec=0, .emitterType.radial.degPerSecVar=0,
    .emitterMode=kCCParticleModeGravity, .emmitDuration=0.29, .sourcePosY=200, .sourcePosX=157, .filename=@"rock1.png", .blendFuncSrc=GL_ONE, .blendFuncDest=GL_ONE,
    .startColor={1,1,1,1}, .startColorVar={0,0,0,0}, .finishColor={1,1,1,1}, .finishColorVar={0,0,0,0}, .blendAdditive=NO
};

@implementation ParticleManager

+(CCParticleSystemQuad*)generateParticles:(enum PARTICLE)p_particleType withfile:(NSString *)p_file
{
    CCParticleSystemQuad *returnValue;
    struct Particle particle;
   
    
// select particle type to use
    switch ( p_particleType )
    {
        case kParticle_rockResidue: particle = ROCK_RESIDUE_PARTICLE;
        case kParticle_GoldResidue: particle= GOLD_RESIDUE_PARTICLE;
        case kkParticle_CopperResidue: particle= COPPER_RESIDUE_PARTICLE;
        case kParticle_BronzeResidue: particle= BRONZE_RESIDUE_PARTICLE;
    }
   
// setup particle's properties  
    returnValue = [[[CCParticleSystemQuad alloc] initWithTotalParticles:particle.maxParticles] autorelease];
    returnValue.duration = particle.emmitDuration;
    
    returnValue.emitterMode = kCCParticleModeGravity;
    
    if ( particle.emitterMode == kCCParticleModeGravity )
    {
        returnValue.gravity = ccp( particle.emitterType.gravity.gravityX, particle.emitterType.gravity.gravityY );
        returnValue.speed = particle.emitterType.gravity.speed;
        returnValue.speedVar = particle.emitterType.gravity.speedVar;
        returnValue.radialAccel = particle.emitterType.gravity.radialAccel;
        returnValue.radialAccelVar = particle.emitterType.gravity.radialAccelVar;
        returnValue.tangentialAccel = particle.emitterType.gravity.tanAccel;
        returnValue.tangentialAccelVar = particle.emitterType.gravity.tanAccelVar;
    }
    else    ///particle.emitterMode == kCCParticleModeRadius
    {
        returnValue.startRadius = particle.emitterType.radial.maxRadius;
        returnValue.startRadiusVar = particle.emitterType.radial.maxRadiusVar;
        returnValue.endRadius = particle.emitterType.radial.minRadius;
        returnValue.endRadiusVar = particle.emitterType.radial.minRadiusVar;
        returnValue.rotatePerSecond = particle.emitterType.radial.degPerSec;
        returnValue.rotatePerSecondVar = particle.emitterType.radial.degPerSecVar;
    }
    
    // angle
    returnValue.angle = particle.emitAngle;
    returnValue.angleVar = particle.emitAngleVar;
    
    // emitter position
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    //returnValue.position = ccp(winSize.width/2, winSize.height/2);
    returnValue.posVar = CGPointZero;
    
    // life of particles
    returnValue.life = particle.lifespan;
    returnValue.lifeVar = particle.lifespanVar;
    
    // size, in pixels
    returnValue.startSize = particle.startSize;
    returnValue.startSizeVar = particle.startSizeVar;
    returnValue.endSize = particle.finishSize;
    returnValue.endSizeVar = particle.finishSizeVar;
    
    // spin
    returnValue.startSpin = 0.0f;
    returnValue.endSpin = 360.0f;
    
    // emits per second
    returnValue.emissionRate = returnValue.totalParticles/returnValue.duration;
    
    // color of particles
    
    /*if ( p_color.a > 0 && p_color.b > 0 && p_color.g > 0 && p_color.r > 0)
        [returnValue setStartColor:p_color];
    else
        [returnValue setStartColor:particle.startColor];
    [returnValue setStartColorVar:particle.startColorVar];
    [returnValue setEndColor:particle.finishColor];
    [returnValue setEndColorVar:particle.finishColorVar];*/
    
    [returnValue setStartColor:particle.startColor];
    [returnValue setStartColorVar:particle.startColorVar];
    [returnValue setEndColor:particle.finishColor];
    [returnValue setEndColorVar:particle.finishColorVar];
    
    
    returnValue.texture = [[CCTextureCache sharedTextureCache] addImage: p_file ];
    
    // additive
    returnValue.blendAdditive = particle.blendAdditive;
    
    return returnValue;
}

@end
