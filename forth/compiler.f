\ Expose LIT into something sane
: LITERAL IMMEDIATE
    ' LIT
    , ,
;

\ [COMPILE] compiles next word even if it is an immediate
: [COMPILE] IMMEDIATE
    WORD FIND
    >CFA ,
;

\ RECURSE allows recursive calls to word being defined
: RECURSE IMMEDIATE
    LATEST @
    >CFA ,
;


