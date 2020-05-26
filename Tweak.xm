#import "Tweak.h"

/**
 * Load Preferences
 */
BOOL noads;

static void reloadPrefs() {
  NSDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@PLIST_PATH] ?: [@{} mutableCopy];

  noads = [[settings objectForKey:@"noads"] ?: @(YES) boolValue];
}

%group NoAds
  %hook TFNItemsDataViewController
  - (id)tableViewCellForItem:(id)arg1 atIndexPath:(id)arg2 {
    UITableViewCell *tbvCell = %orig;
    id item = [self itemAtIndexPath: arg2];
    if ([item respondsToSelector: @selector(isPromoted)] && [item performSelector:@selector(isPromoted)]) {
      [tbvCell setHidden: YES];
    }
    return tbvCell;  
  }

  - (double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
    id item = [self itemAtIndexPath: arg2];
    if ([item respondsToSelector: @selector(isPromoted)] && [item performSelector:@selector(isPromoted)]) {
      return 0;
    }
    return %orig;
  }
  %end
%end

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) reloadPrefs, CFSTR(PREF_CHANGED_NOTIF), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  reloadPrefs();

  if (!noads) {
    return;
  }

  %init(NoAds);
}
