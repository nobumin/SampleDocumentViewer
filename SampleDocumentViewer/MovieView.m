//
//  MovieView.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/08.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MovieView.h"

@implementation MovieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

+ (Class)layerClass
{
  return [AVPlayerLayer class];
}

@end
