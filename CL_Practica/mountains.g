#header
<<
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
>>

<<


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
>>


#lexclass START

#token DRAW "Draw"
#token HEIGHT "Height"
#token MATCH "Match"
#token PEAK "Peak"
#token VALLEY "Valley"
#token COMPLETE "Complete"
#token WELLFORMED "Wellformed"

#token LOOP "\while"
#token ENDLOOP "endwhile"

#token COND "\if"
#token ENDCOND "endif"


#token L_PAREN "\("
#token R_PAREN "\)"
#token COMMA "\,"
#token CONCAT "\;"

#token UPHILL "\/"
#token SUMMIT "\-"
#token DOWNHILL "\\"
#token UNIT "\*"


#token LT "\<"
#token GT "\>"
#token EQ "\=="

#token AND "AND"
#token OR  "OR"
#token NOT "NOT"

#token SUM "\+"

#token HASHTAG "\#"
#token IS "is"
#token ID "[a-zA-Z][0-9]*"
#token NUM "[0-9]+"

#token SPACE "[\ \t \n]" << zzskip(); >>

/*
 GRAMMAR PENDING TASKS:
ALL DONE! NEVER EVER BITCH
 */

iter: LOOP^ L_PAREN! expr R_PAREN! mountains ENDLOOP!;
condic: COND^ L_PAREN! expr R_PAREN! mountains  ENDCOND!;

mountains: (assign | condic | draw | iter | complete | instr )* << #0 = createASTlist(_sibling); >>;

// Expressions := Boolean expr + Comparison expr
expr: ((NOT^|) (cmpexpr |  boolexpr))  (( AND^ |OR^ )(NOT^|) ( cmpexpr |  boolexpr ))* ;

cmpexpr: height (LT^ | GT^ | EQ^ ) NUM;
boolexpr: (match|wellformed);

//Functions
complete: COMPLETE^ L_PAREN! (ID) R_PAREN!;
wellformed: WELLFORMED^ L_PAREN! (ID) R_PAREN! ;
draw: DRAW^ L_PAREN! (concatenator) R_PAREN!;
height: HEIGHT^ L_PAREN! (mtn) R_PAREN!;
match:  MATCH^ L_PAREN! (mtn) COMMA! (mtn) R_PAREN!;
peak:   PEAK^ L_PAREN! (arith) COMMA! (arith) COMMA! (arith) R_PAREN!;
valley: VALLEY^ L_PAREN! (arith) COMMA! (arith) COMMA! (arith) R_PAREN!;


assign: ID IS^ concatenator;
concatenator: mtn (CONCAT^ mtn)* ;
instr: (peak | valley) ;
mtnop: (DOWNHILL|SUMMIT|UPHILL);
mtn: (  depref | instr | arith( | UNIT^ mtnop));
depref: HASHTAG! ID; //dependency reference

arith: (NUM|ID) (SUM^ (NUM|ID))* ;
