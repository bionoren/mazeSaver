//
//  mazeView.h
//  mazes
//
//  Created by Bion Oren on 12/16/20.
//

#import <AppKit/AppKit.h>
#import "grid.h"
#import "solver.h"

@interface mazeView : NSView

-(int)step;
-(void)reset;

@end
