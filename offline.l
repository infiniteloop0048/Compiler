%option noyywrap

%{

#include<bits/stdc++.h>
#include<cstdio>
#include<cstdlib>
#include<string>
#include<vector>
#include<iostream>
#include <string.h> 
#include <fstream>
#include <list>


int line_count=1;
int error_count=0;

FILE *logout;
FILE *tokenout;




using namespace std;

#include"offline_in_one_file.cpp"
/*
class SymbolInfo{
public:
	string symbol;
	string type;
	SymbolInfo(){
		symbol="";type="";
	}
	SymbolInfo(string symbol,string type){
		this->symbol=symbol;this->type=type;
	}
};
class ScopeTable{
	vector<SymbolInfo *> syminfo;
	public:
	void insert(SymbolInfo *s){
		syminfo.push_back(s);
	}
	void print(){
		for(int i=0;i<syminfo.size();i++){
			fprintf(logout,"\n%s %s\n",syminfo[i]->symbol.c_str(),syminfo[i]->type.c_str());
		}
	}
};
*/

symbol_table s(10);

%}


WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%



\s*     {;}

{NEWLINE} {line_count++;}

"if"	{
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n\n",line_count,yytext);
		}
"do"	{
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n\n",line_count,yytext);
		}
"int"	{
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n\n",line_count,yytext);
		}
"float"	{
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n\n",line_count,yytext);
		}
"void"	{
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n\n",line_count,yytext);
		}
"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}
"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}
"while"	{
			fprintf(tokenout,"<WHILE>");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n\n",line_count,yytext);
		}
"break"	{
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n\n",line_count,yytext);
		}
"char"	{
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n\n",line_count,yytext);
		}
"double"	{
			fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n\n",line_count,yytext);
		}
"return"	{
			fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n\n",line_count,yytext);
		}

"case"	{
			fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n\n",line_count,yytext);
		}
"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n\n",line_count,yytext);
		}


[0-9]*\.[0-9]*(\.[0-9]*)+   {

                                fprintf(logout, "line no %d, error xD!!!too many decimal points in %s\n\n",line_count, yytext);
                                error_count++;
                         }


[0-9]+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol(string(yytext),"CONST_INT");
                                s.print_currnet_scope_table();
		}



([/][/].*\\\n.*)|([/][/].*)  {fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n\n",line_count,yytext);}


[/][*](.*\n?)*[*][/]         {
                                fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n\n",line_count,yytext);
                                int a=yyleng;
                                for(int i=0;i<a;i++)
				{
				if(yytext[i]=='\n')line_count++;
}


//fprintf(logout, "nooooooo  error in commenting xD \n"); 
}


[/][*]([^/]*\n?)       {
                              fprintf(logout, "line no %d, error!!!!!!!!unfinished comment %s \n\n",line_count, yytext);
                              error_count++;
} 





[_a-zA-Z][_a-zA-Z0-9]*  {
                         printf("hya eikhanei re bhai %s\n", yytext);
                         fprintf(tokenout, "<identifier, %s >", yytext);
                         fprintf(logout,"Line no %d: TOKEN <id> Lexeme %s found\n\n",line_count,yytext);
                         s.insert_symbol(yytext,"IDENTIFIER");
                         s.print_currnet_scope_table();
                        
                        }

[0-9]+[a-zA-Z_][_a-zA-Z0-9]*      {
                         fprintf(logout,"line no %d, error there bro, identifier can't be so %s \n\n",line_count, yytext);
                         //s.insert_symbol("IDENTIFIER", yytext);
                         error_count++;
                        
                        } 

"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
                //s.insert_symbol("ADDOP", string(yytext));
		}

"*" |
"/" |
"%"             {
			fprintf(tokenout,"<MULOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("MULOP", string(yytext));
		}

"++"            {
			fprintf(tokenout,"<INCOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("INCOP", string(yytext));
		}
(<|(<=)|>|(>=)|(==)|(!=))   {
			fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("RELOP", string(yytext));
		}

"="             {
			fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("ASSIGNOP", string(yytext));
		}

"&&"      |
"||"            {
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("LOGICOP", string(yytext));
		}

"|"       |
"&"       |
"^"       |
"<<"      |
">>"            {
			fprintf(tokenout,"<BITOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("BITOP", string(yytext));
		}

"!"             {
			fprintf(tokenout,"<NOT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("NOT", string(yytext));
		}

"("             {
			fprintf(tokenout,"<LPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("LPAREN", string(yytext));
		}

")"             {
			fprintf(tokenout,"<RPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("RPAREN", string(yytext));
		}

"{"             {
			fprintf(tokenout,"<LCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("LCURL", string(yytext));
		}

"}"             {
			fprintf(tokenout,"<RPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("RPAREN", string(yytext));
		}

"["             {
			fprintf(tokenout,"<LTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
                //s.insert_symbol("LTHIRD", string(yytext));
		}

"]"             {
			fprintf(tokenout,"<RTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("RTHIRD", string(yytext));
		}

","             {
			fprintf(tokenout,"<COMMA,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("COMMA", string(yytext));
		}

";"             {
			fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n\n",line_count,yytext);
                //s.insert_symbol("SEMICOLON", string(yytext));
		}



		


(([0-9]*\.?[0-9]+E[+-]?[0-9]+)|([0-9]*\.?[0-9]+))     {
				fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol(string(yytext),"CONST_FLOAT");
                                s.print_currnet_scope_table();
		}

([0-9]*\.?[0-9]*[E][0-9]*\.[0-9]*) {

                                fprintf(logout, "line no %d, error for misleading number %s \n\n",line_count, yytext);
                                error_count++;
}

['][a-zA-Z][']  {
				fprintf(tokenout,"<CONST_CHAR,%c>",yytext[1]);
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %c found\n\n",line_count,yytext[1]);
				//insert in symbol table and print symbol table content(only non empty buckets)
                                string s1(1, yytext[1]);
                                char str[100]="";
                                char ch = yytext[1];
                                str[0]='\'';str[1]=ch;str[2]='\'';str[3]='\0';
				s.insert_symbol(str,"CONST_CHAR");
                                s.print_currnet_scope_table();
		}  

'\\n'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\n');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\n'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}  

'\\t'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\t');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\t'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}  

'\\\\'          {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\\');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\\\'","CONST_CHAR");
                                s.print_currnet_scope_table();
		} 
'\\["]'         {
                                
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\"');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\\"'","CONST_CHAR");
                                s.print_currnet_scope_table();
		} 
 
'\\a'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\a');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\a'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}  

'\\f'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\f');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\f'","CONST_CHAR");
                                s.print_currnet_scope_table();
		} 

'\\r'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\r');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\r'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}  

'\\b'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\b');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\b'","CONST_CHAR");
                                s.print_currnet_scope_table();
		} 

'\\v'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\v');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\v'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}  
'\\0'           {
                                
				fprintf(tokenout,"<CONST_CHAR,%c>",'\0');
				fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count, yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				s.insert_symbol("'\\0'","CONST_CHAR");
                                s.print_currnet_scope_table();
		}   



('\\')|('[a-zA-Z])  {

                                fprintf(logout, "line no %d, error for insuffient character %s \n\n ",line_count, yytext);
                                error_count++;
                }

'..+'  {


                                fprintf(logout, "line no %d, error !!!!!!!!!!! excess number of characters %s \n\n",line_count, yytext);
                                error_count++;
                }
'               {

                                fprintf(logout, "line no %d, undetermined character %s \n\n",line_count, yytext);
                                error_count++;
}

''               {

                                fprintf(logout, "line no %d, empty character constant %s \n\n",line_count, yytext);
                                error_count++;
}



(["].*["])        {
                                
                                int a=yyleng, i, c=0;
                                char str[100] = "";
                                printf("%s\n", str);


				for(i=1;i<a-1;i++)
				{

				if(yytext[i]==92&&i<a-2){

				if(yytext[i+1]=='n'){
				str[c++]=10;i++;
				}

				else if(yytext[i+1]=='t'){
				str[c++]=9;i++;
				}

				else if(yytext[i+1]=='a'){
				str[c++]=7;i++;
				}

				else if(yytext[i+1]=='f'){
				str[c++]=12;i++;
				}

				else if(yytext[i+1]=='r'){
				str[c++]=13;i++;
				}

				else if(yytext[i+1]=='b'){
				str[c++]=8;i++;
				}

				else if(yytext[i+1]=='0'){
				str[c++]=0;i++;
				}

				else if(yytext[i+1]==92){
				str[c++]=92;i++;
				}

				else if(yytext[i+1]=='"'){
				str[c++]=34;i++;
				}

				else{
				str[c++]=92;
				}

				}
				else{

				str[c++]=yytext[i];

				}

				}
				str[c]='\0';

                                
				fprintf(tokenout,"<STRING ,%s >",str);
				fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n\n",line_count,str);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//s.insert_symbol("STRING",string(yytext));
		}



(["].*\\\n(.*\\\n)*(.*["])) {

                int a=yyleng, i, c=0; 
                char str[100] = "";
                printf("%s\n", str);

                /*for(i=1;i<a-1;i++){
                     if(yytext[i]==92&&yytext[i+1]=='\n'){fprintf(tokenout, "dhurrrrrrrrrrr");i++;continue;}
                     fprintf(tokenout, "%c", yytext[i]);}*/


		for(i=1;i<a-1;i++)
		{
                     
                     if(((i+1)<(a-1))&&yytext[i]==92&&yytext[i+1]=='\n'){
                           i=i+1;printf("kno re vai :::");
                     }
                     else{

                           str[c++]=yytext[i];
                           //printf("hya eigula i %c",yytext[i]);
                     }
                     str[c]='\0';
                }
                fprintf(tokenout,"<STRING ,%s >",str);
		fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n\n",line_count,str);
          
		//insert in symbol table and print symbol table content(only non empty buckets)
		//s.insert_symbol("STRING",string(yytext));
                for(i=0;i<a;i++)
                {
                if(yytext[i]=='\n')line_count++;
}

}

["][^"\n]*       {
                fprintf(logout, "line no %d, error for non ending string %s \n\n",line_count, yytext);
                error_count++;
}

["](.*\\\n)+[^"\n]*[\n] {

                int a=yyleng;
                int i;
                
                if(yyleng==2) fprintf(logout, "line no %d, error for non finishing stirng %s \n\n",line_count, yytext);
                else
                fprintf(logout, "line no %d, error in multiline string %d %s \n\n",line_count, yyleng, yytext);
                error_count++;
		for(i=0;i<a;i++)
                {
                if(yytext[i]=='\n')line_count++;
}
}




.               {               //fprintf(logout, "anything except the rules endinfffffffffffffffffg string error xD %s\n", yytext);
}




			

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
        s.insert_a_new_hash();
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
	s.print_currnet_scope_table();
        fprintf(logout, "total number of errors: %d \n\n",error_count);
        fprintf(logout, "total number of lines: %d \n\n", line_count);
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
