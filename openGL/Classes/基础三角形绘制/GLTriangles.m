//
//  GLTriangles.m
//  openGL
//
//  Created by ychou on 2017/2/21.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import "GLTriangles.h"

typedef struct {
    GLKVector3 posionCoords;
}SceneVertex;

// 三角形
static const SceneVertex vertices[] = {
    {-0.5f,-0.5f,0.0},
    {0.5f,-0.5f,0.0},
    {-0.5f,0.5f,0.0}
};

@interface GLTriangles ()

@end

@implementation GLTriangles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"三角形示例";
    
    GLKView *view = (GLKView *)self.view;
    
    // 断言
    NSAssert([view  isKindOfClass:[GLKView class]], @"viewController's view is not GLKview");
    
    // 创建上下文,上下文持有 openGL 的操作状态
    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 给OpenGL ES 设置当前的上下文
    [EAGLContext setCurrentContext:view.context];
    
    // 一个应用可以使用多个上下文
    
    
    
    
    
    //创建提供标准OpenGL ES2.0的基本效果
    // 阴影语言程序并设置要用于所有后续渲染的常量
    self.baseEffect = [[GLKBaseEffect alloc]init];
    
    /*一个布尔值，指示是否使用常量颜色。
     如果值设置为GL_TRUE，则将存储在constantColor属性中的值用作每个顶点的颜色值。 如果值设置为GL_FALSE，那么应用程序将启用GLKVertexAttribColor属性并提供每顶点颜色数据。 默认值为GL_FALSE。*/
    self.baseEffect.useConstantColor = GL_TRUE;
    
    
    // 将背景颜色 存储在当前的上下文中,GLKit 中定义的用于保存 4 个颜色元 值的 C 数据结构体 GLKVector4 来设置这个点的颜色
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    
    
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);//设置清除后的底色
    
    
    //vertexBufferID缓存标识符，实际上是无符号整形0,表示没有缓存
    
    // 创建、绑定、初始化内容缓冲 储存在GPU的内存中
    glGenBuffers(1, &vertexBufferID);//创建一个第一无二的标识符
    
    //GL_ARRAY_BUFFER 类型用于指定一个顶点 性数组
    //glBindBuffer() 的第 2个 参数是要绑定的缓存的标识符。
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);//为接下来的运算绑定缓存，类似GL_ARRAY_BUFFER 只能在同一时间绑定一个，glBindBuffer() 的第一个参数是一个常量，用于指定要 定 一种类型的缓存。
    
    
    //OpenGL ES 2.0 对于 glBindBuffer() 的实现只支持 几种类型的缓存，GL_ARRAY_ BUFFER 和 GL_ELEMENT_ARRAY_BUFFER。GL_ELEMENT_ARRAY_BUFFER。
    
    
    
    
    // 复制应用的定点数据 到当前绑定的上下文的缓存中
    //1 初始化缓冲区内容，是哪一个缓存
    //2 复制进这个缓存的字节的数量
    //3 复制的字节的地地址
    //4 缓存怎么使用，GL_STATIC_ DRAW 提示会告诉上下文，缓存中的内容适合复制到 GPU 控制的内存
    //GL_DYNAMIC_DRAW 作为提示会告诉上下文，缓存内的数据会频繁改变，同时提示 OpenGL ES 以不同的方 式来处理缓存的存 。
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 除不再需要的顶点缓存和上下文。设置 vertexBufferID 为 0 避免了在对 应的缓存  除以后还使用其无效的标识符。设置视图的上下文 性为 nil 并设置当前 上下文为 nil，以便让 Cocoa Touch  回所有上下文使用的内存和其他资源
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != vertexBufferID) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    
    ((GLKView*)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // 准备绘制
    // baseEffect 准备好上下文，方便使用生成的属性，为绘图做准备
    [self.baseEffect prepareToDraw];
    
    
    // 清除每一个帧缓存的像素颜色并且设置成默认的清除背景颜色,也就是清除了当前的图像嘛
    glClear(GL_COLOR_BUFFER_BIT);
    
    //在 缓存 清除以后，是时候用存 在当前 定的OpenGL ES的GL_ARRAY_ BUFFER 类型的缓存中的顶点数据绘制例子中的三角形了。使用缓存的前三步已经 在 -viewDidLoad 方法中  行了
    
    
    // 启动顶点渲染操作，参数：当前绑定的缓存包含每个顶点的位置信息
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // 设置指针
    // 1,当前绑定的缓存包含每个顶点的位置信息
    // 2,每个位置 有三个部分
    // 3,每个部分保存的都是浮点类型的值
    // 4,小数点固定数据是否可以改变
    // 5,每一个顶点的保存需要多少个字节, 顶点位置数据是  封的。在一个顶点缓存中保存除了每个顶点位置的 X、Y、Z  标之 的其他数据也是 可能的。
    // 6,glVertexAttribPointer() 的最后一个 数是 NULL，这告诉 OpenGL ES 可以从当前  定的顶点缓存的开始位置  顶点数据。
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    
    
    
    // 1.GPU 怎么处理在 定的顶点缓存内的顶点数据,GL_TRIANGLES三角形
    // 2.缓存内的需要渲染的 第一个顶点的位置
    // 3.需要渲染的顶点的数量
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}



@end
