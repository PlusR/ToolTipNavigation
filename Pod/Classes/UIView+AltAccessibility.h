#import <UIKit/UIKit.h>

@interface UIView (AltAccessibility)
@property(nonatomic, retain) NSString *altAccessibilityHint;

- (NSString *)altAccessibility;

- (void)setAltAccessibility:(NSString *)value;
@end
