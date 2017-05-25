//
//  CustomFlowLayout.m
//  UICollectionViewCustomLayout
//
//  Created by blazer on 16/9/9.
//  Copyright © 2016年 blazer. All rights reserved.
//

#import "CustomFlowLayout.h"

/*
 1.cell的放大和缩小
 2.停止滚动：cell居中
 */

@implementation CustomFlowLayout

//特别注意 布局的初始化操作 不要在init方法中 做布局的初始化操作
- (void)prepareLayout{
    [super prepareLayout];
    /*
     1.一个cell对应一个UICollectionViewLayoutAttributes对象
     2.UICollectionViewLayoutAttributes对象决定了cell的摆设位置(frame)
     */
    //默认水平垂直
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //设置内边距
    CGFloat insert = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
}

/*  这个方法只要拖动collectionView就会被调用
 这个方法的返回值是一个数组（数组里存放在rect范围内所有元素的布局属性）
 这个方法的返回值 决定了rect范围内所有的元素的排布（frame)
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //获得supper已经计算好的布局属性 只有线性布局才能使用(必须要继承UICollectionViewFlowLayout才有的）
    NSArray *array = [super layoutAttributesForElementsInRect:rect];  //得到了所有的cell的布局属性
    //计算CollectionView最中心的x值
    CGFloat centetX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2;
    for (UICollectionViewLayoutAttributes *attrs in array) {
//        CGFloat scale = arc4random_uniform(100) /100.0;
//        attrs.indexPath.item 表示这个attrs对应的Cell的位置
//        NSLog(@" 第%zdcell--距离：%.1f",attrs.indexPath.item ,attrs.center.x - centetX);
        //cell的中心点x和collectionView最中心点的x值
        CGFloat delta = ABS(attrs.center.x - centetX); //相隔的距离
        
        //根据间距值 计算cell的缩放的比例
        //这里的scale必须要小于1
        CGFloat scale = 1 - delta / self.collectionView.frame.size.width;

        //设置缩放的比例
        /*
         * CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)两个参数，代表x和y方向缩放倍数
         * CGAffineTransformScale(CGAffineTransform t,CGFloat sx,CGFloat sy)三个参数，第一个为要进行变换的矩陈，二三为x和y方向缩放倍数
         区别:
         * CGAffineTransformMakeScale是对单位矩陈进行缩放
         * CGAffineTransformScale是对第一个参数的矩陈进行缩放
         * 比如已经对一个view缩放0.5，还想在这个基础上继续缩放0.5，那么就把这个view.transform作为第一个参数传到CGAffineTransformScale里面，缩放之后的view则变为0.25(CGAffineTransformScale(view.transform, 0.5, 0.5)。如果用CGAffineTransformMakeScale方法，那么这个view仍旧是缩放0.5(CGAffineTransformMakeScale(0.5, 0.5)).
         另外想要将两个transform的属性都改变的话，需要：
         alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
         alertView.transform = CGAffineTransfromTranslate(alertView.transform, 0, 600);
         或者
         CGAffineTransform viewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.25, 0.25), CGAffineTransformMakeTranslation(0, 600));
         alertView.transform = viewTransform;
         */
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

/*
 * 多次调用 只要滑出范围就会 调用
 * 当collectionView的显示范围发生改变的时候，是否重新布局
 * 一旦重新刷新 布局，就会重新调用
 * 1.layoutAttributesForElementsInRect:方法
 * 2.prepareLayout方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


/*
 * 只要手一松开就会调用
 * 这个方法的返回值，就决定了CollectionView停止滚动时的偏移量
 * proposedContentOffset这个是最终的 偏移量的值但是实际的情况还是要根据返回值来定
 * velocity 是滚动速率 有个x和y 如果x有值说明x上有速度
 * 如果y有值 说明y上有速度，还可以通过x或者y的正负来判断是左还是右（上还是下滑动） 有时候会有用
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //计算出 最终显示的矩形框
    CGRect rect;
    rect.origin.x = proposedContentOffset.x; //proposedContentOffset是停止后的值
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect]; //得到当前rect里的所有cell的frame
    
    //这里的计算和上面的计算不一样的
    //计算collectionView最中心点的x值 这里要求最终的要考虑惯性
    CGFloat centerX = self.collectionView.frame.size.width / 2 + proposedContentOffset.x;
    
    //存放的最小间距
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) { //因为minDelta是重复计算的，所以只会有一组成立，然后就显示在中间 而这个只会跟后面一排和前面一排来进行对比
            NSLog(@"222222");
            minDelta = attrs.center.x - centerX;   //是0就不会移动，
        }
    }
    
    //修改原有的偏移量
    proposedContentOffset.x += minDelta;
    
    //如果返回的是zero 那个滑动停止 就会立刻回到原地
    return proposedContentOffset;
}

@end
