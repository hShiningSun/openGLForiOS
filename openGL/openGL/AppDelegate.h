//
//  AppDelegate.h
//  openGL
//
//  Created by ychou on 2017/2/16.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet OpenGLView *glView;

@end

