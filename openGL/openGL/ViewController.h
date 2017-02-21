//
//  ViewController.h
//  openGL
//
//  Created by ychou on 2017/2/16.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController
{
    GLuint vertexBufferID;
}


@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@end

