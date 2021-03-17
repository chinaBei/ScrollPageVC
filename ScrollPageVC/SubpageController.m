//
//  SubpageController.m
//  ScrollPageVC
//
//  Created by huangjiawang on 2021/3/17.
//

#import "SubpageController.h"

@interface SubpageController ()

@end

@implementation SubpageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小分页";
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    CGFloat rr = r / 255.0;
    CGFloat rg = g / 255.0;
    CGFloat rb = b / 255.0;
    self.view.backgroundColor = [[UIColor alloc]initWithRed:rr green:rg blue:rb alpha:1];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
