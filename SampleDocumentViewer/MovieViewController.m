//
//  MovieViewController.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/07.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#define CONTROLLER_HIDDEN_TIME 3.0

#import <MediaPlayer/MediaPlayer.h>
#import "MovieViewController.h"

@interface MovieViewController () {
  
}
- (void) play;

@end

@implementation MovieViewController

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [(TouchEventView*)[super view] setCallback:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
  if(!self.navigationController.navigationBarHidden) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
  
  [super viewDidAppear:animated];
  [self play];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [playerControllerView_ terminatePlayer];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:player_.currentItem];
  [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark PlayerControllerDelegate

- (void)endPlay:(id)sender
{
  [playerControllerView_ endPlay];
  if(self.navigationController.navigationBarHidden) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  }
}

#pragma mark -
#pragma mark TouchEventDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(playerControllerView_.hidden) {
    playerControllerView_.hidden = NO;
    volumeView_.hidden = NO;
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(!playerControllerView_.hidden) {
    [NSTimer scheduledTimerWithTimeInterval:CONTROLLER_HIDDEN_TIME target:self selector:@selector(hideController) userInfo:nil repeats:NO];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(!playerControllerView_.hidden) {
    [NSTimer scheduledTimerWithTimeInterval:CONTROLLER_HIDDEN_TIME target:self selector:@selector(hideController) userInfo:nil repeats:NO];
  }
}

#pragma mark -

- (void)setFilePath:(NSString*)path
{
  path_ = [[NSString alloc] initWithString:path];
}

- (void)play
{
  if(path_ ) {
    NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [[NSString alloc] initWithFormat:@"%@/%@", [pathDocs objectAtIndex:0], path_];
    
    player_ = [[AVPlayer alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:docPath]];
    
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)movieView_.layer;
    playerLayer.player = player_;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endPlay:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:player_.currentItem];
    [playerControllerView_ setPlayer:player_ withDelegate:self];
    [playerControllerView_ play:nil];
    [NSTimer scheduledTimerWithTimeInterval:CONTROLLER_HIDDEN_TIME target:self selector:@selector(hideController) userInfo:nil repeats:NO];
    
    MPVolumeView *mpVolumeView = [[MPVolumeView alloc] initWithFrame: volumeView_.frame];
    [volumeView_ addSubview: mpVolumeView];
    [mpVolumeView setAutoresizingMask:
      UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    [mpVolumeView sizeToFit];
  }
}

- (void) startPlayback
{
  if(!self.navigationController.navigationBarHidden) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
}

- (void) endPlayback
{
  if(self.navigationController.navigationBarHidden) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  }
}

- (void) hideController
{
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     playerControllerView_.alpha = 0.0;
                     volumeView_.alpha = 0.0;
                   }
                   completion:^(BOOL finished){
                     playerControllerView_.hidden = YES;
                     playerControllerView_.alpha = 1.0;
                     volumeView_.hidden = YES;
                     volumeView_.alpha = 1.0;
                   }
   ];
}

@end
