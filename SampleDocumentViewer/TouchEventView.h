//
//  TouchEventView.h
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/09.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchEventDelegate 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface TouchEventView : UIView {
  id<TouchEventDelegate> callback_;
}

- (void)setCallback:(id<TouchEventDelegate>)callback;

@end
