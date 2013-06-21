//
//  ViewController.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/05.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "MovieViewController.h"
#import "TouchEventView.h"
#import "AudioPlayerControllerView.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TouchEventDelegate, AudioPlayerControllerViewDelegate> {
  IBOutlet UITableView *table_;
    
  IBOutlet WebViewController *webViewController_;
  IBOutlet MovieViewController *movieViewController_;
  IBOutlet TouchEventView *playControllerView_;
  IBOutlet AudioPlayerControllerView *audioPlayerControllerView_;
}

@end
