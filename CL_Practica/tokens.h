#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: mountains.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define DRAW 2
#define HEIGHT 3
#define MATCH 4
#define PEAK 5
#define VALLEY 6
#define COMPLETE 7
#define WELLFORMED 8
#define LOOP 9
#define ENDLOOP 10
#define COND 11
#define ENDCOND 12
#define L_PAREN 13
#define R_PAREN 14
#define COMMA 15
#define CONCAT 16
#define UPHILL 17
#define SUMMIT 18
#define DOWNHILL 19
#define UNIT 20
#define LT 21
#define GT 22
#define EQ 23
#define AND 24
#define OR 25
#define NOT 26
#define SUM 27
#define HASHTAG 28
#define IS 29
#define ID 30
#define NUM 31
#define SPACE 32

#ifdef __USE_PROTOS
void iter(AST**_root);
#else
extern void iter();
#endif

#ifdef __USE_PROTOS
void condic(AST**_root);
#else
extern void condic();
#endif

#ifdef __USE_PROTOS
void mountains(AST**_root);
#else
extern void mountains();
#endif

#ifdef __USE_PROTOS
void expr(AST**_root);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void cmpexpr(AST**_root);
#else
extern void cmpexpr();
#endif

#ifdef __USE_PROTOS
void boolexpr(AST**_root);
#else
extern void boolexpr();
#endif

#ifdef __USE_PROTOS
void complete(AST**_root);
#else
extern void complete();
#endif

#ifdef __USE_PROTOS
void wellformed(AST**_root);
#else
extern void wellformed();
#endif

#ifdef __USE_PROTOS
void draw(AST**_root);
#else
extern void draw();
#endif

#ifdef __USE_PROTOS
void height(AST**_root);
#else
extern void height();
#endif

#ifdef __USE_PROTOS
void match(AST**_root);
#else
extern void match();
#endif

#ifdef __USE_PROTOS
void peak(AST**_root);
#else
extern void peak();
#endif

#ifdef __USE_PROTOS
void valley(AST**_root);
#else
extern void valley();
#endif

#ifdef __USE_PROTOS
void assign(AST**_root);
#else
extern void assign();
#endif

#ifdef __USE_PROTOS
void concatenator(AST**_root);
#else
extern void concatenator();
#endif

#ifdef __USE_PROTOS
void instr(AST**_root);
#else
extern void instr();
#endif

#ifdef __USE_PROTOS
void mtnop(AST**_root);
#else
extern void mtnop();
#endif

#ifdef __USE_PROTOS
void mtn(AST**_root);
#else
extern void mtn();
#endif

#ifdef __USE_PROTOS
void depref(AST**_root);
#else
extern void depref();
#endif

#ifdef __USE_PROTOS
void arith(AST**_root);
#else
extern void arith();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType zzerr3[];
extern SetWordType setwd1[];
extern SetWordType zzerr4[];
extern SetWordType zzerr5[];
extern SetWordType zzerr6[];
extern SetWordType zzerr7[];
extern SetWordType setwd2[];
extern SetWordType zzerr8[];
extern SetWordType zzerr9[];
extern SetWordType setwd3[];
extern SetWordType zzerr10[];
extern SetWordType zzerr11[];
extern SetWordType zzerr12[];
extern SetWordType zzerr13[];
extern SetWordType setwd4[];
