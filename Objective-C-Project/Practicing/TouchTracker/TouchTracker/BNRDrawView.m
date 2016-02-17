//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 谢乾坤 on 2/17/16.
//  Copyright © 2016 QiankunXie. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()

@property (nonatomic, strong) NSMutableDictionary *lineInprogress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.lineInprogress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTapcognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapcognizer.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:doubleTapcognizer];
    }
    
    return self;
}

- (void)doubleTap:(UIGestureRecognizer *)gr
{
    NSLog(@"double tao");
    
     [self.lineInprogress removeAllObjects];
     [self.finishedLines removeAllObjects];
     [self setNeedsDisplay];
    
    
}


- (void) strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        
        CGPoint location = [t locationInView:self];
        
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.lineInprogress[key] = line;
        
    }
    
//    self.currentLine = [[BNRLine alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
//    
    [self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.lineInprogress[key];
        
        line.end = [t locationInView:self];
    }
    
//    UITouch *t = [touches anyObject];
//    CGPoint location = [t locationInView:self];
//    
//    self.currentLine.end = location;
    
    [self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.lineInprogress[key];
        
        [self.finishedLines addObject:line];
        [self.lineInprogress removeObjectForKey:key];
        
        }
    
//    [self.finishedLines addObject:self.currentLine];
//    
//    self.currentLine = nil;
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.lineInprogress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[UIColor redColor] set];
    for(BNRLine *line in self.finishedLines){
        [self strokeLine:line];
    }
    
    [[UIColor blackColor] set];
    for(NSValue *key in [self.lineInprogress allKeys]){
        [self strokeLine:self.lineInprogress[key]];
    }
    
//    if(self.currentLine){
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
    
}


@end
