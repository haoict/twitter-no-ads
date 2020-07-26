#include "TNARootListController.h"

#define TWEAK_TITLE "Twitter No Ads"
#define TINT_COLOR "#63ccff"
#define BUNDLE_NAME "TNAPref"

@implementation TNARootListController
- (id)init {
  self = [super init];
  if (self) {
    self.tintColorHex = @TINT_COLOR;
    self.bundlePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle", @BUNDLE_NAME];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self localizedItem:@"APPLY"] style:UIBarButtonItemStylePlain target:self action:@selector(apply)];;
  }
  return self;
}

- (void)apply {
  [HCommon killProcess:@"Twitter" viewController:self alertTitle:@TWEAK_TITLE message:[self localizedItem:@"DO_YOU_REALLY_WANT_TO_KILL_TWITTER"] confirmActionLabel:[self localizedItem:@"CONFIRM"] cancelActionLabel:[self localizedItem:@"CANCEL"]];
}

@end
