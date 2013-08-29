#include "forth/ironhand.fpp"

65 EMIT
: DIDDLE 0 1 = IF 65 EMIT THEN 5 5 = IF 66 EMIT THEN ;
66 EMIT
.S
-MARK-
DIDDLE


