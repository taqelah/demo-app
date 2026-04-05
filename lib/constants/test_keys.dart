import 'package:flutter/material.dart';

class TestKeys {
  // ============ Splash Screen ============
  static const splashLogo = Key('splash_logo');
  static const splashAppName = Key('splash_app_name_text');
  static const splashTagline = Key('splash_tagline_text');

  // ============ Login Screen ============
  static const loginLogo = Key('login_logo');
  static const loginAppName = Key('login_app_name_text');
  static const loginSubtitle = Key('login_subtitle_text');
  static const loginUsernameField = Key('login_username_field');
  static const loginPasswordField = Key('login_password_field');
  static const loginPasswordToggle = Key('login_password_toggle');
  static const loginButton = Key('login_button');
  static const loginErrorMessage = Key('login_error_message');
  static const loginCredentialsHint = Key('login_credentials_hint');

  // ============ Product Catalog Screen ============
  static const catalogSortButton = Key('catalog_sort_button');
  static const catalogCartBadge = Key('catalog_cart_badge');
  static const catalogGrid = Key('catalog_grid');
  static const catalogSearchBar = Key('catalog_search_bar');
  static const catalogSearchClear = Key('catalog_search_clear');
  static const catalogRefreshIndicator = Key('catalog_refresh_indicator');
  static Key catalogProductCard(int id) => Key('catalog_product_card_$id');

  // ============ Product Detail Screen ============
  static const detailImage = Key('detail_product_image');
  static const detailName = Key('detail_product_name');
  static const detailPrice = Key('detail_product_price');
  static const detailDescription = Key('detail_product_description');
  static const detailColorLabel = Key('detail_color_label');
  static const detailQuantityLabel = Key('detail_quantity_label');
  static const detailAddToCartButton = Key('detail_add_to_cart_button');
  static Key detailColorOption(int index) => Key('detail_color_option_$index');

  // ============ Cart Screen ============
  static const cartEmptyIcon = Key('cart_empty_icon');
  static const cartEmptyText = Key('cart_empty_text');
  static const cartContinueShoppingButton = Key('cart_continue_shopping_button');
  static const cartTotalText = Key('cart_total_text');
  static const cartCheckoutButton = Key('cart_checkout_button');
  static const cartItemsList = Key('cart_items_list');
  static Key cartItem(int index) => Key('cart_item_$index');
  static Key cartItemDelete(int index) => Key('cart_item_delete_$index');
  static Key cartItemDismissible(int productId) =>
      Key('cart_item_dismissible_$productId');

  // ============ Checkout Info Screen ============
  static const checkoutInfoTitle = Key('checkout_info_title');
  static const checkoutInfoFullName = Key('checkout_info_fullname_field');
  static const checkoutInfoAddress1 = Key('checkout_info_address1_field');
  static const checkoutInfoAddress2 = Key('checkout_info_address2_field');
  static const checkoutInfoCity = Key('checkout_info_city_field');
  static const checkoutInfoState = Key('checkout_info_state_field');
  static const checkoutInfoZip = Key('checkout_info_zip_field');
  static const checkoutInfoCountry = Key('checkout_info_country_field');
  static const checkoutInfoProceedButton = Key('checkout_info_proceed_button');

  // ============ Checkout Review Screen ============
  static const reviewShippingCard = Key('review_shipping_card');
  static const reviewTotalText = Key('review_total_text');
  static const reviewPlaceOrderButton = Key('review_place_order_button');
  static Key reviewOrderItem(int index) => Key('review_order_item_$index');

  // ============ Checkout Complete Screen ============
  static const completeSuccessIcon = Key('complete_success_icon');
  static const completeThankYouText = Key('complete_thank_you_text');
  static const completeMessageText = Key('complete_message_text');
  static const completeContinueButton = Key('complete_continue_button');

  // ============ About Screen ============
  static const aboutLogo = Key('about_logo');
  static const aboutAppName = Key('about_app_name');
  static const aboutVersion = Key('about_version');
  static const aboutDescriptionCard = Key('about_description_card');
  static const aboutDarkModeSwitch = Key('about_dark_mode_switch');

  // ============ App Drawer ============
  static const drawerLogo = Key('drawer_logo');
  static const drawerUsername = Key('drawer_username');
  static const drawerCatalogTile = Key('drawer_catalog_tile');
  static const drawerCartTile = Key('drawer_cart_tile');
  static const drawerAboutTile = Key('drawer_about_tile');
  static const drawerDarkModeSwitch = Key('drawer_dark_mode_switch');
  static const drawerLogoutTile = Key('drawer_logout_tile');
  static const drawerGesturesTile = Key('drawer_gestures_tile');
  static const drawerWebViewTile = Key('drawer_webview_tile');
  static const drawerDialogsTile = Key('drawer_dialogs_tile');
  static const drawerFormTile = Key('drawer_form_tile');
  static const drawerPermissionsTile = Key('drawer_permissions_tile');
  static const drawerNotificationsTile = Key('drawer_notifications_tile');
  static const drawerTabsTile = Key('drawer_tabs_tile');

  // ============ Cart Badge Widget ============
  static const cartBadgeIcon = Key('cart_badge_icon');
  static const cartBadgeCount = Key('cart_badge_count');

  // ============ Quantity Selector Widget ============
  static const quantityDecrementButton = Key('quantity_decrement_button');
  static const quantityValueText = Key('quantity_value_text');
  static const quantityIncrementButton = Key('quantity_increment_button');

  // ============ Sort Dialog Widget ============
  static const sortDialogTitle = Key('sort_dialog_title');
  static const sortOptionNameAsc = Key('sort_option_name_asc');
  static const sortOptionNameDesc = Key('sort_option_name_desc');
  static const sortOptionPriceAsc = Key('sort_option_price_asc');
  static const sortOptionPriceDesc = Key('sort_option_price_desc');

  // ============ Gesture Demo Screen ============
  static const gestureSwipeSection = Key('gesture_swipe_section');
  static Key gestureDismissibleCard(int index) =>
      Key('gesture_dismissible_card_$index');
  static const gestureReorderableList = Key('gesture_reorderable_list');
  static Key gestureReorderableItem(int index) =>
      Key('gesture_reorderable_item_$index');
  static const gestureLongPressCard = Key('gesture_long_press_card');
  static const gestureContextMenu = Key('gesture_context_menu');
  static const gestureDoubleTapImage = Key('gesture_double_tap_image');
  static const gesturePinchZoomContainer = Key('gesture_pinch_zoom_container');

  // ============ WebView Screen ============
  static const webviewUrlField = Key('webview_url_field');
  static const webviewGoButton = Key('webview_go_button');
  static const webviewContent = Key('webview_content');
  static const webviewLoadingIndicator = Key('webview_loading_indicator');
  static const webviewBackButton = Key('webview_back_button');
  static const webviewForwardButton = Key('webview_forward_button');
  static const webviewRefreshButton = Key('webview_refresh_button');

  // ============ Dialog Showcase Screen ============
  static const dialogResultText = Key('dialog_result_text');
  static const dialogAlertTrigger = Key('dialog_alert_trigger');
  static const dialogAlertOk = Key('dialog_alert_ok');
  static const dialogAlertCancel = Key('dialog_alert_cancel');
  static const dialogBottomSheetTrigger = Key('dialog_bottom_sheet_trigger');
  static const dialogBottomSheetClose = Key('dialog_bottom_sheet_close');
  static const dialogSnackbarTrigger = Key('dialog_snackbar_trigger');
  static const dialogDatePickerTrigger = Key('dialog_date_picker_trigger');
  static const dialogDatePickerValue = Key('dialog_date_picker_value');
  static const dialogTimePickerTrigger = Key('dialog_time_picker_trigger');
  static const dialogTimePickerValue = Key('dialog_time_picker_value');
  static const dialogSimpleTrigger = Key('dialog_simple_trigger');
  static const dialogSimpleSelectedValue = Key('dialog_simple_selected_value');
  static Key dialogSimpleOption(String name) =>
      Key('dialog_simple_option_$name');
  static const dialogFullscreenTrigger = Key('dialog_fullscreen_trigger');
  static const dialogFullscreenClose = Key('dialog_fullscreen_close');
  static const dialogFullscreenContent = Key('dialog_fullscreen_content');

  // ============ Form Showcase Screen ============
  static const formNameField = Key('form_name_field');
  static const formEmailField = Key('form_email_field');
  static const formPhoneField = Key('form_phone_field');
  static const formNumberField = Key('form_number_field');
  static const formPasswordField = Key('form_password_field');
  static const formDropdown = Key('form_dropdown');
  static const formCheckboxTerms = Key('form_checkbox_terms');
  static const formRadioSmall = Key('form_radio_small');
  static const formRadioMedium = Key('form_radio_medium');
  static const formRadioLarge = Key('form_radio_large');
  static const formSwitchNewsletter = Key('form_switch_newsletter');
  static const formSliderRating = Key('form_slider_rating');
  static const formSliderValueText = Key('form_slider_value_text');
  static const formDateField = Key('form_date_field');
  static const formTimeField = Key('form_time_field');
  static const formSubmitButton = Key('form_submit_button');
  static const formResetButton = Key('form_reset_button');

  // ============ Permission Screen ============
  static const permissionCameraButton = Key('permission_camera_button');
  static const permissionCameraStatus = Key('permission_camera_status');
  static const permissionLocationButton = Key('permission_location_button');
  static const permissionLocationStatus = Key('permission_location_status');
  static const permissionStorageButton = Key('permission_storage_button');
  static const permissionStorageStatus = Key('permission_storage_status');

  // ============ Notification Screen ============
  static const notificationInstantButton = Key('notification_instant_button');
  static const notificationScheduleButton = Key('notification_schedule_button');
  static const notificationStatusText = Key('notification_status_text');

  // ============ Tabs & Navigation Screen ============
  static const tabsFeedTab = Key('tabs_tab_feed');
  static const tabsSearchTab = Key('tabs_tab_search');
  static const tabsProfileTab = Key('tabs_tab_profile');
  static const tabsPageView = Key('tabs_pageview');
  static Key tabsPage(int index) => Key('tabs_page_$index');
  static const tabsSearchContent = Key('tabs_search_content');
  static const tabsBottomNav = Key('tabs_bottom_nav');
  static Key tabsBottomNavItem(int index) =>
      Key('tabs_bottom_nav_item_$index');
}
