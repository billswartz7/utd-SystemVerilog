#define ANY 257
#define END 258
#define NEWLINE 259
#define SPACE 260
#define TAB 261
#define AT 262
#define COMMA 263
#define HASH 264
#define DOT 265
#define EQ 266
#define COLON 267
#define IDX_PRT_SEL 268
#define SEMICOLON 269
#define OPEN_PAREN 270
#define CLOSE_PAREN 271
#define OPEN_SQ_BRACKET 272
#define CLOSE_SQ_BRACKET 273
#define OPEN_CURLBRACE 274
#define CLOSE_CURLBRACE 275
#define BIN_VALUE 276
#define OCT_VALUE 277
#define HEX_VALUE 278
#define DEC_BASE 279
#define BIN_BASE 280
#define OCT_BASE 281
#define HEX_BASE 282
#define NUM_REAL 283
#define NUM_SIZE 284
#define UNSIGNED_NUMBER 285
#define SYSTEM_ID 286
#define SIMPLE_ID 287
#define ESCAPED_ID 288
#define DEFINE_ID 289
#define ATTRIBUTE_START 290
#define ATTRIBUTE_END 291
#define COMMENT_LINE 292
#define COMMENT_BLOCK 293
#define QSTRING 294
#define STAR 295
#define PLUS 296
#define MINUS 297
#define ASL 298
#define ASR 299
#define LSL 300
#define LSR 301
#define DIV 302
#define POW 303
#define MOD 304
#define GTE 305
#define LTE 306
#define GT 307
#define LT 308
#define L_NEG 309
#define L_AND 310
#define L_OR 311
#define C_EQ 312
#define L_EQ 313
#define C_NEQ 314
#define L_NEQ 315
#define B_NEG 316
#define B_AND 317
#define B_OR 318
#define B_XOR 319
#define B_EQU 320
#define B_NAND 321
#define B_NOR 322
#define TERNARY 323
#define UNARY_OP 324
#define MACRO_TEXT 325
#define MACRO_IDENTIFIER 326
#define KW_ALWAYS 327
#define KW_AND 328
#define KW_ASSIGN 329
#define KW_ASTERISK 330
#define KW_AUTOMATIC 331
#define KW_BEGIN 332
#define KW_BIT 333
#define KW_BUF 334
#define KW_BUFIF0 335
#define KW_BUFIF1 336
#define KW_BYTE 337
#define KW_CASE 338
#define KW_CASEX 339
#define KW_CASEZ 340
#define KW_CELL 341
#define KW_CMOS 342
#define KW_CONFIG 343
#define KW_DEASSIGN 344
#define KW_DEFAULT 345
#define KW_DEFPARAM 346
#define KW_DESIGN 347
#define KW_DISABLE 348
#define KW_DOLLAR_SIGN 349
#define KW_EDGE 350
#define KW_ELSE 351
#define KW_END 352
#define KW_ENDCASE 353
#define KW_ENDCONFIG 354
#define KW_ENDFUNCTION 355
#define KW_ENDGENERATE 356
#define KW_ENDMODULE 357
#define KW_ENDPRIMITIVE 358
#define KW_ENDSPECIFY 359
#define KW_ENDTABLE 360
#define KW_ENDTASK 361
#define KW_EVENT 362
#define KW_FOR 363
#define KW_FORCE 364
#define KW_FOREVER 365
#define KW_FORK 366
#define KW_FUNCTION 367
#define KW_GENERATE 368
#define KW_GENVAR 369
#define KW_HIGHZ0 370
#define KW_HIGHZ1 371
#define KW_IF 372
#define KW_IFNONE 373
#define KW_INCDIR 374
#define KW_INCLUDE 375
#define KW_INITIAL 376
#define KW_INOUT 377
#define KW_INPUT 378
#define KW_INT 379
#define KW_INSTANCE 380
#define KW_INTEGER 381
#define KW_JOIN 382
#define KW_LARGE 383
#define KW_LIBLIST 384
#define KW_LIBRARY 385
#define KW_LOCALPARAM 386
#define KW_LOGIC 387
#define KW_LONGINT 388
#define KW_MACROMODULE 389
#define KW_MEDIUM 390
#define KW_MODULE 391
#define KW_NAND 392
#define KW_NEGEDGE 393
#define KW_NMOS 394
#define KW_NOR 395
#define KW_NOSHOWCANCELLED 396
#define KW_NOT 397
#define KW_NOTIF0 398
#define KW_NOTIF1 399
#define KW_NULL 400
#define KW_OR 401
#define KW_OUTPUT 402
#define KW_PARAMETER 403
#define KW_PATHPULSE 404
#define KW_PMOS 405
#define KW_POSEDGE 406
#define KW_PRIMITIVE 407
#define KW_PULL0 408
#define KW_PULL1 409
#define KW_PULLDOWN 410
#define KW_PULLUP 411
#define KW_PULSESTYLE_ONEVENT 412
#define KW_PULSESTYLE_ONDETECT 413
#define KW_RCMOS 414
#define KW_REAL 415
#define KW_REALTIME 416
#define KW_REG 417
#define KW_RELEASE 418
#define KW_REPEAT 419
#define KW_RNMOS 420
#define KW_ROOT 421
#define KW_RPMOS 422
#define KW_RTRAN 423
#define KW_RTRANIF0 424
#define KW_RTRANIF1 425
#define KW_SCALARED 426
#define KW_SHORTINT 427
#define KW_SHOWCANCELLED 428
#define KW_SIGNED 429
#define KW_SMALL 430
#define KW_SPECIFY 431
#define KW_SPECPARAM 432
#define KW_STRONG0 433
#define KW_STRONG1 434
#define KW_SUPER 435
#define KW_SUPPLY0 436
#define KW_SUPPLY1 437
#define KW_TABLE 438
#define KW_TASK 439
#define KW_THIS 440
#define KW_TIME 441
#define KW_TIMEPRECISION 442
#define KW_TIMEUNIT 443
#define KW_TRAN 444
#define KW_TRANIF0 445
#define KW_TRANIF1 446
#define KW_TRI 447
#define KW_TRI0 448
#define KW_TRI1 449
#define KW_TRIAND 450
#define KW_TRIOR 451
#define KW_TRIREG 452
#define KW_UNSIGNED 453
#define KW_USE 454
#define KW_UWIRE 455
#define KW_VECTORED 456
#define KW_WAIT 457
#define KW_WAND 458
#define KW_WEAK0 459
#define KW_WEAK1 460
#define KW_WHILE 461
#define KW_WIRE 462
#define KW_WOR 463
#define KW_XNOR 464
#define KW_XOR 465
#define KW_REF 466
#define KW_STATIC 467
#define KW_TIMEUNITS 468
#define KW_STEP 469
#define KW_UNIT 470
#define SVID 471
typedef union {
    char        		*string ;
    int				integer ;
    double                      real ;
    SVERILOG_OPERATOR_T 	operator ;
    SVERILOG_PORT_DIR_T		direction ;
    SVER_EXPRPTR 		expr ;
} YYSTYPE;
extern YYSTYPE sverilog_lval;
