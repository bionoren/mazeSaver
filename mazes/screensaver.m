//
//  mazesView.m
//  mazes
//
//  Created by Bion Oren on 11/2/20.
//

#import "screensaver.h"
#import "mazeView.h"

@interface screensaver ()

@property (nonatomic, retain) mazeView* maze;

@end

@implementation screensaver

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    if (self = [super initWithFrame:frame isPreview:isPreview]) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation {
    [super startAnimation];

    self.maze = [[mazeView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maze];
}

- (void)stopAnimation {
    [super stopAnimation];

    [self.maze removeFromSuperview];
    self.maze = nil;
}

- (void)animateOneFrame {
    int waitTicks = [self.maze step];

    if(waitTicks > 5 / self.animationTimeInterval) {
        [self.maze reset];
    }

    return;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
