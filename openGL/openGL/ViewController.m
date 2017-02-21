//
//  ViewController.m
//  openGL
//
//  Created by ychou on 2017/2/16.
//  Copyright © 2017年 ychou. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *dataArr;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OpenGL ES 练习首页";
    dataArr = @[@{@"class":@"GLTriangles",@"name":@"三角形示例"}];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = dataArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%li.  %@",(long)indexPath.row,dic[@"name"]];//dic[@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString * classString = ((NSDictionary*)dataArr[indexPath.row])[@"class"];
    Class controlelrClass = NSClassFromString(classString);
    UIViewController *vc = [[controlelrClass alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end

