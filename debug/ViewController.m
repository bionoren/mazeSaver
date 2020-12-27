//
//  ViewController.m
//  debug
//
//  Created by Bion Oren on 12/16/20.
//

#import "ViewController.h"
#import "mazeView.h"

@interface ViewController () {}

@property (nonatomic, retain) mazeView *maze;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.maze = [[mazeView alloc] initWithFrame:self.view.bounds];
    [self.maze reset];
    [self.view addSubview:self.maze];

    [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(update) userInfo:nil repeats:YES];
}

-(void)update {
    [self.maze step];
    [self.maze setNeedsDisplay:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
