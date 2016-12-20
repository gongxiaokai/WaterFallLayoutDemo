//
//  WaterFallLayout.m
//  作业3
//
//  Created by gongwenkai on 2016/12/7.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "WaterFallLayout.h"

@interface WaterFallLayout()
@property(nonatomic,strong)NSArray *attrsArray;  //最大Y值 每一列的 高度
@property(nonatomic,strong)NSMutableDictionary *maxYDict;  //最大Y值 每一列的 高度
@property(nonatomic,strong)NSString *minKey;//最小列的key
@property(nonatomic,strong)NSIndexPath *indexPath;//cell个数信息
@end
@implementation WaterFallLayout

-(instancetype)init {
    if (self = [super init]) {
        //设置默认值   3列 行间距10 列间距10 边距都为10
        self.column = 3;
        self.rowMargin = 10;
        self.columnMargin = 10;
        self.edge = UIEdgeInsetsMake(20, 10, 10, 10);
        self.maxYDict = [NSMutableDictionary dictionary];
        self.attrsArray = [NSArray array];
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (void)prepareLayout {
    [super prepareLayout];
    
//    NSLog(@"prepareLayout");
    
    //初始化字典
    for (int i = 0; i < _column; i++) {
        [self.maxYDict setObject:[NSNumber numberWithFloat:self.edge.top] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    self.minKey = @"0";
    
    
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        self.indexPath = [NSIndexPath indexPathWithIndex:i];
        UICollectionViewLayoutAttributes *arrts = [self layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:arrts];
    }
    
    self.attrsArray = array;
    
    
}

/*
 重写 设置collectionViewContentSize
 */
- (CGSize)collectionViewContentSize {
    
    //最高列关键字
    int columnHeight = 0;
    //默认取第一个元素
    float maxY = [[self.maxYDict objectForKey:@"0"] floatValue];
    //找到字典中最大的数
    for (int i = 0; i < self.maxYDict.allKeys.count; i++) {
        float height = [[self.maxYDict objectForKey:[NSString stringWithFormat:@"%d",i]] floatValue];
        if (maxY < height) {
            //保持maxY最小
            maxY = height;
            //记录key
            columnHeight = i;
        }
    }
    
    //读取最高列
    CGFloat maxHeight = [[self.maxYDict objectForKey:[NSString stringWithFormat:@"%d",columnHeight]] floatValue];
    
    return CGSizeMake(0, maxHeight + self.edge.bottom);
}


/*
 计算attributes的fram
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"layoutAttributesForItemAtIndexPath");
    
    //设置cell的宽
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width - self.edge.left - self.edge.right - self.columnMargin * (self.column -1) ) / self.column;
    //读取最小列的高度
    CGFloat minY = [[self.maxYDict objectForKey:self.minKey] floatValue] ;
    //设置cell的高
    CGFloat heightAtt = [self.delegate collectionViewHeightAtIndexPath:indexPath withItemWidth:width] + _rowMargin ;
    
    //找出字典中最小的一个数 存储对应的key 并更新最小列高度
    for (int i = 0; i < self.maxYDict.allKeys.count; i++) {
        float height = [[self.maxYDict objectForKey:[NSString stringWithFormat:@"%d",i]] floatValue];
        CGFloat columnHeight;
        if (minY > height) {
            minY = height;
            self.minKey = [NSString stringWithFormat:@"%d",i];
            columnHeight = minY + heightAtt;

        } else {
            columnHeight = height;
            
            [self.maxYDict setObject:[NSNumber numberWithFloat:columnHeight] forKey:[NSString stringWithFormat:@"%d",i]];

        }
        
    }
    
    //设置X,Y坐标
    CGFloat x = self.edge.left + [self.minKey floatValue] * (width + self.columnMargin);
    CGFloat y = [[self.maxYDict objectForKey:self.minKey] floatValue]	;
    
    //更新最小列的高度
    [self.maxYDict setObject:[NSNumber numberWithFloat:y+heightAtt] forKey:self.minKey];
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, heightAtt);

    
    return attrs;
}

//prepare后调用多次
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSLog(@"layoutAttributesForElementsInRect");
   
    return self.attrsArray;
}
@end
