//
//  BouncingBallView.m
//  BouncingBall
//
//  Created by scott on 9/16/14.
//  Copyright (c) 2014 Wolfpack Software. All rights reserved.
//

#import "BouncingBallView.h"

@interface Particle : NSObject {
    @public
    float xPos, yPos, xVelo, yVelo, xForce, yForce, radius;
}

-(id)initWithX: (float) x Y:(float) y Vx:(float) vx Vy:(float) vy radius:(float) _radius;

@end

@implementation Particle

-(id)initWithX: (float) x Y:(float) y Vx:(float) vx Vy:(float) vy radius:(float) _radius {
    self = [super init];
    if (self) {
        xPos = x;
        yPos = y;
        xVelo = vx;
        yVelo = vy;
        radius = _radius;
        return self;
    } else {
        return nil;
    }
}


@end

@implementation BouncingBallView
{
    NSMutableArray * particles;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        int particleCount = 50;
        float maxV = 20;
        particles = [[NSMutableArray alloc] initWithCapacity: particleCount];
        float width = self.bounds.size.width;
        float height = self.bounds.size.height;

        float netVx = 0.0;
        float netVy = 0.0;
        
        for (int i=0;i<particleCount;i++) {
            float vx = arc4random_uniform(maxV)-maxV/2;
            float vy = arc4random_uniform(maxV)-maxV/2;
            
            netVx += vx;
            netVy += vy;
            
            [particles addObject: [[Particle alloc] initWithX: arc4random_uniform(width) Y: arc4random_uniform(height) Vx: vx Vy: vy radius: 10]];
        }
        
        NSLog(@"netVx: %f, netVy %f", netVx, netVy);
        
        
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);

    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 4);
    
    for (Particle * particle in particles) {
        
        CGRect boundRect = CGRectMake(particle->xPos, particle->yPos, particle->radius, particle->radius);
        
        CGContextFillEllipseInRect(context, boundRect);
        CGContextStrokeEllipseInRect(context, boundRect);
        
    }

    
}

-(void) tickWithStepSize:(float) stepSize {
    
    // test with walls
    for (int i=0;i< [particles count]; i++) {
        Particle * particle = [particles objectAtIndex: i];
        if (particle->xPos < 0 || particle->xPos > self.bounds.size.width) particle->xVelo *= -1;
        if (particle->yPos < 0 || particle->yPos > self.bounds.size.height) particle->yVelo *= -1;
    }
    
    // zero forces
    for (int i=0;i< [particles count]; i++) {
        Particle * particle = [particles objectAtIndex: i];
        particle->xForce = 0;
        particle->yForce = 0;
    }
    
    // calculate forces with each other
    for (int i=0;i<[particles count]-1; i++) {
        for (int j=i+1;j<[particles count]; j++) {
            Particle * particle1 = [particles objectAtIndex: i];
            Particle * particle2 = [particles objectAtIndex: j];
            float dist = [self distBetween: particle1 and: particle2];
            float minDist = [self minDistBetween: particle1 and: particle2];
            float dx = particle2->xPos - particle1->xPos;
            float dy = particle2->yPos - particle1->yPos;
            float rij = sqrt(dx*dx + dy*dy)/minDist;
        
            float U = /*48.0* */( pow(rij, -14) - 0.5*pow(rij, -8));
            float fx = dx*U;
            float fy = dy*U;
            particle1->xForce -= fx;
            particle2->xForce += fx;
            particle1->yForce -= fy;
            particle2->yForce += fy;
            
//            NSLog(@"dist: %f, minDist %f", dist, minDist);
//            if(dist <= minDist) {
//                float tmpVx = particle1->xVelo;
//                float tmpVy = particle2->yVelo;
//                particle1->xVelo = particle2->xVelo;
//                particle1->yVelo = particle2->yVelo;
//                particle2->xVelo = tmpVx;
//                particle2->yVelo = tmpVy;
//            }
        }
    }
    
    // move particles
    for (int i=0;i< [particles count]; i++) {
        Particle * particle = [particles objectAtIndex: i];
        particle->xVelo += particle->xForce*stepSize;
        particle->yVelo += particle->yForce*stepSize;
        particle->xPos += particle->xVelo*stepSize;
        particle->yPos += particle->yVelo*stepSize;
    }
    
//    xPos += xVelo /* + 5.0*((float)rand()/RAND_MAX-0.5) */;
//    yPos += yVelo /* + 5.0*((float)rand()/RAND_MAX-0.5) */;
}

-(float)distBetween:(Particle*) part1 and:(Particle*) part2 {
    float dist = sqrt((part1->xPos-part2->xPos)*(part1->xPos-part2->xPos)
                      +(part1->yPos-part2->yPos)*(part1->yPos-part2->yPos));
    return dist;
}

-(float) minDistBetween:(Particle*) part1 and:(Particle*) part2 {
    float minDist = part1->radius/2 + part2->radius/2;
    return minDist;
}

@end
