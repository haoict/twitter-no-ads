#import "Tweak.h"

/**
 * Load Preferences
 */
BOOL noads;
BOOL hideNewsAndTrending;
BOOL canSaveVideo;

static void reloadPrefs() {
  NSDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@PLIST_PATH] ?: [@{} mutableCopy];

  noads = [[settings objectForKey:@"noads"] ?: @(YES) boolValue];
  hideNewsAndTrending = [[settings objectForKey:@"hideNewsAndTrending"] ?: @(YES) boolValue];
  canSaveVideo = [[settings objectForKey:@"canSaveVideo"] ?: @(YES) boolValue];
}

static void showDownloadPopup(id twStatus, UIViewController *viewController, void (^origHandler)(UIAlertAction *)) {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet];
  [alert addAction:[UIAlertAction actionWithTitle:@"Save Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    NSString* videoUrl = nil;
    if ([twStatus isKindOfClass:%c(TFNTwitterStatus)]) {
      videoUrl = ((TFNTwitterStatus *)twStatus).primaryMediaVideoURL;
    }
    // if primary video is m3u8 format, we can't save it, thus we have to look for another place to find .mp4 and save highest bitrate
    if (!videoUrl || [videoUrl containsString:@".m3u8"]) {
      long long bitrate = 0;
      for (TFSTwitterEntityMediaVideoVariant *video in ((id<T1StatusViewModel>)twStatus).primaryMediaInfo.mediaEntity.videoInfo.variants) {
        if ([video.contentType isEqualToString:@"video/mp4"] && video.bitrate > bitrate) {
          bitrate = video.bitrate;
          videoUrl = video.url;
        }
      }
    }
    [HDownloadMedia checkPermissionToPhotosAndDownload:videoUrl appendExtension:nil mediaType:Video toAlbum:@"Twitter"];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"Twitter Options" style:UIAlertActionStyleDefault handler:origHandler]];
  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
  [viewController presentViewController:alert animated:YES completion:nil];
}

%group NewsFeedAndPosts
  %hook TFNItemsDataViewController
    - (id)tableViewCellForItem:(id)arg1 atIndexPath:(id)arg2 {
      UITableViewCell *tbvCell = %orig;
      id item = [self itemAtIndexPath: arg2];

      if (noads && [item respondsToSelector: @selector(isPromoted)] && [item performSelector:@selector(isPromoted)]) {
        [tbvCell setHidden: YES];
        return tbvCell;
      }
      
      if (hideNewsAndTrending) {
        NSString *itemClassName = NSStringFromClass([item classForCoder]);
        if ([itemClassName isEqualToString:@"T1Twitter.URTTimelineTrendViewModel"]
            || [itemClassName isEqualToString:@"T1Twitter.URTTimelineEventSummaryViewModel"]
            || [itemClassName isEqualToString:@"T1URTTimelineMessageItemViewModel"]) {
          [tbvCell setHidden: YES];
          return tbvCell;
        }
      }

      return tbvCell;
    }

    - (double)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 {
      id item = [self itemAtIndexPath: arg2];

      if (noads && [item respondsToSelector: @selector(isPromoted)] && [item performSelector:@selector(isPromoted)]) {
        return 0;
      }

      if (hideNewsAndTrending) {
        NSString *itemClassName = NSStringFromClass([item classForCoder]);
        if ([itemClassName isEqualToString:@"T1Twitter.URTTimelineTrendViewModel"]
            || [itemClassName isEqualToString:@"T1Twitter.URTTimelineEventSummaryViewModel"]
            || [itemClassName isEqualToString:@"T1URTTimelineMessageItemViewModel"]) {
          return 0;
        }
      }

      return %orig;
    }
  %end
%end

%group SaveVideo
  %hook T1SlideshowViewController
    - (void)imageDisplayView:(id)arg1 didLongPress:(id)arg2 {
      %orig;
    }

    - (void)slideshowSeekController:(id)arg1 didLongPressWithRecognizer:(id)arg2 {
      id<T1StatusViewModel> twStatus = self.slideStatus;
      showDownloadPopup(twStatus, self, ^(UIAlertAction *action) { %orig; });
    }
  %end

  // doesn't work for ios 13 since it has haptic touch
  // %hook T1InlineMediaView
  //   - (void)_t1_longPressAction {
  //     if (self.longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
  //       UIViewController *vc = ((T1InlineMediaContainerView *)self.superview).tfn_viewController;
  //       id<T1StatusViewModel> twStatus = self.viewModel.viewModel;
  //       showDownloadPopup(twStatus, vc, ^(UIAlertAction *action) { %orig; });
  //     } else {
  //       %orig;
  //     }
  //   }
  // %end
%end

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) reloadPrefs, CFSTR(PREF_CHANGED_NOTIF), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  reloadPrefs();

  %init(NewsFeedAndPosts);

  if (canSaveVideo) {
    %init(SaveVideo);
  }
}
