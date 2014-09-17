//
//  BouncingBallViewController.m
//  BouncingBall
//
//  Created by scott on 9/16/14.
//  Copyright (c) 2014 Wolfpack Software. All rights reserved.
//

#import "BouncingBallViewController.h"
#import "BouncingBallView.h"

@interface BouncingBallViewController ()
{
    BouncingBallView * bouncingBallView;
    NSTimer * timer;
}

@end

@implementation BouncingBallViewController

float stepSize = 1/30.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bouncingBallView = [[BouncingBallView alloc] initWithFrame: self.view.frame];
        [self.view addSubview: bouncingBallView];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:stepSize target:self selector:@selector(nextFrame) userInfo:NULL repeats:YES];
    }
    return self;
}



- (void) nextFrame
{
    [bouncingBallView tickWithStepSize: stepSize];
    [bouncingBallView setNeedsDisplay];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
