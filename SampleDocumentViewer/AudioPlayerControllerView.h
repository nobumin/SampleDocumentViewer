//
//  AudioPlayerControllerView.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/17.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerControllerViewDelegate

- (void) stopPlay;

@end

@interface AudioPlayerControllerView : UIView<AVAudioPlayerDelegate> {
  IBOutlet UIView *viewMain_;
  IBOutlet UIView *airPlayView_;
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

- (void)setAudioFilePath:(NSString*)path withCallback:(id<AudioPlayerControllerViewDelegate>) callback;
- (BOOL)isPlaying;


@end
