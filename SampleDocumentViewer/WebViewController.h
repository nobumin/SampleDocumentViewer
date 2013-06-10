//
//  WebViewController.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/05.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView_;
    NSString *path_;
}

- (void)setFilePath:(NSString*)path;

@end
