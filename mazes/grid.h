//
//  grid.h
//  mazes
//
//  Created by Bion Oren on 11/3/20.
//

#import <Foundation/Foundation.h>
#import "cell.h"

@interface Grid : NSObject

@property (readonly) int rows;
@property (readonly) int columns;
@property (readonly) int size;

-(id)initWithRows:(int)rows Columns:(int)columns;
-(Cell*)cellForRow:(int)row Column:(int)column;
-(Cell*)cellForIndex:(int)index;
-(Cell*)start;
-(Cell*)end;

@end
