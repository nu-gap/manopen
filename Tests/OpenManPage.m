#import <AppKit/AppKit.h>
#import "ManDocumentController.h"
#import "ManDocument.h"

static void CheckPage(ManDocument *document, NSString *expected)
{
    NSDate *deadline = [NSDate dateWithTimeIntervalSinceNow:0.2];
    [[NSRunLoop currentRunLoop] runUntilDate:deadline];
    NSString *text = [[document textView] string];
    if ([text length] == 0 || [text rangeOfString:expected].location == NSNotFound)
        [NSException raise:@"ManOpenTestFailure" format:@"Missing %@ in rendered page: %@", expected, text];
    [document close];
}

int main(void)
{
    CREATE_AUTORELEASE_POOL(pool);
    [NSApplication sharedApplication];
    ManDocumentController *controller = [[ManDocumentController alloc] init];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"QuitWhenLastClosed"];
    CheckPage([controller openWord:@"ls"], @"SYNOPSIS");
    CheckPage([controller openWord:@"printf(1)"], @"SYNOPSIS");
    CheckPage([controller openDocumentWithContentsOfFile:@"/usr/share/man/man1/ls.1.gz" display:YES], @"SYNOPSIS");
    CheckPage([controller openWord:@"manopen-no-such-page-938471"], @"No manual entry.");
    NSLog(@"PASS: named pages, explicit section, compressed file, missing page, and document closing");
    RELEASE(pool);
    return 0;
}
