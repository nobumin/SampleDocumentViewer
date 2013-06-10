//
//  WebViewController.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/05.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(path_ ) {
        NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [[NSString alloc] initWithFormat:@"%@/%@", [pathDocs objectAtIndex:0], path_];
        
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initFileURLWithPath:docPath]];
        [webView_ loadRequest:req];
    }else{
        [webView_ loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    path_ = nil;
}

- (void)setFilePath:(NSString*)path;
{
    path_ = [[NSString alloc] initWithString:path];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", [error description]);
}

@end
