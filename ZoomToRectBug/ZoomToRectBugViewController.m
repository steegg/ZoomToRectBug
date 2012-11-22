//
//  ZoomToRectBugViewController.m
//  ZoomToRectBug
//
//  Created by Steve Greenwood on 22/11/2012.
//  Copyright (c) 2012 Alano Consulting Ltd. All rights reserved.
//
//
//  ZoomBugViewController.m
//  ZoomBug
//
//  Created by Steve Greenwood on 20/11/2012.
//  Copyright (c) 2012 Alano Consulting Ltd. All rights reserved.
//
//  To produce Bug, run on iPad Simulator (non Retina)
//      using code : CGRect crossFrame = CGRectMake(0.0, 0.0, 200.0, 400.0);
//  click on Update button, it works
//  click on Update button a second time, it uses the correct zoomScale
//      but displaces the contents to the bottom right corner
//
//  rotate the simulator to the RIGHT and it corrects the contents
//
//  repeat the above but with the contents frame larger than the scrollView frame by
//      using code : CGRect crossFrame = CGRectMake(0.0, 0.0, 750.0, 750.0);
//  There is no observable problem any more.


#import "ZoomToRectBugViewController.h"

#import "Cross.h"


@implementation ZoomToRectBugViewController

UIScrollView *scrollView;
UIView *contentView;
UIButton *button;
float maxZoom;


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSLog(@"    viewForZoomingInScrollView");
    return contentView;
}


- (void)recalculateSpaceNeeded {
    NSLog(@"recalculateSpaceNeeded");
    CGRect contentFrame = contentView.frame;
    NSLog(@"  scrollView.frame: %@",  NSStringFromCGRect(scrollView.frame));
    NSLog(@"  contentView.frame before: %@", NSStringFromCGRect(contentFrame));
    
    [scrollView setContentSize:contentFrame.size];           // critical to make Scroll work
    [scrollView zoomToRect:contentFrame animated:YES];
    NSLog(@"  contentView.frame after: %@  (maxZoom: %.1f)", NSStringFromCGRect(contentView.frame), maxZoom);
    NSLog(@"  scrollView.zoomScale: %.3f",  scrollView.zoomScale);
}


-(void)createShadowScrollView {
    CGRect defineLaterRect = CGRectMake(0.0, 0.0, 100.0, 100.0);            // dimensions calculated later
    contentView = [[UIView alloc] initWithFrame:defineLaterRect];
    [contentView setBackgroundColor:[UIColor blueColor]];
    
    scrollView = [[UIScrollView alloc] initWithFrame:defineLaterRect];
    [scrollView setBackgroundColor:[UIColor greenColor]];
    [scrollView addSubview:contentView];
    [self.view addSubview:scrollView];
    
    // Enable zooming
    maxZoom = 4.0;
	[scrollView setMinimumZoomScale:0.2];
	[scrollView setMaximumZoomScale:maxZoom];
	[scrollView setDelegate:self];              // so viewForZoomingInScrollView must be provided
}


- (void)updateView:(id)sender {
    NSLog(@"updateView");
    for (UIView *view in contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGRect crossFrame = CGRectMake(0.0, 0.0, 200.0, 400.0);         // highlights bug in zoomToRect method
    // CGRect crossFrame = CGRectMake(0.0, 0.0, 750.0, 750.0);      // Appear to works correctly
    Cross *cross = [[Cross alloc] initWithFrame:crossFrame];
    [contentView addSubview:cross];
    [contentView sendSubviewToBack:cross];
    contentView.frame = crossFrame;
    
    [self recalculateSpaceNeeded];
}


-(void)createButton {
    NSLog(@"create Button");
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Update" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updateView:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self.view addSubview:button];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createShadowScrollView];
    [self createButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation {
    NSLog(@"updateLayoutForNewOrientation");
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    CGSize appFrameSize;
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        // Portrait Orientation
        appFrameSize.width = bounds.size.width;
        appFrameSize.height = bounds.size.height;
    } else {
        // Landscape Orientation
        appFrameSize.width = bounds.size.height;
        appFrameSize.height = bounds.size.width;
    }
    
    float inset = 0.1 * appFrameSize.width;
    float verticalHeightPercentage = 0.7;
    float scrollHeight = verticalHeightPercentage * appFrameSize.height;
    float scrollWidth = appFrameSize.width - (2.0 * inset);
    NSLog(@"  appFrameSize: %@", NSStringFromCGSize(appFrameSize));
    
    // Calculate the dimensions depending on the orientation
    [scrollView setFrame:CGRectMake(inset, inset, scrollWidth, scrollHeight)];
    NSLog(@"  scrollView.frame: %@", NSStringFromCGRect(scrollView.frame));
    
    float horizontalCentre = 0.5 * appFrameSize.width;
    float buttonHeight = (1.0 + verticalHeightPercentage) / 2.0 * appFrameSize.height;
    button.center = CGPointMake(horizontalCentre, buttonHeight);
    
    [self recalculateSpaceNeeded];
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear: animated];
    [self updateLayoutForNewOrientation: self.interfaceOrientation];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    [self updateLayoutForNewOrientation: interfaceOrientation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end
