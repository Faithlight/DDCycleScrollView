//
//  SDCycleScrollView.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

/*
 * 当前版本为1.62
 * 更新日期：2016.04.21
 */

#import <UIKit/UIKit.h>
#import "SDCollectionViewCell.h"

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;

typedef enum {
    SDCycleScrollViewPageContolStyleClassic,        // 系统自带经典样式
    SDCycleScrollViewPageContolStyleAnimated,       // 自定义动画效果pagecontrol
    SDCycleScrollViewPageContolStyleNone            // 不显示pagecontrol
} SDCycleScrollViewPageContolStyle;

@class SDCycleScrollView;

@protocol SDCycleScrollViewDelegate <NSObject>
- (NSInteger)numberOfItemForCycleScrollView:(SDCycleScrollView *)cycleScrollView;
@optional
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView prepareImageView:(UIImageView *)imageView forItemAtIndex:(NSInteger)index;
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView prepareLabel:(UILabel *)label forItemAtIndex:(NSInteger)index;

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;


// ========== 轮播自定义cell ==========   不需要自定义轮播cell的请忽略以下代理方法

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view;

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view;

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView prepareCustomCell:(UICollectionViewCell *)cell forItemAtIndex:(NSInteger)index;

@end

@interface SDCycleScrollView : UIView


/** 初始轮播图（推荐使用） */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SDCycleScrollViewDelegate>)delegate;

- (void)startScroll;



//////////////////////  滚动控制API //////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, weak) id<SDCycleScrollViewDelegate> delegate;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

//////////////////////  自定义样式API  //////////////////////

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) SDCycleScrollViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

/** 滚动手势禁用（文字轮播较实用） */
- (void)disableScrollGesture;



@end
