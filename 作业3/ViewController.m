//
//  ViewController.m
//  作业3
//
//  Created by gongwenkai on 2016/12/6.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"
#import "WaterFallLayout.h"
static NSString *identifier = @"collectionView";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFallLayoutDelegate>
@property(nonatomic,strong)UICollectionView *myCollectionView;
@property(nonatomic,strong)NSMutableArray *imageViewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myCollectionView];
}

- (UICollectionView*)myCollectionView {
    if (!_myCollectionView) {
        
        //使用自定义布局
        WaterFallLayout *layout = [[WaterFallLayout alloc] init];
        layout.delegate = self;
//        layout.rowMargin = 0;
//        layout.column = 4;
//        layout.columnMargin = 10;
//        layout.edge = UIEdgeInsetsMake(20, 10, 100, 40);
    
        _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor redColor];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        //从nib上获取 注册单元格
        [_myCollectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        //正常注册单元格
//        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
    }
    return _myCollectionView;
}



- (NSMutableArray*)imageViewArray {
    if (!_imageViewArray) {
        
        //初始化16张图片 UIImage 放入数组
        _imageViewArray = [NSMutableArray array];
        for (int i = 0; i < 16; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg",i+1]];
            [_imageViewArray addObject:img];
        }
    }
    return _imageViewArray;
}

///按比例压缩图片 获得实际高度
- (float)setImageHeightWithOldHeight:(float)oldHeight withOldWidth:(float)oldWidth forNewWidth:(float) nWidth{
    
    float newHeight = oldHeight / oldWidth * nWidth;
    return newHeight;
}


//MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageViewArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //使用缓存池中的cell
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath ];
    if (!cell) {
        cell = [[CustomCollectionViewCell alloc] init];
    }
    //设置cell图片
    cell.imageView.image = self.imageViewArray[indexPath.item];
    return cell;
}


//MARK: - 自定义瀑布流delegate

- (CGFloat) collectionViewHeightAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width {
    
    UIImage *image = self.imageViewArray[indexPath.item];
    return [self setImageHeightWithOldHeight:image.size.height withOldWidth:image.size.width forNewWidth:width];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
