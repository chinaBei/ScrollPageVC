//
//  HomeController.m
//  ScrollPageVC
//
//  Created by huangjiawang on 2021/3/17.
//

#import "HomeController.h"
#import "iCarousel.h"
#import "SubpageController.h"
#import "ScrollModel.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface HomeController ()<iCarouselDelegate,iCarouselDataSource>
@property(nonatomic,strong)iCarousel *carousel;
@property(nonatomic,strong)NSMutableArray * dataArr;//数据源  自己定义
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.pagingEnabled = YES;
    self.carousel.bounces = NO;
    [self.view addSubview:self.carousel];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.childViewControllers.count > 0){
        //切换页面返回时候从childViewControllers 当中遍历查询，把不符合条件的移除 符合条件的留下
        /*
              此处的model和数组可根据实际需要自由变换，这里只是展示说明用
         */
        __block NSMutableArray *difObject = [NSMutableArray array];
        //找到arr2中有,arr1中没有的数据
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ScrollModel *model = obj;
            [self.childViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SubpageController * vc = obj;
                //遍历选择符合条件的数据
                if ([model.data_Id isEqualToString:vc.getDataId]) {
                    [difObject addObject:obj];
                }
            }];
            
        }];
        //childViewControllers 因为是只读的，所以可先清空，在把符合条件的添加进去
        if(self.childViewControllers.count > 0){
           for (UIViewController *vc in self.childViewControllers) {
                [vc willMoveToParentViewController:nil];
                [vc removeFromParentViewController];
            }
        }
        if(difObject.count > 0){
            for (SubpageController *vc in difObject) {
                [self addChildViewController:vc];
            }
        }
        
    }
    
    [self.carousel reloadData];
}
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    //return the total number of items in the carousel
    if(self.dataArr.count == 0){
        return 1;
    }else{
        return self.dataArr.count;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    //childViewControllers里面有符合条件的不在创建，不符合的才创建
    if(self.dataArr.count == 0){
        SubpageController *pageVC = [[SubpageController alloc] init];
        view = pageVC.view;
        pageVC.view.frame = self.carousel.bounds;
        [self addChildViewController:pageVC];
        [pageVC didMoveToParentViewController:self];
    }else{
        ScrollModel *model = self.dataArr[index];
        if(self.childViewControllers.count <= self.dataArr.count){
            if(self.childViewControllers.count == 0){
                SubpageController *pageVC = [[SubpageController alloc] init];
                view = pageVC.view;
                pageVC.view.frame = self.carousel.bounds;
                pageVC.getDataId = model.data_Id;
                [self addChildViewController:pageVC];
                [pageVC didMoveToParentViewController:self];
            }else{
                __block BOOL isHave = NO;
                __block SubpageController *getVC;
                [self.childViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SubpageController *vc = obj;
                    if([vc.getDataId isEqualToString:model.data_Id]){
                        isHave = YES;
                        getVC = vc;
                        *stop = YES;
                    }
               }];
                if (!isHave) {
                    SubpageController *pageVC = [[SubpageController alloc] init];
                    view = pageVC.view;
                    pageVC.view.frame = self.carousel.bounds;
                    pageVC.getDataId = model.data_Id;
                    [self addChildViewController:pageVC];
                    [pageVC didMoveToParentViewController:self];
                }else{
                    view = getVC.view;
                    getVC.view.frame = self.carousel.bounds;
                }
            }
                
        }else{
            __block BOOL isHave = NO;
            __block SubpageController *getVC;
            [self.childViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SubpageController *vc = obj;
                if([vc.getDataId isEqualToString:model.data_Id]){
                    isHave = YES;
                    getVC = vc;
                    *stop = YES;
                }
           }];
            if (!isHave) {
                SubpageController *pageVC = [[SubpageController alloc] init];
                view = pageVC.view;
                pageVC.view.frame = self.carousel.bounds;
                pageVC.getDataId = model.data_Id;
                [self addChildViewController:pageVC];
                [pageVC didMoveToParentViewController:self];
            }else{
                view = getVC.view;
                getVC.view.frame = self.carousel.bounds;
                
            }
        }
    }
  
    return view;
}
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSLog(@"滚动到%li----%lu",(long)carousel.currentItemIndex,(unsigned long)self.childViewControllers.count);
    //从childViewControllers里面取出SubpageController，然后传值或者赋值，根据具体情况具体操作。
    if(self.dataArr.count > 0){
        if(carousel.currentItemIndex < self.dataArr.count){
            ScrollModel *model = self.dataArr[carousel.currentItemIndex];
            if(self.childViewControllers.count > 0){
               for (SubpageController *vc in self.childViewControllers) {
                   if([vc.getDataId isEqualToString:model.data_Id]){
                       //进行数据传递的地方
                       
                   }
                }
            }
        }
        
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    SubpageController *pageVC = [[SubpageController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];
}
-(NSMutableArray *)dataArr{
    if(_dataArr ==nil){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
