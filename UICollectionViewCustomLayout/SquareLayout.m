
//
//  SquareLayout.m
//  UICollectionViewCustomLayout
//
//  Created by blazer on 16/9/12.
//  Copyright © 2016年 blazer. All rights reserved.
//

#import "SquareLayout.h"

@interface SquareLayout ()

@property(nonatomic, strong) NSMutableArray *attrsArr;

@end

@implementation SquareLayout

- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

//每次发生改变的时候就会走这个prepareLayout方法，
- (void)prepareLayout{
    [super prepareLayout];
    [self.attrsArr removeAllObjects];
    NSLog(@"很多次");
    //collectionview上面rect中的 所有的cell的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0]; //得到有多少个cell
    for (NSInteger i = 0; i < count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];  //得到Index
        //设置每个indexPath的frame
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArr addObject:attrs];
    }
}

//赋值给在当前rect中的每个元素
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}

//设置每个元素的frame等值
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.collectionView.frame.size.width * 0.5;
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat height = width;
    NSInteger i = indexPath.item;

    switch (i) {
        case 0:
            attrs.frame = CGRectMake(0, 0, width, height);
            break;
        case 1:
            attrs.frame = CGRectMake(width, 0, width, height / 2);
            break;
        case 2:
            attrs.frame = CGRectMake(width, height / 2, width, height / 2);
            break;
        case 3:
            attrs.frame = CGRectMake(0, height, width, height / 2);
            break;
        case 4:
            attrs.frame = CGRectMake(0, height + height / 2, width, height / 2);
            break;
        case 5:
            attrs.frame = CGRectMake(width, height, width, height);
            break;
        default:
        {
              //依次得到上面的已经布局好了的
            UICollectionViewLayoutAttributes *lastattris = self.attrsArr[i - 6];   //得到上面5个的其中一个frame，或者前面已经计算过的frame
            CGRect frame = lastattris.frame;
            frame.origin.y += (2 * height);      //因为前两排跟后面的是相同的布局，只是originY的值的区别 而且就是相差两个高
            attrs.frame = frame;
        }
            break;
    }
    return attrs;
}


#pragma mark --返回CollectionView的内容大小 
//只要滚动都会走这个方法  就是计算cell的大小
- (CGSize)collectionViewContentSize{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];  //count是16 当删除的时候就会减少
    NSInteger rows = (count + 3 - 1) / 3;     //算出需要多少行
    CGFloat rowH = self.collectionView.frame.size.width / 2;  //高

    if ((count) % 6 == 4) {
        return CGSizeMake(0, rows * rowH - rowH/2); //因为上面 -1所以这里也要减掉一个高
    }else{
        return CGSizeMake(0, rows * rowH);
    }
}





@end
