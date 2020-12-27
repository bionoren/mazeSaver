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
#define NODE_FRAME(r, c) CGRectMake(frame.origin.x + c * CELL_SIZE, frame.origin.y + r * CELL_SIZE, CELL_SIZE, CELL_SIZE)

@interface mazeView () {
    CGColorRef white;
    CGColorRef green;
    CGSize size;
    float deltax, deltay;
    CGRect frame;
}

@property (nonatomic, retain) Grid* grid;
@property (nonatomic, retain) Solver* solver;
@property (nonatomic, retain) NSObject<Algorithm>* algorithm;
@property (nonatomic, assign) int waitTicks;

@end

@implementation mazeView

@synthesize grid;
@synthesize solver;
@synthesize algorithm;
@synthesize waitTicks;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        white = [NSColor whiteColor].CGColor;
        green = [NSColor greenColor].CGColor;

        size = CGSizeMake(self.grid.columns * CELL_SIZE, self.grid.rows * CELL_SIZE);
        deltax = self.frame.size.width - size.width;
        deltay = self.frame.size.height - size.height;
        frame = CGRectMake(deltax / 2, deltay / 2, size.width, size.height);
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;

    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, white);
    CGContextStrokeRect(ctx, frame);

    for(int r = 0; r < self.grid.rows; r++) {
        for(int c = 0; c < self.grid.columns; c++) {
            Cell* node = [self.grid cellForRow:r Column:c];
            if(!node.explored) {
                continue;
            }

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
    }

    if(self.solver != nil) {
        CGContextSetStrokeColorWithColor(ctx, green);
        NSArray<Cell*>* path = [self.solver Path];
        CGContextBeginPath(ctx);

        CGContextMoveToPoint(ctx, frame.origin.x + self.grid.start.column * CELL_SIZE + CELL_SIZE / 2, frame.origin.y + self.grid.start.row * CELL_SIZE + CELL_SIZE / 2);
        for(int i = 1; i < path.count; i++) {
            Cell* n = [path objectAtIndex:i];
            CGContextAddLineToPoint(ctx, frame.origin.x + n.column * CELL_SIZE + CELL_SIZE / 2, frame.origin.y + n.row * CELL_SIZE + CELL_SIZE / 2);
        }
        CGContextStrokePath(ctx);
    }
}

- (int)step {
    if([self.algorithm step]) {
        if(self.solver == nil) {
            self.solver = [[Solver alloc] initWithGrid:self.grid];
        }
        if([self.solver step]) {
            self.waitTicks++;
        }
    }

    // TODO can I use setNeedsDisplayInRect: instead? Is that faster?
    [self setNeedsDisplay:YES];

    return self.waitTicks;
}

- (void)reset {
    self.waitTicks = 0;
    int rows = self.bounds.size.height / CELL_SIZE;
    int cols = self.bounds.size.width / CELL_SIZE;

    self.grid = [[Grid alloc] initWithRows:rows Columns:cols];
    self.algorithm = [[RecursiveBacktracker alloc] initWithGrid:self.grid];
    self.solver = nil;
}

@end
