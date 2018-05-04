//
//  Config.m

//#define SERVER_URL @"http://172.16.0.180:9000/api/"
#define SERVER_URL @"http://13.59.230.237/api/"

#define API_URL_USER_SIGNUP                 (SERVER_URL @"register")
#define API_URL_USER_LOGIN                  (SERVER_URL @"login")
#define API_URL_FORGOT_PASSWORD             (SERVER_URL @"forgot_password")
#define API_URL_UPDATE_USER                 (SERVER_URL @"update_profile")

#define API_URL_GET_MYDRAFTS                (SERVER_URL @"get_my_drafts")
#define API_URL_CREATE_DRAFT                (SERVER_URL @"create_draft")
#define API_URL_EDIT_DRAFT                  (SERVER_URL @"edit_draft")
#define API_URL_GENERATE_DRAFT_ID           (SERVER_URL @"generate_draft_id")
#define API_URL_ACCEPT_INVITE               (SERVER_URL @"accept_invite")

#define API_URL_GET_EVENTS                  (SERVER_URL @"get_events")
#define API_URL_CREATE_EVENTS               (SERVER_URL @"create_event")
#define API_URL_GET_EVENTTYPES              (SERVER_URL @"get_event_types")
#define API_URL_CREATE_EVENTTYPE            (SERVER_URL @"create_event_type")
#define API_URL_GET_MOREINFO                (SERVER_URL @"get_moreinfo")
#define API_URL_CREATE_MOREINFO             (SERVER_URL @"create_moreinfo")
#define API_URL_GET_ALL_DRAFTEES            (SERVER_URL @"get_all_draftees")
#define API_URL_CREATE_DRAFTEE              (SERVER_URL @"create_draftee")
#define API_URL_CREATE_DRAFTEE_DRAFT        (SERVER_URL @"create_draftee_draft")
#define API_URL_GET_DRAFTNAME               (SERVER_URL @"get_draftnames")
#define API_URL_CREATE_DRAFTNAME            (SERVER_URL @"create_draftname")
#define API_URL_GET_ALL_DRAFTERS            (SERVER_URL @"get_all_drafters")
#define API_URL_CREATE_DRAFTER              (SERVER_URL @"create_drafter")
#define API_URL_EDIT_DRAFTERS               (SERVER_URL @"edit_drafters")
#define API_URL_CHECK_EMAIL                 (SERVER_URL @"check_email")
#define API_URL_GET_PICKS                   (SERVER_URL @"get_picks")
#define API_URL_ADD_PICK                    (SERVER_URL @"add_pick")
#define API_URL_DELETE_ITEM                 (SERVER_URL @"delete_item")
#define API_URL_SEND_MESSAGE                (SERVER_URL @"send_message")
#define API_URL_GET_MESSAGES                (SERVER_URL @"get_messages")
#define API_URL_GET_UNREAD_MESSAGES         (SERVER_URL @"get_unread_messages")


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define COLOR_DARK_BROWN            [UIColor colorWithRed:(235.0f / 255.0f) green:(133.0f / 255.0f) blue:(55.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_BLUE        [UIColor colorWithRed:(41.0f / 255.0f) green:(203.0f / 255.0f) blue:(189.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_YELLOW          [UIColor colorWithRed:(255.0f / 255.0f) green:(194.0f / 255.0f) blue:(33.0f / 255.0f) alpha:1]
#define COLOR_DARK_BLUE             [UIColor colorWithRed:(109.0f / 255.0f) green:(166.0f / 255.0f) blue:(209.0f / 255.0f) alpha:1]
#define COLOR_RIGHT_PURPLE          [UIColor colorWithRed:(172.0f / 255.0f) green:(151.0f / 255.0f) blue:(221.0f / 255.0f) alpha:1]
#define COLOR_LIGHT_GREEN           [UIColor colorWithRed:(122.0f / 255.0f) green:(223.0f / 255.0f) blue:(145.0f / 255.0f) alpha:1]
#define COLOR_LIHGT_BROWN           [UIColor colorWithRed:(233.0f / 255.0f) green:(167.0f / 255.0f) blue:(116.0f / 255.0f) alpha:1]
#define COLOR_DARK_GREEN            [UIColor colorWithRed:(142.0f / 255.0f) green:(199.0f / 255.0f) blue:(135.0f / 255.0f) alpha:1]
#define COLOR_DARK_GRAY             [UIColor colorWithRed:(255.0f / 255.0f) green:(255.0f / 255.0f) blue:(135.0f / 255.0f) alpha:0.4]
#define COLOR_BROWN            [UIColor colorWithRed:(231.0f / 255.0f) green:(112.0f / 255.0f) blue:(78.0f / 255.0f) alpha:1]
#define COLOR_GRAY            [UIColor colorWithRed:(103.0f / 255.0f) green:(110.0f / 255.0f) blue:(117.0f / 255.0f) alpha:1]


#define M_PI        3.14159265358979323846264338327950288

#define FONT_BLAMEBOT(s) [UIFont fontWithName:@"Blambot Custom" size:s]
#define FONT_HELVETICA_NEUE_LIGHT(s) [UIFont fontWithName:@"Helvetica Neue Light" size:s]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
