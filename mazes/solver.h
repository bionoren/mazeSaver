//
//  solver.h
//  mazes
//
//  Created by Bion Oren on 11/26/20.
//

#import <Foundation/Foundation.h>
#import "grid.h"

@interface Solver : NSObject

-(id)initWithGrid:(Grid*)grid;
-(bool)step;
-(NSArray<Cell*>*)Path;

@end
