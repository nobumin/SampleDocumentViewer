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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [table_ reloadData];
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
    
//    [table_ reloadRowsAtIndexPaths:[table_ visibleCells] withRowAnimation:UITableViewRowAnimationFade];
    [table_ reloadData];
  }
}

#pragma mark -

 - (void)refresh
{
    [table_ reloadData];
    [refreshCtrl_ endRefreshing];
}

@end
