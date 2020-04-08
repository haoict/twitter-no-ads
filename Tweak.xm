@interface TFNItemsDataViewController : NSObject
- (id)itemAtIndexPath:(id)arg1;
@end

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