//
//  OpenGLView.m
//  openGL
//
//  Created by ychou on 2017/2/16.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import "OpenGLView.h"

@interface OpenGLView()
{
    CAEAGLLayer * _eaglLayear;// 展示openGL 图形的层
    EAGLContext * _context;// openGL上下文
    GLuint _colorRenderBuffer;// 颜色渲染缓冲
    
}

@end
@implementation OpenGLView


- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2 调用 glCreateShader来创建一个代表shader 的OpenGL对象。这时你必须告诉OpenGL，你想创建 fragment shader还是vertex shader。所以便有了这个参数：shaderType
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3 调用glShaderSource ，让OpenGL获取到这个shader的源代码。（就是我们写的那个）这里我们还把NSString转换成C-string
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4 调用glCompileShader 在运行时编译shader
    glCompileShader(shaderHandle);
    
    // 5 如果编译失败了，我们必须一些信息来找出问题原因。 glGetShaderiv 和 glGetShaderInfoLog  会把error信息输出到屏幕。（然后退出）
    GLint compileSuccess = 2;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

- (void)compileShaders {
    
    // 1 刚刚写的动态编译方法，分别编译了vertex shader 和 fragment shader
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2 调用了glCreateProgram glAttachShader  glLinkProgram 连接 vertex 和 fragment shader成一个完整的program。
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3 调用 glGetProgramiv  lglGetProgramInfoLog 来检查是否有error，并输出信息。
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4 调用 glUseProgram  让OpenGL真正执行你的program
    glUseProgram(programHandle);
    
    // 5 调用 glGetAttribLocation 来获取指向 vertex shader传入变量的指针。以后就可以通过这写指针来使用了。还有调用 glEnableVertexAttribArray来启用这些数据。（因为默认是 disabled的。）
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        
        [self compileShaders];
        [self render];
    }
    return self;
}

// 改变view 最底层的layear
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// 设置layear 不透明
- (void) setupLayer
{
    _eaglLayear = (CAEAGLLayer*)self.layer;
    _eaglLayear.opaque = YES;//完全不透明属性
    
    /**
     因为缺省的话，CALayer是透明的。而透明的层对性能负荷很大，特别是OpenGl的层。（如果可能，尽量都把层设置为不透明。另一个比较明显的例子是自定义tableview cell）
     */
}


#pragma mark -  设置上下文context
- (void)setupContext
{
    
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    
    /*
     无论你要OpenGL帮你实现什么，总需要这个 EAGLContext。
     
     　　EAGLContext管理所有通过OpenGL进行draw的信息。这个与Core Graphics context类似。
     
     　　当你创建一个context，你要声明你要用哪个version的API。这里，我们选择OpenGL ES 2.0.
     
     　　（容错处理，如果创建失败了，我们的程序会退出）
     */

}
#pragma mark - 创建render buffer （渲染缓冲区）
- (void) setupRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);//gen创建
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);//绑定
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayear];
    
    
    //Render buffer 是OpenGL的一个对象，用于存放渲染过的图像。
    //render buffer可以作为一个color buffer被引用，因为本质上它就是存放用于显示的颜色。
    
    /**
     * 1.调用glGenRenderbuffers来创建一个新的render buffer object。这里返回一个唯一的integer来标记render buffer（这里把这个唯一值赋值到_colorRenderBuffer）。有时候你会发现这个唯一值被用来作为程序内的一个OpenGL 的名称。（反正它唯一嘛）
     
     * 2.调用glBindRenderbuffer ，告诉这个OpenGL：我在后面引用GL_RENDERBUFFER的地方，其实是想用_colorRenderBuffer。其实就是告诉OpenGL，我们定义的buffer对象是属于哪一种OpenGL对象
     
     * 3.最后，为render buffer分配空间。renderbufferStorage
     */
}

#pragma mark - 创建一个 frame buffer （帧缓冲区）
- (void) setupFrameBuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    // frame buffer 帧缓冲区也是openGL的对象，它包含了前面提到的render buffer，以及其它后面会讲到的诸如：depth buffer、stencil buffer 和 accumulation buffer。
    
    // glFramebufferRenderbuffer 这个才有点新意。它让你把前面创建的buffer render依附在frame buffer的GL_COLOR_ATTACHMENT0位置上。
}

#pragma mark - 清理屏幕
- (void) render
{
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    /**
        为了尽快在屏幕上显示一些什么，在我们和那些 vertexes、shaders打交道之前，把屏幕清理一下，显示另一个颜色吧。（RGB 0, 104, 55，绿色吧）
     
     　　这里每个RGB色的范围是0~1，所以每个要除一下255.
     
     　　下面解析一下每一步动作：
     
     　　1.      调用glClearColor ，设置一个RGB颜色和透明度，接下来会用这个颜色涂满全屏。
     
     　　2.      调用glClear来进行这个“填色”的动作（大概就是photoshop那个油桶嘛）。还记得前面说过有很多buffer的话，这里我们要用到GL_COLOR_BUFFER_BIT来声明要清理哪一个缓冲区。
     
     　　3.      调用OpenGL context的presentRenderbuffer方法，把缓冲区（render buffer和color buffer）的颜色呈现到UIView上。
     */
}



@end
