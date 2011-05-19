//
//  WrappingLabelAppDelegate.h
//  WrappingLabel
//
//  Created by Timur Begaliev on 5/14/11.
//  Copyright 2011 DataSite Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WrappingLabelViewController;

@interface WrappingLabelAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WrappingLabelViewController *viewController;

@end
