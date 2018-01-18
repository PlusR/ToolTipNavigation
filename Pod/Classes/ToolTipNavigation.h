#import <UIKit/UIKit.h>

@class CMPopTipView;


@interface ToolTipNavigation : NSObject

@property(nonatomic, strong) NSMutableArray *allElements;
@property(nonatomic) NSUInteger currentDisplayIndex;
@property(nonatomic, strong) NSMutableArray *allPopups;
@property(nonatomic) BOOL showAgainIfUntapped; // 初期値=true

@property(nonatomic, copy) void (^customPopTipView)(CMPopTipView *);

+ (ToolTipNavigation *)sharedManager;

- (void)showInViewController:(UIViewController *)viewController;

- (void)showInViewController:(UIViewController *)viewController handler:(void (^)())handler;

- (void)dismissAll;

- (BOOL)isShowedPopup:(NSString *)string;

- (void)setShowedPopup:(NSString *)string;

- (void)resetShowedPopup:(NSString *)string;

- (void)resetAll;
@end
