/* 
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ OBject CONtrols for CA-Clipper                          13-02-95 บ
บ (c)Copyright A.J.D Business Software 1995             CONTROL.CH บ
บ                                                                  บ
บ Defines for window style control features                        บ
วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ
บ RELEASE INFORMATION                                              บ
บ     03-01-95                    Emulate MSAV interface           บ
บ                                                                  บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Global Include statements                                        บ
ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/

// Control return definitions
#define CHOICE 1
#define ACTION 2
#define MOUSEY 3
#define MOUSEX 4
#define LASTPO 5

// Action definitions
#define PREVFIELD       -1
#define NEXTFIELD       1
#define ENDREAD         0
#define SAVEREAD        2      
#define CHANGE          -2
#define CHANGE_NEXT     3
#define HELP            4
#define ADD_NEW         -3
#define MOUSE_FIELD     -4

// For status function
#define ST_LEN     4       // Length of status array
#define ST_ROW     1       // Status item display row
#define ST_COL     2       // Status item display column
#define ST_COLOR   3       // Status item color
#define ST_CURRENT 4       // Status item current position in aDisplay

// For screen colors
#define BASE_COLOR      "B/RB"
#define BUTTON_ON       "W/RB"
#define BUTTON_OFF      "W/G"
#define CONTROL_COLOR   "B/W+"
#define WIN_COLOR       "B/W,W+/R"
#define TITLE_ON        "W/G"
#define TITLE_OFF       "N/G"
#define SELECT_COLOR    "N/W"
#define BROW_COLOR      "W/RB"
#define LOG_ON          "w/RG" 
#define SHADOW          "N+/N"
#define STAT_COLOR      "W+/B"
#define NOTI_COLOR      "N/RG,W/RB"





