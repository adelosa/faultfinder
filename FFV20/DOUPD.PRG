? "Opening Database for TV records"
USE TV.USR
? "Appending records"
APPEND FOR UPPER(TRIM(FTYPE)) = "TV" FROM CUSTOM.DAT 
? "Indexing"
INDEX ON MAC_CODE + MODEL + STR(CATEGORY) TO TV.USX
GOTO TOP
? "Replacing categories"
REPLACE CATEGORY WITH 9 WHILE !EOF()
? "Opening Database for VCR records"
USE VCR.USR
? "Appending records"
APPEND FOR UPPER(TRIM(FTYPE)) = "VCR" FROM CUSTOM.DAT 
? "Indexing"
INDEX ON MAC_CODE + MODEL + STR(CATEGORY) TO VCR.USX
? "Replacing categories"
REPLACE CATEGORY WITH 9 WHILE !EOF()
? "DOUPD done!"
