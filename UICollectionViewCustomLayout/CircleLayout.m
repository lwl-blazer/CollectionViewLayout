 //
//  CircleLayout.m
//  UICollectionViewCustomLayout
//
//  Created by blazer on 16/9/9.
//  Copyright © 2016年 blazer. All rights reserved.
//

#import "CircleLayout.h"

@interface CircleLayout ()

@property(nonatomic, strong) NSMutableArray *attrsArr;

@end

@implementation CircleLayout

- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (void)prepareLayout{
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
    [self creatAttrs];
}


- (void)creatAttrs{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    /*
     * 因为不是继承流水布局 UICollectionViewFlowLayout
     * 所以我们需要自己创建 UICollectionViewlayoutAttributes
     */
    //如果是多组的话，需要2层循环
    for (NSInteger i = 0; i < count; i ++) {
        //创建UICollectionViewLayoutAttributes
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 特别注意 在这个方法中 可以边滑动边刷新（添加）   一劳永逸 如果只需要添加一次的话，可以把这些prepareLayout方法中去
    return self.attrsArr;
}

#pragma mark -----这个方法需要返回indexPath位置对应cell的布局属性   每一个cell的布局
/*
 * 这个方法主要用于 切换布局的时候如果不适用该方法 就不会切换布局的时候会报错
 *   reason: 'no UICollectionViewLayoutAttributes instance for -layoutAttributesForItemAtIndexPath: <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}'
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //主要是返回每个indexPath的attrs
    
    //创建UICollectionViewLayoutAttributes
    //这里需要告诉UICollectionViewLayoutAttributes 是哪里的attrs
    //计算出每组有多少个
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //角度
    CGFloat angle = 2 * M_PI / count * indexPath.item;
    NSLog(@"%lf----%ld----angle:%lf----sin:%lf----cos:%lf", 2 *M_PI, count *indexPath.item, angle, sin(angle), cos(angle));
    
    //设置半径
    CGFloat radius = 100;
    
    //CollectionView的圆心位置
    CGFloat ox = self.collectionView.frame.size.width / 2;
    CGFloat oy = self.collectionView.frame.size.height / 2;
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /*sin 正弦    三角函数关系
     *cos 余弦
     */
    attrs.center = CGPointMake(ox + radius * sin(angle), oy + radius *cos(angle));
    if (count == 1) {
        attrs.size = CGSizeMake(200, 200);
    }else{
        attrs.size = CGSizeMake(50, 50);
    }
    return attrs;
}

@end
