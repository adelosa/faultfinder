USE vcr 

GO TOP

DO WHILE .NOT. EOF()
        REPLACE CATEGORY WITH 1
        SKIP
ENDDO

set INDEX to vcr
reindex

CLOSE ALL
