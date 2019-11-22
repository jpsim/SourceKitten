#import <Foundation/Foundation.h>

/**
 Tests for miscellaneous code formatting options in header docs.
 */
@interface CodeFormatting : NSObject

/**
 Basic @c CodeFormatting usage, in the middle of a sentence.
 */
- (void)codeWordBasic;

/**
 Tests what happens with code word at the end of a line: @c CodeFormatting
 */
- (void)codeWordEndOfLine;

/**
 Tests a basic code block:

 @code
 -[CodeFormatting codeBlockBasic]
 @endcode
 */
- (void)codeBlockBasic;

/**
 Tests an inline @code-[CodeFormatting codeBlockBasic]@endcode code block.

 Per Xcode's behavior when formatting Obj-C doc comments, this doesn't actually result in
 the code block being _displayed_ inline, but writing it as inline is potentially common enough
 to justify testing the results of this format.
 */
- (void)codeBlockInline;

@end
