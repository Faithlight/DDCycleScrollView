//
//  TAPageControl.m
//  TAPageControl
//
//  Created by Tanguy Aladenise on 2015-01-21.
//  Copyright (c) 2015 Tanguy Aladenise. All rights reserved.
//

#import "TAPageControl.h"

/**
 *  Default number of pages for initialization
 */
static NSInteger const kDefaultNumberOfPages = 0;

/**
 *  Default current page for initialization
 */
static NSInteger const kDefaultCurrentPage = 0;

/**
 *  Default setting for hide for single page feature. For initialization
 */
static BOOL const kDefaultHideForSinglePage = NO;

/**
 *  Default setting for shouldResizeFromCenter. For initialiation
 */
static BOOL const kDefaultShouldResizeFromCenter = YES;

/**
 *  Default spacing between dots
 */
static NSInteger const kDefaultSpacingBetweenDots = 8;

/**
 *  Default dot size
 */
static CGSize const kDefaultDotSize = {8, 8};


@interface TAPageControl()


/**
 *  Array of dot views for reusability and touch events.
 */
@property (strong, nonatomic) NSMutableArray *dots;


@end

@implementation TAPageControl


#pragma mark - Lifecycle


- (id)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialization];
    }
    
    return self;
}


/**
 *  Default setup when initiating control
 */
- (void)initialization
{
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.hidesForSinglePage     = kDefaultHideForSinglePage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
}


#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(TAPageControl:didSelectPageAtIndex:)]) {
            [self.delegate TAPageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - Layout


/**
 *  Resizes and moves the receiver view so it just encloses its subviews.
 */
- (void)sizeToFit
{
    CGPoint center = self.center;
    [super sizeToFit];
    if (_shouldResizeFromCenter) {
        self.center = center;
    }
    [self resetDotViews];
}
- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeForNumberOfPages:self.numberOfPages];
}

- (void)updateDotsFrame
{
    if (self.numberOfPages == 0) {
        return;
    }
    CGFloat pointX = 0,pointY = 0;
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        UIView *dot;
        if (i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        } else {
            dot = [self generateDotView];
        }
        if (i == self.currentPage) {
            pointY = (self.frame.size.height-self.currentDotSize.height)/2;
            dot.frame = CGRectMake(pointX, pointY, self.currentDotSize.width, self.currentDotSize.height);
        }else {
            pointY = (self.frame.size.height-self.dotSize.height)/2;
            dot.frame = CGRectMake(pointX, pointY, self.dotSize.width, self.dotSize.height);
        }
        pointX = CGRectGetMaxX(dot.frame)+self.spacingBetweenDots;
        [self changeActivity:i == self.currentPage atIndex:i];
        
    }
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat height = MAX(self.dotSize.height, self.currentDotSize.height);
    return CGSizeMake((self.dotSize.width + self.spacingBetweenDots) * (pageCount - 1) + self.currentDotSize.width, height + 20);
}


#pragma mark - Utils


/**
 *  Generate a dot view and add it to the collection
 *
 *  @return The UIView object representing a dot
 */
- (UIView *)generateDotView
{
    UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectZero];
    dotView.clipsToBounds = YES;
    dotView.userInteractionEnabled = YES;
    [self addSubview:dotView];
    [self.dots addObject:dotView];
    return dotView;
}


/**
 *  Change activity state of a dot view. Current/not currrent.
 *
 *  @param active Active state to apply
 *  @param index  Index of dot for state update
 */
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index
{
    UIImageView *dotView = [self.dots objectAtIndex:index];
    dotView.backgroundColor = active ? self.currentDotColor : self.dotColor;
    dotView.image = active ? self.currentDotImage : self.dotImage;
    dotView.layer.cornerRadius = CGRectGetHeight(dotView.frame)/2;

}
- (void)resetDotViews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.dots removeAllObjects];
    [self updateDotsFrame];
}


- (void)hideForSinglePage
{
    if (self.dots.count == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

#pragma mark - Setters


- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    // Update dot position to fit new number of pages
    [self resetDotViews];
}


- (void)setSpacingBetweenDots:(NSInteger)spacingBetweenDots
{
    _spacingBetweenDots = spacingBetweenDots;
    
    [self resetDotViews];
}


- (void)setCurrentPage:(NSInteger)currentPage
{
    // If no pages, no current page to treat.
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    
    _currentPage = currentPage;
    [self updateDotsFrame];
}

- (void)setDotColor:(UIColor *)dotColor
{
    _dotColor = dotColor;
    [self resetDotViews];
}
- (void)setCurrentDotColor:(UIColor *)currentDotColor
{
    _currentDotColor = currentDotColor;
    [self resetDotViews];
}

- (void)setDotImage:(UIImage *)dotImage
{
    _dotImage = dotImage;
    _dotSize = dotImage.size;
    [self resetDotViews];
}


- (void)setCurrentDotImage:(UIImage *)currentDotimage
{
    _currentDotImage = currentDotimage;
    _currentDotSize = currentDotimage.size;
    [self resetDotViews];
}


#pragma mark - Getters


- (NSMutableArray *)dots
{
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    
    return _dots;
}


- (CGSize)dotSize
{
    // Dot size logic depending on the source of the dot view
    if (CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        if (self.dotImage) {
            _dotSize = self.dotImage.size;
        }else {
            _dotSize = kDefaultDotSize;
        }
    }
    return _dotSize;
}
- (CGSize)currentDotSize
{
    // Dot size logic depending on the source of the dot view
    if (CGSizeEqualToSize(_currentDotSize, CGSizeZero)) {
        if (self.currentDotImage) {
            _currentDotSize = self.currentDotImage.size;
        }else {
            _currentDotSize = kDefaultDotSize;
        }
    }
    return _currentDotSize;
}
@end
