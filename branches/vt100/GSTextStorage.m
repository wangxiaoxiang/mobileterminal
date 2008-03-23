/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

// Original - Christopher Lloyd <cjwl@objc.net>
#import "GSTextStorage.h"
#import "GSTextStorage_concrete.h"
//#import <AppKit/NSLayoutManager.h>
#import "GSAttributedString.h"
//#import <AppKit/NSNibKeyedUnarchiver.h>
#import "Debug.h"

NSString *GSTextStorageWillProcessEditingNotification=@"GSTextStorageWillProcessEditingNotification";
NSString *GSTextStorageDidProcessEditingNotification=@"GSTextStorageDidProcessEditingNotification";

@implementation GSTextStorage
+allocWithZone:(NSZone *)zone {
   if(self==[GSTextStorage class])
    return NSAllocateObject([GSTextStorage_concrete class],0,NULL);

   return NSAllocateObject(self,0,zone);
}

-initWithString:(NSString *)string {
   _layoutManagers=[NSMutableArray new];
   return self;
}

-(void)dealloc {
   [_layoutManagers release];
   [super dealloc];
}

-delegate {
   return _delegate;
}

-(NSArray *)layoutManagers {
   return _layoutManagers;
}

-(int)changeInLength {
   return _changeInLength;
}

-(unsigned)editedMask {
   return _editedMask;
}

-(NSRange)editedRange {
   return _editedRange;
}

-(void)setDelegate:delegate {
   _delegate=delegate;
}

//-(void)addLayoutManager:(NSLayoutManager *)layoutManager {
  // [_layoutManagers addObject:layoutManager];
   //   [layoutManager setTextStorage:self];
//}

//-(void)removeLayoutManager:(NSLayoutManager *)layoutManager {
  // [_layoutManagers removeObjectIdenticalTo:layoutManager];
//}

-(void)beginEditing {

   if(_beginEditing==0){
    _editedMask=0;
    _editedRange=NSMakeRange(-1,-1);
    _changeInLength=0;
   }

   _beginEditing++;
}

-(void)endEditing {
   _beginEditing--;
   if(_beginEditing==0)
    [self processEditing];
}

-(NSRange)invalidatedRange {
   return _editedRange;
}

-(void)processEditing {
   //int i,count;

   //[[NSNotificationCenter defaultCenter] postNotificationName: GSTextStorageWillProcessEditingNotification object:self];

   //[self fixAttributesInRange:_editedRange];

   //[[NSNotificationCenter defaultCenter] postNotificationName: GSTextStorageDidProcessEditingNotification object:self];

   //count=[_layoutManagers count];
   //for(i=0;i<count;i++){
    //NSLayoutManager *layout=[_layoutManagers objectAtIndex:i];

    //[layout textStorage:self edited:[self editedMask] range:[self editedRange]
    //   changeInLength:[self changeInLength]
    //  invalidatedRange:[self invalidatedRange]];
   //}
}

-(void)edited:(unsigned)editedMask range:(NSRange)range changeInLength:(int)delta {
   if(_beginEditing==0){
    _editedMask=editedMask;
    _changeInLength=delta;
    range.length+=delta;
    _editedRange=range;
    
    [self processEditing];
   }
   else {
    _editedMask|=editedMask;
    _changeInLength+=delta;
    range.length+=delta;

    if(_editedRange.location==-1 && _editedRange.length==-1)
     _editedRange=range;
    else
     _editedRange=NSUnionRange2(_editedRange,range);
   }
}

@end