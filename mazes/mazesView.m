//
//  mazesView.m
//  mazes
//
//  Created by Bion Oren on 11/2/20.
//

#define CELL_SIZE 20

#import "mazesView.h"
#import "grid.h"
#import "algorithms/huntAndKill.h"
#import "algorithms/recursiveBacktracker.h"
#import "algorithms/algorithm.h"
#import "solver.h"

@interface mazesView ()

@property (nonatomic, retain) Grid* grid;
@property (nonatomic, retain) NSObject<Algorithm>* algorithm;
@property (nonatomic, retain) Solver* solver;
@property (nonatomic, assign) int waitTicks;

@end

@implementation mazesView

@synthesize grid;
@synthesize algorithm;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    if (self = [super initWithFrame:frame isPreview:isPreview]) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation {
    [super startAnimation];

    [self reset];
}

- (void)stopAnimation {
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;
    CGColorRef white = [NSColor whiteColor].CGColor;
    CGColorRef green = [NSColor greenColor].CGColor;

    CGSize size = CGSizeMake(self.grid.columns * CELL_SIZE, self.grid.rows * CELL_SIZE);
    float deltax = rect.size.width - size.width;
    float deltay = rect.size.height - size.height;
    CGRect frame = CGRectMake(rect.origin.x + deltax / 2, rect.origin.y + deltay / 2, size.width, size.height);

    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, white);
    CGContextStrokeRect(ctx, frame);

    for(int r = 0; r < self.grid.rows; r++) {
        for(int c = 0; c < self.grid.columns; c++) {
            Cell* node = [self.grid cellForRow:r Column:c];
            if(!node.explored) {
                continue;
            }

            CGRect nodeFrame = CGRectMake(frame.origin.x + c * CELL_SIZE, frame.origin.y + r * CELL_SIZE, CELL_SIZE, CELL_SIZE);

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

- (void)animateOneFrame {
    [self setNeedsDisplay:YES];

    if([self.algorithm step]) {
        if(self.solver == nil) {
            self.solver = [[Solver alloc] initWithGrid:self.grid];
        }
        if([self.solver step]) {
            self.waitTicks++;
        }
    }

    if(self.waitTicks > 5 / self.animationTimeInterval) {
        [self reset];
    }

    return;
}

- (void)reset {
    self.waitTicks = 0;
    int rows = self.bounds.size.height / CELL_SIZE;
    int cols = self.bounds.size.width / CELL_SIZE;

    self.grid = [[Grid alloc] initWithRows:rows Columns:cols];
    self.algorithm = [[RecursiveBacktracker alloc] initWithGrid:self.grid];
    self.solver = nil;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
