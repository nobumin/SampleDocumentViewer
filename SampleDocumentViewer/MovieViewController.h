//
//  MovieViewController.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/07.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerControllerView.h"
#import "MovieView.h"
#import "TouchEventView.h"

@interface MovieViewController : UIViewController<PlayerControllerDelegate, TouchEventDelegate> {
  IBOutlet PlayerControllerView *playerControllerView_;
  IBOutlet MovieView *movieView_;
  IBOutlet UIView *volumeView_;
  
  AVPlayer *player_;
  NSString *path_;
}

- (void)setFilePath:(NSString*)path;

@end
