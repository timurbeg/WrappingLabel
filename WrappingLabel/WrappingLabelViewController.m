//
//  WrappingLabelViewController.m
//  WrappingLabel
//
//  Created by Timur Begaliev on 5/14/11.
//  Copyright 2011 DataSite Technologies. All rights reserved.
//

#import "WrappingLabelViewController.h"
#import "TextWrappedImageView.h"


@implementation WrappingLabelViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    NSString *someText = @"This is some text for 2 UILabel objects that should wrap around the UIImageView object for example from right and bottom sides.This is some text for 2 UILabel objects that should wrap around the UIImageView object for example from right and bottom sides.";
    
    UIImage *firstImage     = [UIImage imageNamed:@"1.jpeg"];
    UIImage *secondImage    = [UIImage imageNamed:@"2.jpeg"];
    UIImage *thirdImage     = [UIImage imageNamed:@"3.jpeg"];
    UIImage *forthImage     = [UIImage imageNamed:@"4.jpeg"];

    UIImageView *view1 = [[UIImageView alloc] initWithImage:firstImage];
    UIImageView *view2 = [[UIImageView alloc] initWithImage:secondImage];
    view2.frame = CGRectMake(0, 0, 80, 80);
    UIImageView *view3 = [[UIImageView alloc] initWithImage:thirdImage];
    UIImageView *view4 = [[UIImageView alloc] initWithImage:forthImage];
    view4.frame = CGRectMake(0, 0, 80, 80);
    
    TextWrappedImageView *wrapView = [[[TextWrappedImageView alloc] initWithImageView:view1
                                                                            frame:CGRectMake(10, 10, 300, 120) 
                                                                         wrapText:someText] autorelease];
    CGFloat dy = wrapView.frame.origin.y + wrapView.height;
    
    TextWrappedImageView *wrapView2 = [[[TextWrappedImageView alloc] initWithImageView:view2 
                                                                             frame:CGRectMake(10, dy + 10, 300, 120) 
                                                                          wrapText:someText] autorelease];
    dy = wrapView2.frame.origin.y + wrapView2.height;

    TextWrappedImageView *wrapView3 = [[[TextWrappedImageView alloc] initWithImageView:view3
                                                                             frame:CGRectMake(10, dy + 10, 300, 120) 
                                                                          wrapText:someText] autorelease];
    dy = wrapView3.frame.origin.y + wrapView3.height;

    TextWrappedImageView *wrapView4 = [[[TextWrappedImageView alloc] initWithImageView:view4
                                                                             frame:CGRectMake(10, dy + 10, 300, 120) 
                                                                          wrapText:someText] autorelease];
    [self.view addSubview:wrapView];
    [self.view addSubview:wrapView2];
    [self.view addSubview:wrapView3];
    [self.view addSubview:wrapView4];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
