//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;

        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;

        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
        
        _dotView2 = [UIView new];
        [self addSubview:_dotView2];
        
        _dotView2.backgroundColor = [UIColor redColor];
        _dotView2.hidden = YES;
        
        _dotView2.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView2.layer.shouldRasterize = YES;
        
        _dotView3 = [UIView new];
        [self addSubview:_dotView3];
        
        _dotView3.backgroundColor = [UIColor redColor];
        _dotView3.hidden = YES;
        
        _dotView3.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView3.layer.shouldRasterize = YES;
        
        _plusLabel = [UILabel new];
        [self addSubview:_plusLabel];
        _plusLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _plusLabel.layer.shouldRasterize = YES;
        _plusLabel.hidden = YES;
        _plusLabel.textAlignment = NSTextAlignmentCenter;
        _plusLabel.font = [UIFont systemFontOfSize:8.0];
        _plusLabel.textColor = [UIColor whiteColor];
        _plusLabel.text = @"+";
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.frame = self.bounds;
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
    _refDotFrame = _dotView.frame;
    
    _dotView2.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView2.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView2.layer.cornerRadius = sizeDot / 2.;
    
    _dotView3.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView3.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView3.layer.cornerRadius = sizeDot / 2.;
}

- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
    }
    [dateFormatter setDateFormat:self.dayFormat];

    _textLabel.text = [ dateFormatter stringFromDate:_date];       
    [_manager.delegateManager prepareDayView:self];
}

- (void)adjustDotView:(NSArray<UIColor *> *)colors
{
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    sizeDot = sizeDot * _dotRatio;
    if (colors.count == 0) {
        _dotView.hidden = YES;
        _dotView2.hidden = YES;
        _dotView3.hidden = YES;
        _plusLabel.hidden = YES;
    }
    else if (colors.count == 1) {
        _dotView2.hidden = YES;
        _dotView3.hidden = YES;
        _dotView.hidden = NO;
        _plusLabel.hidden = YES;
        _dotView.frame = _refDotFrame;
        _dotView.backgroundColor = colors[0];
    }
    else if (colors.count == 2) {
        _dotView2.hidden = NO;
        _dotView.hidden = NO;
        _dotView3.hidden = YES;
        _plusLabel.hidden = YES;
        _dotView.backgroundColor = colors[1];
        _dotView2.backgroundColor = colors[0];
        
        _dotView2.frame = CGRectMake(_refDotFrame.origin.x-sizeDot / 1.5, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
        _dotView.frame = CGRectMake(_refDotFrame.origin.x+sizeDot / 1.5, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
    }
    else if (colors.count == 3) {
        _dotView2.hidden = NO;
        _dotView3.hidden = NO;
        _dotView.hidden = NO;
        _plusLabel.hidden = YES;
        _dotView.backgroundColor = colors[1];
        _dotView2.backgroundColor = colors[0];
        _dotView3.backgroundColor = colors[2];
        
        _dotView.frame = _refDotFrame;
        _dotView2.frame = CGRectMake(_refDotFrame.origin.x-sizeDot * 1.5, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
        _dotView3.frame = CGRectMake(_refDotFrame.origin.x+sizeDot * 1.5, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
    }
    else if (colors.count > 3) {
        _dotView2.hidden = NO;
        _dotView3.hidden = NO;
        _dotView.hidden = NO;
        _plusLabel.hidden = NO;
        _dotView.backgroundColor = colors[1];
        _dotView2.backgroundColor = colors[0];
        _dotView3.backgroundColor = colors[2];
        
        _dotView.frame = CGRectMake(_refDotFrame.origin.x-sizeDot*0.5, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);;
        _dotView2.frame = CGRectMake(_refDotFrame.origin.x-sizeDot * 2., _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
        _dotView3.frame = CGRectMake(_refDotFrame.origin.x+sizeDot * 1, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
        _plusLabel.frame = CGRectMake(_refDotFrame.origin.x+sizeDot * 2.3, _refDotFrame.origin.y, _refDotFrame.size.height, _refDotFrame.size.width);
    }
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

- (NSString *)dayFormat
{
    return self.manager.settings.zeroPaddedDayFormat ? @"dd" : @"d";
}

@end
