//
//  WaterFallLayout.h
//  作业3
//
//  Created by gongwenkai on 2016/12/7.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WaterFallLayoutDelegate<NSObject>

///设置图片高度
//width为cell实际宽度
- (CGFloat) collectionViewHeightAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width;

@end

@interface WaterFallLayout : UICollectionViewLayout

@property(nonatomic,assign)int column; //设置列数
@property(nonatomic,assign)int rowMargin; //设置行间距
@property(nonatomic,assign)int columnMargin;//设置列间距
@property(nonatomic,assign)UIEdgeInsets edge;//设置边距
@property(nonatomic,strong)id<WaterFallLayoutDelegate>delegate;

@end
