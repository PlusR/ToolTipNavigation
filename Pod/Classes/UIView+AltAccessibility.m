#import <objc/runtime.h>
#import "UIView+AltAccessibility.h"

@implementation UIView (AltAccessibility)

static char UIB_PROPERTY_KEY;
@dynamic altAccessibilityHint;

- (void)setAltAccessibilityHint:(NSString *)value {
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)altAccessibilityHint {
    return (NSString *) objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

- (NSString *)altAccessibility {
    UIControl *control = (UIControl *) self;
    if ([control respondsToSelector:@selector(altAccessibilityHint)]) {
        if (control.accessibilityHint != nil) {
            return control.accessibilityHint;
        } else if (control.altAccessibilityHint != nil) {
            return control.altAccessibilityHint;
        }
    }
    return nil;
}


- (void)setAltAccessibility:(NSString *)value {
    UIControl *control = (UIControl *) self;
    [control setIsAccessibilityElement:YES];// アクセシビリティを有効にする
    [control setAccessibilityHint:value];
    control.altAccessibilityHint = value;
}
@end
