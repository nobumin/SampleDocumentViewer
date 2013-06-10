//
//  TouchEventView.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/09.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import "TouchEventView.h"

@implementation TouchEventView

#pragma mark -
#pragma mark UIView

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

#pragma mark -
#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(callback_) {
    [callback_ touchesBegan:touches withEvent:event];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(callback_) {
    [callback_ touchesCancelled:touches withEvent:event];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(callback_) {
    [callback_ touchesEnded:touches withEvent:event];
  }
}

#pragma mark -

- (void)setCallback:(id<TouchEventDelegate>)callback
{
  callback_ = callback;
}

@end
