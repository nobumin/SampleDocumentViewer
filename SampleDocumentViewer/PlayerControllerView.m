//
//  PlayerControllerView.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/08.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import "PlayerControllerView.h"

@interface PlayerControllerView () {
  AVPlayer *player_;
  id<PlayerControllerDelegate> callback_;
  CMTime movieTime_;
  id obServer_;
}

@end

@implementation PlayerControllerView

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
    // Initialization code
    [[NSBundle mainBundle] loadNibNamed:@"PlayerControllerView" owner:self options:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [slider_ setThumbImage:[UIImage imageNamed:@"slider_btn"] forState:UIControlStateNormal];
    slider_.minimumValue = 0.0;
    slider_.maximumValue = 1.0;

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
  [player_ play];
  [toolBarBase_ setItems:[toolBarStop_ items] animated:YES];
  [callback_ startPlayback];
}

- (IBAction)pause:(id)sender
{
  [player_ pause];
  [toolBarBase_ setItems:[toolBarPlay_ items] animated:YES];
}

- (IBAction)rewind:(id)sender
{
  [player_ seekToTime:kCMTimeZero];
}

- (IBAction)forward:(id)sender
{
  [player_ seekToTime:movieTime_];
}

- (IBAction)stop:(id)sender
{
  [player_ pause];
  [player_ seekToTime:kCMTimeZero];
  slider_.value = 0;
  [toolBarBase_ setItems:[toolBarPlay_ items] animated:YES];
  [callback_ endPlayback];
}

- (IBAction)sliderChange:(id)sender
{
  int64_t value = slider_.value * movieTime_.timescale;
  CMTime moveTime = CMTimeMake(value, movieTime_.timescale);
  [player_ seekToTime:moveTime];
}

- (void)updateTime:(CMTime)time
{
  float val = (float)(time.value / time.timescale);
  slider_.value = val;
}

- (void)setPlayer:(AVPlayer*)player withDelegate:(id<PlayerControllerDelegate>) callback
{
  player_ = player;
  callback_ = callback;
  player_.allowsExternalPlayback = YES;
  movieTime_ = player_.currentItem.duration;

  slider_.maximumValue = movieTime_.value / movieTime_.timescale;
  if(obServer_) {
    [player_ removeTimeObserver:obServer_];
  }
  [player_ addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
    [self updateTime:time];
  }];
}

- (void)endPlay
{
  [player_ pause];
  [player_ seekToTime:kCMTimeZero];
  slider_.value = 0;
  [toolBarBase_ setItems:[toolBarPlay_ items] animated:YES];
}

- (void)terminatePlayer
{
  if(obServer_) {
    [player_ removeTimeObserver:obServer_];
  }
}

@end
