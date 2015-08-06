#import "KNPViewController.h"
#import "ToolTipNavigation.h"
#import "UIView+AltAccessibility.h"
#import "CMPopTipView.h"

@interface KNPViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@end

@implementation KNPViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.button1.altAccessibilityHint = @"Tool";
    self.button2.altAccessibilityHint = @"Tip";
    self.button3.altAccessibilityHint = @"Navigation";

    [[ToolTipNavigation sharedManager] setCustomPopTipView:^(CMPopTipView *popTipView){
        [popTipView setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:156 / 255.0 blue:22 / 255.0 alpha:1.0]];
        [popTipView setHasGradientBackground:NO];
        [popTipView setHasShadow:NO];
        [popTipView setHas3DStyle:NO];
        [popTipView setBorderColor:[UIColor clearColor]];
    }];
    [[ToolTipNavigation sharedManager] showInViewController:self];
}
- (IBAction)touchResetButton:(id)sender {
    [[ToolTipNavigation sharedManager] resetAll];
    [[ToolTipNavigation sharedManager] showInViewController:self];
}
@end
