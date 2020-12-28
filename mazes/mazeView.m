//
//  mazeView.m
//  mazes
//
//  Created by Bion Oren on 12/16/20.
//

#import <Foundation/Foundation.h>
#import "mazeView.h"
#import "algorithms/huntAndKill.h"
#import "algorithms/recursiveBacktracker.h"
#import "algorithms/algorithm.h"

#define CELL_SIZE 20
#define NODE_FRAME(r, c) CGRectMake(_frame.origin.x + c * CELL_SIZE, _frame.origin.y + r * CELL_SIZE, CELL_SIZE, CELL_SIZE)

@interface mazeView () {
    CGColorRef white;
    CGColorRef green;
    CGSize size;
    float deltax, deltay;
    CGRect _frame;
    
    Cell* current;
}

@property (nonatomic, retain) Grid* grid;
@property (nonatomic, retain) Solver* solver;
@property (nonatomic, retain) NSObject<Algorithm>* algorithm;
@property (nonatomic, assign) int waitTicks;
@property (nonatomic, assign) bool solving;
@property (nonatomic, assign) bool needReset;

@end

@implementation mazeView

@synthesize grid;
@synthesize solver;
@synthesize algorithm;
@synthesize waitTicks;
@synthesize solving;
@synthesize needReset;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        white = (CGColorRef)CFRetain([NSColor whiteColor].CGColor);
        green = (CGColorRef)CFRetain([NSColor greenColor].CGColor);

        [self reset];
        size = CGSizeMake(self.grid.columns * CELL_SIZE, self.grid.rows * CELL_SIZE);
        deltax = self.frame.size.width - size.width;
        deltay = self.frame.size.height - size.height;
        _frame = CGRectMake(deltax / 2, deltay / 2, size.width, size.height);
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;
    
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, white);
    
    if(self.needReset) {
        // if this section isn't here, the first maze clears the grid when solving begins
        // I have no idea why, but this fixes it
        CGContextSetStrokeColorWithColor(ctx, green);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, _frame.origin.x + self.grid.start.column * CELL_SIZE + CELL_SIZE / 2, _frame.origin.y + self.grid.start.row * CELL_SIZE + CELL_SIZE / 2);
        CGContextStrokePath(ctx);
        CGContextSetStrokeColorWithColor(ctx, white);
        
        CGContextFillRect(ctx, rect);
        CGContextStrokeRect(ctx, _frame);
    }

    if(current != nil) {
        [self drawNode:current inContext:ctx];
        for(enum Directions d = NORTH; d <= WEST; d++) {
            Cell* node = [current NeighborInDirection:d];
            if(node != nil && node.explored) {
                [self drawNode:node inContext:ctx];
            }
        }
    }

    if(self.solving) {
        CGContextSetStrokeColorWithColor(ctx, green);
        NSArray<Cell*>* path = [self.solver Path];
        CGContextBeginPath(ctx);

        CGContextMoveToPoint(ctx, _frame.origin.x + self.grid.start.column * CELL_SIZE + CELL_SIZE / 2, _frame.origin.y + self.grid.start.row * CELL_SIZE + CELL_SIZE / 2);
        for(int i = 1; i < path.count; i++) {
            Cell* n = [path objectAtIndex:i];
            CGContextAddLineToPoint(ctx, _frame.origin.x + n.column * CELL_SIZE + CELL_SIZE / 2, _frame.origin.y + n.row * CELL_SIZE + CELL_SIZE / 2);
        }
        CGContextStrokePath(ctx);
    }
}

- (void)drawNode:(Cell*)node inContext:(CGContextRef)ctx {
    int r = node.row;
    int c = node.column;
    CGRect nodeFrame = NODE_FRAME(r, c);

    int numPoints = 0;
    CGPoint points[8];
    CGPoint start = nodeFrame.origin;
    CGPoint end;
    for(enum Directions d = NORTH; d <= WEST; d++) {
        switch(d) {
        case NORTH:
            end = CGPointMake(start.x + nodeFrame.size.width, start.y);
            break;
        case EAST:
            end = CGPointMake(start.x, start.y + nodeFrame.size.height);
            break;
        case SOUTH:
            end = CGPointMake(start.x - nodeFrame.size.width, start.y);
            break;
        case WEST:
            end = nodeFrame.origin;
            break;
        }
        if(![node connected:d]) {
            points[numPoints++] = start;
            points[numPoints++] = end;
        }
        start = end;
    }

    CGContextStrokeLineSegments(ctx, points, numPoints);
}


- (int)step {
    current = [self.algorithm step];
    if(current == nil) {
        self.solving = true;
        current = [self.solver step];
        if(current == nil) {
            self.waitTicks++;
        }
    }
    
    if(current != nil) {
        int c = current.column;
        int r = current.row;
        [self displayRectIgnoringOpacity:NSMakeRect(_frame.origin.x + c * CELL_SIZE-1, _frame.origin.y + r * CELL_SIZE-1, CELL_SIZE+2, CELL_SIZE+2)];
    }

    return self.waitTicks;
}

- (void)reset {
    self.waitTicks = 0;
    int rows = self.bounds.size.height / CELL_SIZE;
    int cols = self.bounds.size.width / CELL_SIZE;

    current = nil;
    self.grid = [[Grid alloc] initWithRows:rows Columns:cols];
    self.algorithm = [[RecursiveBacktracker alloc] initWithGrid:self.grid];
    self.solver = [[Solver alloc] initWithGrid:self.grid];
    
    self.needReset = true;
    [self setNeedsDisplay:YES];
}

-(BOOL)wantsDefaultClipping {
    return NO;
}

-(BOOL)isOpaque {
    return YES;
}

@end
