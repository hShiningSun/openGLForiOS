//
//  OpenGLView.h
//  openGL
//
//  Created by ychou on 2017/2/16.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLView : UIView{
    GLuint _positionSlot;
    GLuint _colorSlot;
}


@end
