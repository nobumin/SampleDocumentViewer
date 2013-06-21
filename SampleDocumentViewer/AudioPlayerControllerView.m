//
//  AudioPlayerControllerView.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/17.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AudioPlayerControllerView.h"

@interface AudioPlayerControllerView () {
  AVAudioPlayer *player_;
  NSTimer *playTimeWatcher_;
  NSMutableArray *playList_;
  int nowPlay_;
  id<AudioPlayerControllerViewDelegate> callback_;
}

@end

@implementation AudioPlayerControllerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super initWithCoder:decoder];
  if (self) {
    [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerControllerView" owner:self options:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [slider_ setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
    slider_.minimumValue = 0.0;
    slider_.maximumValue = 1.0;
    playList_ = [[NSMutableArray alloc] initWithCapacity:0];

    [self addSubview:viewMain_];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)play:(id)sender
{
  if(player_) {
    [player_ play];
    [toolBarBase_ setItems:[toolBarStop_ items] animated:YES];
  }
}

- (IBAction)pause:(id)sender
{
  if(player_) {
    [player_ pause];
    [toolBarBase_ setItems:[toolBarPlay_ items] animated:YES];
  }
}

- (IBAction)rewind:(id)sender
{
  if(player_) {
    if(player_.currentTime < 3.2 && [playList_ count] > 0) {
      nowPlay_--;
      if(nowPlay_ < 0) {
        nowPlay_ = [playList_ count]-1;
      }
      if(player_) {
        [slider_ setValue:0.0];
      }
      NSError *activationError = nil;
      player_ = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[playList_ objectAtIndex:nowPlay_]] error:&activationError];
      player_.numberOfLoops = 0;
      player_.delegate = self;
      if(player_ && [player_ prepareToPlay] && ![player_ isPlaying]) {
        slider_.maximumValue = player_.duration;
        [player_ play];
      }
    }else{
      [player_ setCurrentTime:0];
    }
  }
}

- (IBAction)forward:(id)sender
{
  if(player_) {
    [player_ setCurrentTime:player_.duration];
  }
}

- (IBAction)stop:(id)sender
{
  if(player_) {
    [player_ stop];
    [toolBarBase_ setItems:[toolBarPlay_ items] animated:YES];
  }
  [playList_ removeAllObjects];
  player_ = nil;
  [callback_ stopPlay];
}

- (IBAction)sliderChange:(id)sender
{
  if(player_) {
    player_.currentTime = slider_.value;
  }
}

- (void)sliderUpdate:(id)sender {
  if(player_) {
    [slider_ setValue:player_.currentTime];
  }
}

- (BOOL)isPlaying
{
  if(player_) {
    return [player_ isPlaying];
  }
  return NO;
}

- (void) interruption:(NSNotification*)notification
{
  NSDictionary *interuptionDict = notification.userInfo;
  NSUInteger interuptionType = (NSUInteger)[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];

  if (interuptionType == AVAudioSessionInterruptionTypeBegan) {
  }else if (interuptionType == AVAudioSessionInterruptionTypeEnded){
  }else if (interuptionType == AVAudioSessionInterruptionTypeEnded) {
  }
}

- (void) routeChange:(NSNotification*)notification
{
  NSLog(@"routeChange");
}

- (void)setAudioFilePath:(NSString*)path withCallback:(id<AudioPlayerControllerViewDelegate>) callback
{
  callback_ = callback;
  NSError *activationError = nil;
  AVAudioSession *audio = [AVAudioSession sharedInstance];
  [audio setCategory:AVAudioSessionCategoryPlayback error:&activationError];
  [audio setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&activationError];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];

  [playList_ removeAllObjects];
  nowPlay_ = 0;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL isDir;
  if([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
    if(isDir) {
      NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:nil];
      for(int i=0;i<[fileList count];i++) {
        NSString *file = [[NSString alloc] initWithFormat:@"%@/%@", path, [fileList objectAtIndex:i]];
        NSString *ext = [file pathExtension];
        if([[ext lowercaseString] isEqualToString:@"mp3"] ||
           [[ext lowercaseString] isEqualToString:@"m4a"] ||
           [[ext lowercaseString] isEqualToString:@"wav"]){
          [playList_ addObject:file];
        }
      }
      player_ = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[playList_ objectAtIndex:nowPlay_]] error:&activationError];
      player_.numberOfLoops = 0;
    }else{
      player_ = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:path] error:&activationError];
      player_.numberOfLoops = -1;
    }
  }
  player_.delegate = self;
  if(player_ && [player_ prepareToPlay] && ![player_ isPlaying]) {
    slider_.maximumValue = player_.duration;
    [player_ play];
    if(!playTimeWatcher_) {
      playTimeWatcher_ = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(sliderUpdate:) userInfo:nil repeats:YES];
    }
  }
  
  MPVolumeView *mpVolumeView = [[MPVolumeView alloc] initWithFrame: airPlayView_.frame];
  [airPlayView_ addSubview: mpVolumeView];
  [mpVolumeView setAutoresizingMask:
   UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
  [mpVolumeView sizeToFit];

  [toolBarBase_ setItems:[toolBarStop_ items] animated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  nowPlay_++;
  if(nowPlay_ >= [playList_ count]) {
    nowPlay_ = 0;
  }
  if(player_) {
    [slider_ setValue:0.0];
  }
  NSError *activationError = nil;
  player_ = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[playList_ objectAtIndex:nowPlay_]] error:&activationError];
  player_.numberOfLoops = 0;
  player_.delegate = self;
  if(player_ && [player_ prepareToPlay] && ![player_ isPlaying]) {
    slider_.maximumValue = player_.duration;
    [player_ play];
  }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
  if(player_) {
    if(playTimeWatcher_) {
      [playTimeWatcher_ invalidate];
      playTimeWatcher_ = nil;
    }
    [slider_ setValue:0.0];
  }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
  if(player_) {
    [player_ stop];
    [toolBarBase_ setItems:[toolBarPlay_ items] animated:NO];
  }
  [playList_ removeAllObjects];
  player_ = nil;
  [callback_ stopPlay];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
  NSLog(@"audioPlayerEndInterruption");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
  NSLog(@"audioPlayerEndInterruption");
}

@end
