

// “attribute”声明了这个shader会接受一个传入变量，这个变量名为“Position”。在后面的代码中，你会用它来传入顶点的位置数据。这个变量的类型是“vec4”,表示这是一个由4部分组成的矢量。
attribute vec4 Position; // 1


// 与上面同理，这里是传入顶点的颜色变量。
attribute vec4 SourceColor; // 2



// 这个变量没有“attribute”的关键字。表明它是一个传出变量，它就是会传入片段着色器的参数。“varying”关键字表示，依据顶点的颜色，平滑计算出顶点之间每个像素的颜色。
varying vec4 DestinationColor; // 3

void main(void) { // 4
    DestinationColor = SourceColor; // 5
    gl_Position = Position; // 6
}



/**
 4 每个shader都从main开始– 跟C一样嘛。
 
 　　5 设置目标颜色 = 传入变量：SourceColor
 
 　　6 gl_Position 是一个内建的传出变量。这是一个在 vertex shader中必须设置的变量。这里我们直接把gl_Position = Position; 没有做任何逻辑运算。
 */
