#import "ToolTipNavigation.h"
#import "CMPopTipView.h"
#import "UIView+AltAccessibility.h"

@interface ToolTipNavigation () <CMPopTipViewDelegate>
@property(copy, nonatomic) void (^handler)();
@property(nonatomic, copy) void (^block)();
@end

@implementation ToolTipNavigation

#pragma mark - Singleton methods

static ToolTipNavigation *sharedManager_ = nil;

+ (ToolTipNavigation *)sharedManager {
    if (!sharedManager_) {
        sharedManager_ = [[self alloc] init];
        sharedManager_.showAgainIfUntapped = true;
    }
    return sharedManager_;
}

- (void)searchView:(UIView *)view {
    for (UIView *subview in [view subviews]) {
        UIControl *element = (UIControl *) subview;
        if (element.altAccessibility != nil) {
            [self.allElements addObject:element];
        }
        [self searchView:subview];
    }
}

- (void)cleanUpToolTipsInView {
    // 綺麗な状態にしてから始める
    [self dismissAll];
    self.currentDisplayIndex = -1;
    self.allPopups = [NSMutableArray array];
    self.allElements = [NSMutableArray array];
}

#pragma mark - Show

- (void)showInViewController:(UIViewController *)viewController {
    [self showInViewController:viewController handler:nil];
}

- (void)showInViewController:(UIViewController *)viewController handler:(void (^)())h {
    [self dismissAll];
    self.handler = h;
    if (UIAccessibilityIsVoiceOverRunning()) {
        return;
    }
    [self cleanUpToolTipsInView];
    [self searchView:viewController.view];
    [self showNextPopup:viewController];
}

- (void)showNextPopup:(UIViewController *)vc {
    self.currentDisplayIndex++;
    if (self.currentDisplayIndex < [self.allElements count]) {
        [self showPopupAtIndex:self.currentDisplayIndex view:vc];
    } else if (self.handler) {
        self.handler();
    }
}

- (void)showPopupAtIndex:(NSUInteger)index view:(UIViewController *)viewcController {
    UIControl *element = (self.allElements)[index];
    NSString *popupText = [self popupText:element];

    if ([self isShowedPopup:popupText]) {
        [self showNextPopup:viewcController];
    } else {
        if ([element respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
            [element addTarget:self action:@selector(popTipViewWasDismissedByUser:) forControlEvents:UIControlEventTouchUpInside];
        }

        CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:popupText];
        [self.allPopups addObject:popTipView];// ポップアップ配列に追加
        __weak typeof(self) this = self;
        self.block = ^{
            [this setShowedPopup:popupText];

            [popTipView dismissAnimated:YES];
            [this.allPopups removeObject:popTipView];

            [this showNextPopup:viewcController];
            if ([element respondsToSelector:@selector(removeTarget:action:forControlEvents:)]) {
                [element removeTarget:this action:@selector(popTipViewWasDismissedByUser:) forControlEvents:UIControlEventTouchUpInside];
            }
        };
        [popTipView setDelegate:self];
        if (self.customPopTipView) {
            self.customPopTipView(popTipView);
        }
        
        if (!self.showAgainIfUntapped) {
            [self setShowedPopup:popupText];
        }

        UIView *activeView = viewcController.view;
        [popTipView presentPointingAtView:element inView:activeView animated:YES];
    }
}

- (NSString *)popupText:(UIControl *)element {
    return element.altAccessibility;
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    if (self.block) {
        self.block();
    }
}

- (void)dismissAll {
    for (id obj in self.allPopups) {
        [obj dismissAnimated:NO];
    }
}

- (BOOL)isShowedPopup:(NSString *)popupText {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:[self saveKey:popupText]];
}

- (void)setShowedPopup:(NSString *)popupText {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:[self saveKey:popupText]];
    [defaults synchronize];
}

- (void)resetShowedPopup:(NSString *)popupText {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:[self saveKey:popupText]];
    [defaults synchronize];
}

- (NSString *)saveKey:(NSString *)popupText {
    return [NSString stringWithFormat:@"TOOLTIP_%@", popupText];
}

- (void)resetAll {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in [[defaults dictionaryRepresentation] allKeys]) {
        if ([key hasPrefix:@"TOOLTIP"]) {
            [defaults removeObjectForKey:key];
        }
    }
    [defaults synchronize];
}
@end
