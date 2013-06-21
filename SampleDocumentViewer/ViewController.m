//
//  ViewController.m
//  TestOfficeViewer
//
//  Created by 長島 伸光 on 2013/06/05.
//  Copyright (c) 2013年 長島 伸光. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
  NSArray *fileList_;
  UIRefreshControl *refreshCtrl_;

  UIBarButtonItem *editItem_;
  UIBarButtonItem *playItem_;
  UIBarButtonItem *ctrlItem_;
  
  UIBarButtonItem *endItem_;
  
  CGFloat touchBeginY_;
}

@end

@implementation ViewController

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  refreshCtrl_ = [[UIRefreshControl alloc] init];
  [refreshCtrl_ addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  [table_ addSubview:refreshCtrl_];

  [playControllerView_ setCallback:self];
  
  editItem_  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editOn)];
  playItem_  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playMusic)];
  ctrlItem_  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ctrl.png"]
                                                style:UIBarButtonItemStylePlain target:self action:@selector(viewController)];
  
  endItem_  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editOff)];
  UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
  [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, playItem_, nil] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //ヘッドフォンコントローラのイベントを受信する。
  [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  [self becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [table_ reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  //ヘッドフォンコントローラのイベントの受信を停止する
  [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
  [self resignFirstResponder];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  fileList_ = [fileManager contentsOfDirectoryAtPath:[[NSString alloc] initWithString:[pathDocs objectAtIndex:0]] error:nil];
    
  return [fileList_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[fileList_ objectAtIndex:indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[fileList_ objectAtIndex:indexPath.row]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell.textLabel setText:[fileList_ objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *fileName = [fileList_ objectAtIndex:indexPath.row];
  NSString *ext = [fileName pathExtension];
  if([[ext lowercaseString] isEqualToString:@"mp4"] || [[ext lowercaseString] isEqualToString:@"m4v"] || [[ext lowercaseString] isEqualToString:@"mov"]) {
    [movieViewController_ setFilePath:fileName];
    [self.navigationController pushViewController:movieViewController_ animated:YES];
  }else if([[ext lowercaseString] isEqualToString:@"mp3"] ||
           [[ext lowercaseString] isEqualToString:@"m4a"] ||
           [[ext lowercaseString] isEqualToString:@"wav"]){
    UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
    [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, ctrlItem_, nil] animated:YES];
    NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    [audioPlayerControllerView_ setAudioFilePath:[[NSString alloc] initWithFormat:@"%@/%@", [pathDocs objectAtIndex:0], fileName] withCallback:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }else{
    [webViewController_ setFilePath:fileName];
    [self.navigationController pushViewController:webViewController_ animated:YES];
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
    NSString *fileName = [fileList_ objectAtIndex:indexPath.row];
    NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [[NSString alloc] initWithFormat:@"%@/%@", [pathDocs objectAtIndex:0], fileName];
    
    if(![[NSFileManager defaultManager] removeItemAtPath:docPath error:nil]) {
      NSLog(@"can't delete file %@", fileName);
    }
    
    [table_ reloadData];
  }
}

#pragma mark -

 - (void)refresh
{
    [table_ reloadData];
    [refreshCtrl_ endRefreshing];
}

- (void)editOn
{
  UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
  [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:endItem_, nil] animated:YES];
  [table_ setEditing:YES animated:YES];
  
  //player停止
  [audioPlayerControllerView_ stop:nil];
}

- (void)playMusic
{
  UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
  [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, ctrlItem_, nil] animated:YES];
  
  NSArray *pathDocs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  [audioPlayerControllerView_ setAudioFilePath:[[NSString alloc] initWithFormat:@"%@/", [pathDocs objectAtIndex:0]] withCallback:self];
}

- (void)viewController
{
  CGFloat x = playControllerView_.frame.origin.x;
  CGFloat y = playControllerView_.frame.size.height * -1;
  CGFloat w = playControllerView_.frame.size.width;
  CGFloat h = playControllerView_.frame.size.height;
  if(playControllerView_.hidden) {
    playControllerView_.frame = CGRectMake(x, y, w, h);
    playControllerView_.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       playControllerView_.frame = CGRectMake(x, 0, w, h);
                     }
                     completion:^(BOOL finished){
                       UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
                       [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:ctrlItem_, nil] animated:YES];
                     }
     ];
  }else{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       playControllerView_.frame = CGRectMake(x, y, w, h);
                     }
                     completion:^(BOOL finished){
                       playControllerView_.hidden = YES;
                       UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
                       [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, ctrlItem_, nil] animated:YES];
                     }
     ];
  }
}

- (void)editOff
{
  [table_ setEditing:NO animated:YES];
  UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
  [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, playItem_, nil] animated:YES];
  
  //player停止処理
  [audioPlayerControllerView_ stop:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  touchBeginY_ = -1;
  touchBeginY_ = [[touches anyObject] locationInView:self.view].y;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(touchBeginY_ >= 0 && touchBeginY_-[[touches anyObject] locationInView:self.view].y > 120) {
    CGFloat x = playControllerView_.frame.origin.x;
    CGFloat y = playControllerView_.frame.size.height * -1;
    CGFloat w = playControllerView_.frame.size.width;
    CGFloat h = playControllerView_.frame.size.height;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       playControllerView_.frame = CGRectMake(x, y, w, h);
                     }
                     completion:^(BOOL finished){
                       playControllerView_.hidden = YES;
                       UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
                       [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, ctrlItem_, nil] animated:YES];
                     }
     ];
  }
}

//ヘッドフォンコントローライベント
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
  if(receivedEvent.type == UIEventTypeRemoteControl) {
    switch (receivedEvent.subtype) {
      case UIEventSubtypeRemoteControlTogglePlayPause:
        if([audioPlayerControllerView_ isPlaying]) {
          [audioPlayerControllerView_ pause:nil];
        }else{
          [audioPlayerControllerView_ play:nil];
        }
        break;
      case UIEventSubtypeRemoteControlPreviousTrack:
        [audioPlayerControllerView_ rewind:nil];
        break;
      case UIEventSubtypeRemoteControlNextTrack:
        [audioPlayerControllerView_ forward:nil];
        break;
      default:
        break;
    }
  }
}

- (void) stopPlay
{
  UINavigationItem *navigationItem = self.navigationController.navigationBar.topItem;
  [navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editItem_, playItem_, nil] animated:YES];
  CGFloat x = playControllerView_.frame.origin.x;
  CGFloat y = playControllerView_.frame.size.height * -1;
  CGFloat w = playControllerView_.frame.size.width;
  CGFloat h = playControllerView_.frame.size.height;
  if(!playControllerView_.hidden) {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       playControllerView_.frame = CGRectMake(x, y, w, h);
                     }
                     completion:^(BOOL finished){
                       playControllerView_.hidden = YES;
                     }
     ];
  }
}

@end
