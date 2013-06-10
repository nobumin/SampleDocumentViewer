//
//  PlayerControllerView.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/08.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol PlayerControllerDelegate

- (void) startPlayback;
- (void) endPlayback;

@end

@interface PlayerControllerView : UIView {
  IBOutlet UIView *viewMain_;
  IBOutlet UIBarButtonItem *stopAirPlayBtn_;
  IBOutlet UIBarButtonItem *playAirPlayBtn_;
  IBOutlet UIView *stopAirPlayView_;
  IBOutlet UIView *playAirPlayView_;
  
  IBOutlet UISlider *slider_;
  
  IBOutlet UIToolbar *toolBarBase_;
  IBOutlet UIToolbar *toolBarPlay_;
  IBOutlet UIToolbar *toolBarStop_;
}

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)rewind:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)sliderChange:(id)sender;

- (void)setPlayer:(AVPlayer*)player withDelegate:(id<PlayerControllerDelegate>) callback;
- (void)endPlay;
- (void)terminatePlayer;

@end
