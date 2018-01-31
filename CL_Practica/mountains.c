/*
 * A n t l r  T r a n s l a t i o n  H e a d e r
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
 *
 *   antlr -gt mountains.g
 *
 */

#define ANTLR_VERSION	13333
#include "pcctscfg.h"
#include "pccts_stdio.h"

#include <string>
#include <iostream>
#include <cstdlib>
#include <cmath>

#include <map>
#include <vector>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr, int ttype, char *textt);
#define GENAST

#include "ast.h"

#define zzSET_SIZE 8
#include "antlr.h"
#include "tokens.h"
#include "dlgdef.h"
#include "mode.h"

/* MR23 In order to remove calls to PURIFY use the antlr -nopurify option */

#ifndef PCCTS_PURIFY
#define PCCTS_PURIFY(r,s) memset((char *) &(r),'\0',(s));
#endif

#include "ast.c"
zzASTgvars

ANTLR_INFO



//global structures
AST *root;

struct data {
  string type;    //Data type (mountain(s), id)
  vector<int> v;  //Values of the mountain
};
//Memory: programs runs on a 100% GLOBAL scope.
map<string, data> MTNS;

// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  if (type == ID) {
    attr->kind = "id";
    attr->text = text;
  }
  else if (type == NUM) {
    attr->kind = "intconst";
    attr->text = text;
  }
  else {
    attr->kind = text;
    attr->text = "";
  }
}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}

/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
  AST *as = new AST;
  as->kind = "list";
  as->right = NULL;
  as->down = child;
  return as;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a, int n) {
  AST *c = a->down;
  for (int i=0; c!=NULL && i<n; i++) c = c->right;
  return c;
}


/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a, string s) {
  if (a == NULL) return;
  
	cout << a->kind;
  if (a->text != "") cout << "(" << a->text << ")";
  cout << endl;
  
	AST *i = a->down;
  while (i != NULL && i->right != NULL) {
    cout << s+"  \\__";
    ASTPrintIndent(i, s+"  |"+string(i->kind.size()+i->text.size(), ' '));
    i = i->right;
  }
  
	if (i != NULL) {
    cout << s+"  \\__";
    ASTPrintIndent(i, s+"   "+string(i->kind.size()+i->text.size(), ' '));
    i = i->right;
  }
}

/// print AST 
void ASTPrint(AST *a) {
  while (a != NULL) {
    cout << " ";
    ASTPrintIndent(a, "");
    a = a->right;
  }
}

bool digit(string str) {
  for (int i = 0; i != str.size(); ++i) {
    if ('0' > str[i] or str[i] > '9') return false;
  }
  return true;
}

int maxabs (int a, int b) {
  if (abs(a) > abs(b)) {
    return abs(a);
  } 
  else return abs(b);
}



//Get breadth of the subtree at the current node.
int getBreadth(AST *a) {
  if (a == NULL) return 0;
  else return 1+getBreadth(a->right);
}

int eval_Draw(AST *a) {
  //map<string, data>::iterator it = MTNS.find(child(a, 0)->text)
  if (a == NULL) return 0;
  else if (a->kind == "intconst") {
    if (digit(a->text)) return atoi(a->text.c_str());
    //else (*it)->second;
  }
  else if (a->kind == "id") {
    if (MTNS.find(a->text)->second.type != "n") {
      data D = MTNS.find(a->text)->second;
      for (int i = 0; i < D.v.size(); ++i) {
        for (int j = 0; j < D.v[i]; ++j) {
          cout << D.type[i];
        }
      }
    }
    else {
      cout << "ERROR: incompatible draw types! It should be a mountain, not a numeric value." << endl;
    }
  }
  
	else if (a->kind == ";") {
    return eval_Draw(child(a, 0)) + eval_Draw(child(a, 1));
  }
  
	else if (a->kind == "*") {
    int n = eval_Draw(child(a, 0));
    if (eval_Draw(child(a, 1)) == 1) {
      for (int i = 0; i < n; ++i)    cout << '/' ;
    }
    else if (eval_Draw(child(a, 1)) == 0) {
      for (int i = 0; i < n; ++i)    cout << '-';
    }
    else if (eval_Draw(child(a, 1)) == -1) {
      for (int i = 0; i < n; ++i)    cout << '\\' ;
    }
    return n;
  }
  else if (a->kind == "/")    return +1;
  else if (a->kind == "-")    return +0;
  else if (a->kind == "\\")   return -1;
}


string eval_DrawString(AST *a) {
  if (a == NULL) return "";
  else if (a->kind == ";") {
    string s1 = eval_DrawString(child(a, 0)); 
    string s2 = eval_DrawString(child(a, 1));
    return s1 + s2;
  }
  
	else if (a->kind == "*") {
    int n = eval_Draw(child(a, 0));
    string str;
    if (eval_Draw(child(a, 1)) == 1) {
      for (int i = 0; i < n; ++i)    str += '/' ;
    }
    else if (eval_Draw(child(a, 1)) == 0) {
      for (int i = 0; i < n; ++i)    str += '-';
    }
    else if (eval_Draw(child(a, 1)) == -1) {
      for (int i = 0; i < n; ++i)    str += '\\' ;
    }
    return str;
  }
  else if (a->kind == "/")    return "/";
  else if (a->kind == "-")    return "-";
  else if (a->kind == "\\")   return "\\";
}


int getHeight(data D) {
  int maxPos, maxNeg, current;
  maxPos = maxNeg = current = 0;
  for (int i = 0; i < D.type.size(); ++i) {
    if (D.type[i] == '/') 		current += D.v[i];
    else if (D.type[i] == '\\') current -= D.v[i];
    if (current > maxPos) maxPos = current;
    else if (current < maxNeg) maxNeg = current;
  }
  return abs(maxPos - maxNeg);
}

int eval_Height(AST *a) {
  if (a == NULL) return 0;
  else if (a->kind == "intconst") {
    if (digit(a->text)) return atoi(a->text.c_str());
  }
  else if (a->kind == "id") {
    if (MTNS.find(a->text)->second.type != "n") {
      data D = MTNS.find(a->text)->second;
      return getHeight(D);
    }
    else {
      cout << "ERROR: not a mountain! It should not a numeric value." << endl;
    }
  }
  else if (a->kind == ";") {
    if (child(a, 0)->kind == "id") {
      return eval_Height(child(a, 0)) + eval_Height(child(a, 1));
    } 
    else  {
      //Get drawn string if Draw is invoked through a triplet tree
      string str = eval_DrawString(a);
      int pos, neg;
      pos = neg = 0;
      for (int i = 0; i < str.size(); ++i) {
        if (str[i] == '/') 		 pos += 1;
        else if (str[i] == '\\') neg -= 1;
      }
      return maxabs(pos, neg);
    }
  }
  
	else if (a->kind == "*") return eval_Height(child(a, 0)) * eval_Height(child(a, 1));
  else if (a->kind == "/") return 1;
  else if (a->kind == "\\") return -1;
  else if (a->kind == "-") return 0;
}


int evaluate(AST *a) {
  if (a == NULL) return 0;
  else if (a->kind == "intconst") {
    if (digit(a->text)) return atoi(a->text.c_str());
    else MTNS.find(child(a, 0)->text)->second.v[0];
  }
  else if (a->kind == "id") {
    if (MTNS.find(a->text)->second.type != "n") {
      data D = MTNS.find(a->text)->second;
      int pos, neg;
      pos = neg = 0;
      for (int i = 0; i < D.v.size(); ++i) {
        if (D.type[i] == '/') {
          pos += D.v[i];
        }
        else if (D.type[i] == '\\') {
          neg += (-1 * D.v[i]);
        }
      }
      return maxabs(pos, neg);
    }
    else return MTNS.find(a->text)->second.v[0];
  }
  else if (a->kind == ";") {
    return maxabs(  evaluate(child(a, 0)), evaluate(child(a, 1)) );
  }
  else if (a->kind == "*") {
    return evaluate(child(a, 0)) * evaluate(child(a, 1));
  }
  else if (a->kind == "+") {
    return ( evaluate(child(a, 0)) + evaluate(child(a, 1)) );
  }
  
	else if (a->kind == "\\") {
    return 1;
  }   
  else if (a->kind == "/") {
    return -1;
  }    
  else if (a->kind == "-") {
    return 0;
  }
  else if (a->kind == "Match") {
    return ( evaluate(child(a, 0)) == evaluate(child(a, 1)) );
  }
  else if (a->kind == "Height") {
    return eval_Height(child(a, 0));
  }
}

data eval_IS(AST *a) {
  data D;
  D.v = vector<int>();
  
	if (a == NULL) return D;
  else if (a->kind == "intconst") {
    if (digit(a->text)) {
      D.type = 'n';
      D.v.push_back( atoi(a->text.c_str()) );
    }
  }
  else if (a->kind == "id") {
    if (MTNS.find(a->text) != MTNS.end()) {
      data D1 = MTNS.find(a->text)->second;
      if (D.type != "n") {
        D.type += D1.type;
        D.v.insert(
        D.v.end(), D1.v.begin(),  D1.v.end()
        );
      }
      else D.v[0] += D1.v[0];
    } else return D;
  }
  else if (a->kind == ";") {
    D = eval_IS(child(a, 0)); 
    data D1 = eval_IS(child(a, 1));
    D.type += D1.type;
    D.v.insert(D.v.end(), D1.v.begin(), D1.v.end());
  }
  
	else if (a->kind == "*") {
    if (evaluate(child(a, 1)) == -1)    D.type += "/";
    else if (evaluate(child(a, 1)) == 0)    D.type += "-";
    else if (evaluate(child(a, 1)) == 1)    D.type += "\\";       
    D.v.push_back( evaluate(child(a, 0)) );
  }
  
	
  else if (a->kind == "+") {
    int a0, a1;
    a0 = evaluate(child(a, 0));
    a1 = evaluate(child(a, 1));
    D.type = "n";
    D.v.push_back( a0+a1 );
  }
  

  else if (a->kind == "Peak") {
    D.type += "/-\\";
    D.v.push_back(evaluate(child(a, 0)));
    D.v.push_back(evaluate(child(a, 1)));
    D.v.push_back(evaluate(child(a, 2)));   
  }
  else if (a->kind == "Valley") {
    D.type += "\\-/";
    D.v.push_back(evaluate(child(a, 0)));
    D.v.push_back(evaluate(child(a, 1)));
    D.v.push_back(evaluate(child(a, 2)));
  }
  
	return D;
}

//WF = Wellformed
bool CheckWF(string str) {
  if (str.size() % 3 != 0) return false;
  else {
    vector<bool> pos(3);
    for (int i = 0; i != str.size(); ++i) {
      if (i % 3 == 0) {
        pos[0] = pos[1] = pos[2] = false;
      }
      
			if 		(str[i] == '/')  pos[0] = true;
      else if (str[i] == '-')  pos[1] = true;
      else if (str[i] == '\\') pos[2] = true;
      
			if (i % 3 == 2 and not (pos[0] and pos[1] and pos[2])) return false;
    }
  }
  return true;
}

//WF = Wellformed
bool eval_WF(AST* a) {
  string str = MTNS.find(a->text)->second.type;
  return CheckWF(str);
}

bool eval_expr(AST *a) {
  if (a == NULL) return 0;
  else if (a->kind == "intconst") {
    if (digit(a->text)) return atoi(a->text.c_str());
  }
  else if (a->kind == ";" or a->kind == "*") {
    return evaluate(child(a, 0)) and evaluate(child(a, 1))  ;
  }
  
	else if (a->kind == "<")  
  return (evaluate(child(a, 0)) < evaluate(child(a, 1)));
  else if (a->kind == ">")  
  return (evaluate(child(a, 0)) > evaluate(child(a, 1)));
  else if (a->kind == "==" or a->kind == "Match") 
  return (evaluate(child(a, 0)) == evaluate(child(a, 1)));
  
	else if (a->kind == "NOT") 
  return (!eval_expr(child(a, 0)));
  else if (a->kind == "AND") 
  return (eval_expr(child(a, 0)) and eval_expr(child(a, 1)));
  else if (a->kind == "OR")  
  return (eval_expr(child(a, 0)) or eval_expr(child(a, 1)));
  
	else if (a->kind == "Wellformed")  return (eval_WF(child(a, 0)));
  
	return true;	
}

//Complete a (formerly) incomplete mountain
void complete(string key) {
  data D = MTNS[key];
  if (D.type.size() % 3 == 2) {	//One char missing
    D.type += "\\";
    int dummy_val = D.v[D.v.size() - 1];
    D.v.push_back(dummy_val);
  }
  else if (D.type.size() % 3 == 1) { //Two chars missing
    D.type += "-\\";
    int dummy_val = D.v[D.v.size() - 1];
    D.v.push_back(dummy_val);
    D.v.push_back(dummy_val);
  }
  MTNS[key] = D;
}


void execute(AST *a) {
  if (a == NULL) {  return;  } 
  else if (a->kind == "list") { execute(child(a, 0));}
  else if (a->kind == "Draw") {
    eval_Draw(child(a, 0)); cout << endl;
  }
  else if (a->kind == "if") {
    bool expr = true;
    int i = 0;
    while (child(a, i)->kind != "list") {
      expr = eval_expr(child(a, i));
      ++i;
    }
    if (expr) execute(child(a, i));
  }
  else if (a->kind == "while") {
    bool expr = true;
    while (expr) {	
      int i = 0;
      while (child(a, i)->kind != "list") {
        expr = eval_expr(child(a, i));
        ++i;
      }
      if (expr) execute(child(a, i));
    }
    
	}
  else if (a->kind == "Complete") {
    complete(child(a, 0)->text);
  }
  else if (a->kind == "is") {
    MTNS[child(a, 0)->text] = eval_IS( child(a, 1) );
  }
  
	execute(a->right);
}

void printHeights() {
  cout << "********************" << endl;
  for (map<string, data>::iterator it=MTNS.begin(); it != MTNS.end(); ++it){
    if (it->second.type != "n" and CheckWF(it->second.type)) 
    cout << "Height(" << it->first << ") = " << getHeight(it->second) << endl;
  } 
}

int main() {
  root = NULL;
  ANTLR(mountains(&root), stdin);
  ASTPrint(root);
  execute(root);
  printHeights();
}

void
#ifdef __USE_PROTOS
iter(AST**_root)
#else
iter(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(LOOP); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  expr(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(R_PAREN);  zzCONSUME;
  mountains(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(ENDLOOP);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x1);
  }
}

void
#ifdef __USE_PROTOS
condic(AST**_root)
#else
condic(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(COND); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  expr(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(R_PAREN);  zzCONSUME;
  mountains(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(ENDCOND);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x2);
  }
}

void
#ifdef __USE_PROTOS
mountains(AST**_root)
#else
mountains(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    for (;;) {
      if ( !((setwd1[LA(1)]&0x4))) break;
      if ( (LA(1)==ID) ) {
        assign(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {
        if ( (LA(1)==COND) ) {
          condic(zzSTR); zzlink(_root, &_sibling, &_tail);
        }
        else {
          if ( (LA(1)==DRAW) ) {
            draw(zzSTR); zzlink(_root, &_sibling, &_tail);
          }
          else {
            if ( (LA(1)==LOOP) ) {
              iter(zzSTR); zzlink(_root, &_sibling, &_tail);
            }
            else {
              if ( (LA(1)==COMPLETE) ) {
                complete(zzSTR); zzlink(_root, &_sibling, &_tail);
              }
              else {
                if ( (setwd1[LA(1)]&0x8) ) {
                  instr(zzSTR); zzlink(_root, &_sibling, &_tail);
                }
                else break; /* MR6 code for exiting loop "for sure" */
              }
            }
          }
        }
      }
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  (*_root) = createASTlist(_sibling);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x10);
  }
}

void
#ifdef __USE_PROTOS
expr(AST**_root)
#else
expr(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    {
      zzBLOCK(zztasp3);
      zzMake0;
      {
      if ( (LA(1)==NOT) ) {
        zzmatch(NOT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (setwd1[LA(1)]&0x20) ) {
        }
        else {zzFAIL(1,zzerr1,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
      zzEXIT(zztasp3);
      }
    }
    {
      zzBLOCK(zztasp3);
      zzMake0;
      {
      if ( (LA(1)==HEIGHT) ) {
        cmpexpr(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {
        if ( (setwd1[LA(1)]&0x40) ) {
          boolexpr(zzSTR); zzlink(_root, &_sibling, &_tail);
        }
        else {zzFAIL(1,zzerr2,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
      zzEXIT(zztasp3);
      }
    }
    zzEXIT(zztasp2);
    }
  }
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x80) ) {
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==AND) ) {
          zzmatch(AND); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==OR) ) {
            zzmatch(OR); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr3,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==NOT) ) {
          zzmatch(NOT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (setwd2[LA(1)]&0x1) ) {
          }
          else {zzFAIL(1,zzerr4,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==HEIGHT) ) {
          cmpexpr(zzSTR); zzlink(_root, &_sibling, &_tail);
        }
        else {
          if ( (setwd2[LA(1)]&0x2) ) {
            boolexpr(zzSTR); zzlink(_root, &_sibling, &_tail);
          }
          else {zzFAIL(1,zzerr5,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x4);
  }
}

void
#ifdef __USE_PROTOS
cmpexpr(AST**_root)
#else
cmpexpr(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  height(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==LT) ) {
      zzmatch(LT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==GT) ) {
        zzmatch(GT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==EQ) ) {
          zzmatch(EQ); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {zzFAIL(1,zzerr6,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
    }
    zzEXIT(zztasp2);
    }
  }
  zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x8);
  }
}

void
#ifdef __USE_PROTOS
boolexpr(AST**_root)
#else
boolexpr(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==MATCH) ) {
      match(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (LA(1)==WELLFORMED) ) {
        wellformed(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {zzFAIL(1,zzerr7,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x10);
  }
}

void
#ifdef __USE_PROTOS
complete(AST**_root)
#else
complete(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(COMPLETE); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x20);
  }
}

void
#ifdef __USE_PROTOS
wellformed(AST**_root)
#else
wellformed(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(WELLFORMED); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x40);
  }
}

void
#ifdef __USE_PROTOS
draw(AST**_root)
#else
draw(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(DRAW); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    concatenator(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x80);
  }
}

void
#ifdef __USE_PROTOS
height(AST**_root)
#else
height(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(HEIGHT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    mtn(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x1);
  }
}

void
#ifdef __USE_PROTOS
match(AST**_root)
#else
match(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(MATCH); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    mtn(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(COMMA);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    mtn(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x2);
  }
}

void
#ifdef __USE_PROTOS
peak(AST**_root)
#else
peak(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(PEAK); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(COMMA);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(COMMA);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x4);
  }
}

void
#ifdef __USE_PROTOS
valley(AST**_root)
#else
valley(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(VALLEY); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(L_PAREN);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(COMMA);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(COMMA);  zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    arith(zzSTR); zzlink(_root, &_sibling, &_tail);
    zzEXIT(zztasp2);
    }
  }
  zzmatch(R_PAREN);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x8);
  }
}

void
#ifdef __USE_PROTOS
assign(AST**_root)
#else
assign(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(IS); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  concatenator(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x10);
  }
}

void
#ifdef __USE_PROTOS
concatenator(AST**_root)
#else
concatenator(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  mtn(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (LA(1)==CONCAT) ) {
      zzmatch(CONCAT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      mtn(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x20);
  }
}

void
#ifdef __USE_PROTOS
instr(AST**_root)
#else
instr(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==PEAK) ) {
      peak(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (LA(1)==VALLEY) ) {
        valley(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {zzFAIL(1,zzerr8,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x40);
  }
}

void
#ifdef __USE_PROTOS
mtnop(AST**_root)
#else
mtnop(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==DOWNHILL) ) {
      zzmatch(DOWNHILL); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==SUMMIT) ) {
        zzmatch(SUMMIT); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==UPHILL) ) {
          zzmatch(UPHILL); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {zzFAIL(1,zzerr9,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x80);
  }
}

void
#ifdef __USE_PROTOS
mtn(AST**_root)
#else
mtn(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==HASHTAG) ) {
      depref(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (setwd4[LA(1)]&0x1) ) {
        instr(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {
        if ( (setwd4[LA(1)]&0x2) ) {
          arith(zzSTR); zzlink(_root, &_sibling, &_tail);
          {
            zzBLOCK(zztasp3);
            zzMake0;
            {
            if ( (setwd4[LA(1)]&0x4) ) {
            }
            else {
              if ( (LA(1)==UNIT) ) {
                zzmatch(UNIT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
                mtnop(zzSTR); zzlink(_root, &_sibling, &_tail);
              }
              else {zzFAIL(1,zzerr10,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
            }
            zzEXIT(zztasp3);
            }
          }
        }
        else {zzFAIL(1,zzerr11,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x8);
  }
}

void
#ifdef __USE_PROTOS
depref(AST**_root)
#else
depref(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(HASHTAG);  zzCONSUME;
  zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x10);
  }
}

void
#ifdef __USE_PROTOS
arith(AST**_root)
#else
arith(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==NUM) ) {
      zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==ID) ) {
        zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {zzFAIL(1,zzerr12,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (LA(1)==SUM) ) {
      zzmatch(SUM); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==NUM) ) {
          zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==ID) ) {
            zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr13,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x20);
  }
}
