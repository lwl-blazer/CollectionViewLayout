//
//  ViewController.m
//  UICollectionViewCustomLayout
//
//  Created by blazer on 16/9/9.
//  Copyright © 2016年 blazer. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"

#import "CircleLayout.h"
#import "SquareLayout.h"
#import "CustomFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong) UICollectionView *myCollectionView;

//collectionViewLayout系统自带的流水布局
@property(nonatomic, strong) UICollectionViewFlowLayout *defaultLayout;
//自定义的collectionViewLayout流水布局
@property(nonatomic, strong) CustomFlowLayout *layout;
//圆形布局
@property(nonatomic, strong) CircleLayout *circleLayout;
//方形布局
@property(nonatomic, strong) SquareLayout *squareLayout;

@end

static NSString * const photoCellId = @"photo";

@implementation ViewController

#pragma mark --init

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 16; i ++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%ld.jpg", i + 1]];
        }
    }
    return _dataArr;
}

- (UICollectionView *)myCollectionView{
    if (_myCollectionView == nil) {
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.defaultLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        [_myCollectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:photoCellId];
    }
    return _myCollectionView;
}

- (CustomFlowLayout *)layout{
    if (!_layout) {
        _layout = [[CustomFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(150, 150);
    }
    return _layout;
}

- (CircleLayout *)circleLayout{
    if (!_circleLayout) {
        _circleLayout = [[CircleLayout alloc] init];
    }
    return _circleLayout;
}

- (SquareLayout *)squareLayout{
    if (!_squareLayout) {
        _squareLayout = [[SquareLayout alloc] init];
    }
    return _squareLayout;
}

- (UICollectionViewFlowLayout *)defaultLayout{
    if (!_defaultLayout) {
        /*
         * UICollectionViewFlowLayout：是系统自带的唯一的布局 流水布局
         * 如果我们要自定义布局的话有2种方式
         1.继承于UICollectionViewLayout(比较底层不是流水布局，没有itemSize，scrollDirection等属性)
         2.继承于UICollectionViewFlowLayout(这个是继承与上一个的，有scrollDirection等属性)
         */
        _defaultLayout = [[UICollectionViewFlowLayout alloc] init];
        _defaultLayout.itemSize = CGSizeMake(150, 130);
        _defaultLayout.scrollDirection = UICollectionViewScrollDirectionVertical; //这2个都是流水布局的属性UICollectionViewFlowLayout
    }
    return _defaultLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myCollectionView];
    [self addChangeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChangeButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 80);
    btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height - 80);
    [btn setBackgroundImage:[UIImage imageNamed:@"sub_add"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"sub_add_h"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(changeLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//切换布局
- (void)changeLayout{
    if ([self.myCollectionView.collectionViewLayout isKindOfClass:[CircleLayout class]]) {
        [self.myCollectionView setCollectionViewLayout:self.layout animated:YES];
    }else if ([self.myCollectionView.collectionViewLayout isKindOfClass:[CustomFlowLayout class]]){
        [self.myCollectionView setCollectionViewLayout:self.squareLayout animated:YES];
    }else if ([self.myCollectionView.collectionViewLayout isKindOfClass:[SquareLayout class]]){
        [self.myCollectionView setCollectionViewLayout:self.defaultLayout animated:YES];
    }else{
        [self.myCollectionView setCollectionViewLayout:self.circleLayout animated:YES];
    }
}


#pragma mark --CollectionView的Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellId forIndexPath:indexPath];
    photoCell.imageName = [self.dataArr objectAtIndex:indexPath.item];
    return photoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArr removeObjectAtIndex:indexPath.item];
    [self.myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
}


@end
