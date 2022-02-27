%{
#include <stdlib.h>
#include <stdio.h>
#include <bits/stdc++.h>
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>

#include "1605048_symboltable.h"
//#include "new.h"

using namespace std;


int line_count=1;
int error_count=0;
string returns="";

int yydebug;
int yyparse(void);
int yylex(void);
bool is_integer(string);
string is_integer_or_float_or_variable(string);
double var[26];

extern FILE *yyin;
FILE *logtxt= fopen("log.txt","w");
FILE *errortxt= fopen("error.txt","w");

vector<string> decla_list;
vector<string> param_list;
vector<string> type_specifier_param_list;
vector<string> arg_list;

symbol_table *s = new symbol_table(10, logtxt);


void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
	return;
}



%}	

//ListNode * listnode = new ListNode();



//%token <dval> INT

%token NEWLINE NUMBER PLUS MINUS SLASH ASTERISK LPAREN RPAREN ID SEMICOLON COMMA LCURL RCURL INT FLOAT VOID LTHIRD CONST_INT RTHIRD IF ELSE ADDOP MULOP NOT CONST_FLOAT INCOP DECOP ASSIGNOP FOR LOGICOP PRINTLN RELOP RETURN WHILE NAME DOUBLE 

%left RELOP LOGICOP BITOP
%left ADDOP
%left MULOP


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%union
{

        //hello *h;
	ListNode * listnode;
	//vector<string> * s ;
        //ListNode * listnode;
	//vector<string>*s;
}

%%


           start : program            { printf("program \n"); }
                 ;
		 program : program unit     
		         {

			         $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"\n"+$<listnode>2->getitem());
	                 fprintf(logtxt, "Line at : %d program : program unit \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                	
		         }    
		       	 | unit               { 

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d program : unit \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                	
		       	 }
		         ;

			unit : var_declaration      { 

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d unit : var_declaration \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                
				 }
				 | func_declaration
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d unit : func_declaration \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                	
				 }
				 | func_definition
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d unit : func_definition \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
				 }
				 ;

func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
                 {
                 	 
/*
                 	 for(int i=0;i<param_list.size();i++)
	                 {
	                 	string ss= param_list[i];
	                 	s->insert_symbol(ss, "ID", type_specifier_param_list[i].c_str());
	                 }
	                 param_list.clear();*/


                     s->insert_symbol($<listnode>2->getitem(), "ID", type_specifier_param_list, $<listnode>1->getitem());
                     
					 s->print_currnet_scope_table();

					 //s->exit_scope();

					 type_specifier_param_list.clear();


                     //s->insert_symbol($<listnode>2->getitem(), "ID");
                     param_list.clear();

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+" "+$<listnode>2->getitem()+"("+$<listnode>4->getitem()+")"+";");
	                 fprintf(logtxt, "Lfunc_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                	
                 }
                 | type_specifier ID LPAREN RPAREN SEMICOLON
                 {
                 	 s->insert_symbol($<listnode>2->getitem(), "ID", type_specifier_param_list, $<listnode>1->getitem());
                 	 type_specifier_param_list.clear();

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+" "+$<listnode>2->getitem()+"("+")"+";");
	                 fprintf(logtxt, "Lfunc_declaration : type_specifier ID LPAREN RPAREN SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
                 }
                 ;

func_definition  : type_specifier ID LPAREN parameter_list RPAREN compound_statement
                 {


                 	 /*for(int i=0;i<param_list.size();i++)
	                 {
	                 	string ss= param_list[i];
	                 	s->insert_symbol(ss, "ID", type_specifier_param_list[i].c_str());
	                 }
	                 param_list.clear();*/

                 	 //fprintf(errortxt, "%d vyrevy %s heehehe %sa\n\n",returns.length(), returns.c_str(), $<listnode>1->getitem().c_str());
                 	 string ss=$<listnode>1->getitem().c_str();

                     if(ss=="void "){
                     	 if(returns.length()!=0){
                     	 	 fprintf(errortxt, "Error at line : %d while returning value\n\n",line_count);
                     	 	 error_count++;
                     	 }
                     }
                     else{
                 	 if(ss!=returns){
                 	 	 if(!returns.length());
                 	 	 else{
                 	 	 fprintf(errortxt, "Error at line : %d while returning value\n\n",line_count);
                 	 	 //fprintf(errortxt, "%s              %s\n\n" ,$<listnode>1->getitem().c_str(), returns.c_str() );
                         error_count++;
                     }
                 	 }
                 	 }

                 	 returns="";

                 	 //fprintf(errortxt, "now the returns is :%s\n\n       ", returns.c_str());


	                 if(s->look_up_from_next_scope($<listnode>2->getitem().c_str())){
	                 	 
                         vector<string> vec=s->get_parameter_list_of_next_scope($<listnode>2->getitem().c_str());
                         int length=vec.size();
                         //fprintf(errortxt, "aschi ki ekhane ?????? %d \n\n",length);

                         if(length!=type_specifier_param_list.size()){
                         	    fprintf(errortxt, "Error at line : %d between declaration and definition\n\n",line_count);
                         	    error_count++;
                         }

                         for(int i=0;i<length;i++)
                         {
                         	if(vec[i]!=type_specifier_param_list[i]){
                         		fprintf(errortxt, "Error at line : %d between declaration and definition\n\n",line_count);
                         		error_count++;
                         		break;
                         	}
                         }

                         if(($<listnode>1->getitem().c_str())!=(s->get_return_type_of_next_scope($<listnode>2->getitem().c_str()))){
                         	 fprintf(errortxt, "Error at line : %d return type between declaration and definition\n\n",line_count);
                         	 error_count++;
                         }
	                 }


                     s->insert_before($<listnode>2->getitem(), "ID", type_specifier_param_list, $<listnode>1->getitem());
                     
					 s->print_all_scope_table();

					 s->exit_scope();

					 type_specifier_param_list.clear();


                 	 //s->insert_symbol($<listnode>2->getitem().c_str(), "ID");

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+$<listnode>2->getitem()+"("+$<listnode>4->getitem()+")"+$<listnode>6->getitem());
	                 fprintf(logtxt, "Line at : %d func_definition  : type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
                 }
                 | type_specifier ID LPAREN RPAREN compound_statement
                 {


                 	 //fprintf(errortxt, "%d vyrevy %s heehehe %sa\n\n",returns.length(), returns.c_str(), $<listnode>1->getitem().c_str());
                 	 string ss=$<listnode>1->getitem().c_str();

                     if(ss=="void "){
                     	 if(returns.length()!=0){
                     	 	 fprintf(errortxt, "Error at line : %d while returning value\n\n",line_count);
                     	 	 error_count++;
                     	 }
                     }
                     else{
                 	 if(ss!=returns){
                 	 	 if(!returns.length());
                 	 	 else{
                 	 	 fprintf(errortxt, "Error at line : %d while returning value\n\n",line_count);
                 	 	 //fprintf(errortxt, "%s              %s\n\n" ,$<listnode>1->getitem().c_str(), returns.c_str() );
                         error_count++;
                     }
                 	 }
                 	 }
                 	 //fprintf(errortxt, "not any para list\n\n" );

                 	 returns="";

                 	 vector<string> v=s->get_parameter_list_of_next_scope($<listnode>2->getitem().c_str());
                 	 if(v.size()!=0){
                 	 	 fprintf(errortxt, "Error at line : %d Mismatch in declaration and definition\n\n", line_count);
                 	 }

                 	 //if((returns.length()==0) && ($<listnode>1->getitem().c_str()=="void "))


                 	 if(s->look_up_from_next_scope($<listnode>2->getitem().c_str())){
                         
                         string s1=$<listnode>1->getitem().c_str();
                         string s2=s->get_return_type_of_next_scope($<listnode>2->getitem().c_str());
                         //fprintf(errortxt, "%s %s\n\n",s1.c_str(), s2.c_str());
                         if(s1!=s2){
                         	 fprintf(errortxt, "Error at line : %d return type between declaration and definition\n\n",line_count);
                         	 error_count++;
                         }
                         /*if(($<listnode>1->getitem().c_str())!=(s->get_return_type_of_next_scope($<listnode>2->getitem().c_str()))){
                         	 fprintf(errortxt, "haha Error at line : %d return type between declaration and definition\n\n",line_count);
                         	 error_count++;
                         }*/
	                 }

	                 type_specifier_param_list.clear();

                 	 //s->insert_symbol($<listnode>2->getitem(), "ID");
                 	 s->insert_before($<listnode>2->getitem(), "ID", type_specifier_param_list, $<listnode>1->getitem());

                 	 s->print_all_scope_table();

                 	 s->exit_scope();

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+$<listnode>2->getitem()+"("+")"+$<listnode>5->getitem());
	                 fprintf(logtxt, "Line at : %d func_definition : type_specifier ID LPAREN RPAREN compound_statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
                 }
                 ;


parameter_list   : parameter_list COMMA type_specifier ID
                 {

                 	 param_list.push_back($<listnode>4->getitem().c_str());
                 	 type_specifier_param_list.push_back($<listnode>3->getitem().c_str());

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+","+$<listnode>3->getitem()+$<listnode>4->getitem());
	                 fprintf(logtxt, "func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                		
                 }
				 | parameter_list COMMA type_specifier
				 | type_specifier ID
				 {

				 	 param_list.push_back($<listnode>2->getitem().c_str());
				 	 type_specifier_param_list.push_back($<listnode>1->getitem().c_str());

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+" "+$<listnode>2->getitem());
	                 fprintf(logtxt, "Line at : %d parameter_list : type_specifier ID \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                	
				 }
				 | type_specifier
				 ;
compound_statement : lcurl statements RCURL
                 {
                 	 //fprintf(logtxt, "Scopetable with id : %d removed", );

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("{\n"+$<listnode>2->getitem()+"\n}");
	                 fprintf(logtxt, "compound_statement : LCURL statements RCURL \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
                 }
                 | LCURL RCURL
                 ;


     lcurl       : LCURL
			     {
			     	 //fprintf(logtxt, "new hash created\n\n");

                     s->insert_a_new_hash();

                     for(int i=0;i<param_list.size();i++)
	                 {
	                 	string ss= param_list[i];
	                 	s->insert_symbol(ss, "ID", type_specifier_param_list[i].c_str());
	                 }
	                 param_list.clear();

	                 //s->insert_before($<listnode>2->getitem(), "ID", type_specifier_param_list, $<listnode>1->getitem());
                     

			     	 //$<listnode>$->setitem("{");
			     } 
                 ;

 var_declaration : type_specifier declaration_list SEMICOLON { 



                     int arr[100];

                     cout<<$<listnode>2->getitem().c_str()<<endl;

                     string s1=$<listnode>2->getitem().c_str();

                     int j=0;

                     for(int i=0;i<s1.size();i++)
                     {
                     	if(s1[i]==',')
                     	{
                     		if(s1[i-1]==']')arr[j++]=1;
                     		else arr[j++]=0;
                     	}
                     }
 	                 

 	                 int i=s1.size();

 	                 if(s1[i-1]==']')arr[j++]=1;
 	                 else arr[j++]=0;

 	                 for(int l=0;l<j;l++)
 	                 {
 	                 	cout<<arr[l]<<" ";
 	                 }

 	                 for(int i=0;i<decla_list.size();i++)
	                 {
	                 	cout<<decla_list[i]<<" "<<endl;

	                 	string ss= decla_list[i];
	                 	if(s->look_up(ss)){
	                 		fprintf(errortxt, "Error at line %d : Multiple Declaration of %s \n\n",line_count, ss.c_str());
	                 		error_count++;
	                 	}
	                 	if(arr[i]==0)
	                 	s->insert_symbol(ss, "ID", $<listnode>1->getitem().c_str());
	                    else{
	                    	s->insert_symbol(ss, "ID", $<listnode>1->getitem()+"a");
	                    }
	                 }
	                 decla_list.clear();
                     
					 //s->print_currnet_scope_table();

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+" "+$<listnode>2->getitem()+";");
	                 fprintf(logtxt, "Line at : %d dvar_declaration : type_specifier declaration_list SEMICOLON  \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());


 	             }
                 ;

type_specifier   : INT    { 
		             $<listnode>$=new ListNode();
	                 fprintf(logtxt, "Line at : %d type_specifier	: INT\n\n", line_count);fprintf(logtxt, "int \n\n");
					 $<listnode>$->setitem("int "); }
				 | FLOAT
				 {
	                 $<listnode>$=new ListNode();
	                 fprintf(logtxt, "Line at :  %d type_specifier	: FLOAT\n\n", line_count);fprintf(logtxt, "float \n\n");
					 $<listnode>$->setitem("float "); 

				 }
				 | VOID
				 {
					 $<listnode>$=new ListNode();
	                 fprintf(logtxt, "Line at : %d type_specifier	: VOID\n\n", line_count);fprintf(logtxt, "void \n\n");
					 $<listnode>$->setitem("void "); 

				 }
				 ;

declaration_list : declaration_list COMMA ID

                 {

                 	 //ListNode * l = new ListNode($<listnode>3->getitem().c_str(), "ID");
                 	 decla_list.push_back($<listnode>3->getitem().c_str());
                 	 

                 	 $<listnode>$=new ListNode();
                 	 $<listnode>$->setitem($<listnode>1->getitem()+","+$<listnode>3->getitem());
                 	 fprintf(logtxt, "Line at : %d declaration_list : declaration_list COMMA ID \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                 }


                 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
                 | ID               { 

                 	 //ListNode * l = new ListNode($<listnode>1->getitem().c_str(), "ID");
                 	 decla_list.push_back($<listnode>1->getitem().c_str());

                 	 //s->insert_symbol($<listnode>1->getitem(), "ID");

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d declaration_list :  ID \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

                 //$<listnode>$->setitem("")


                 }
				 | ID LTHIRD CONST_INT RTHIRD
				 {

				 	 decla_list.push_back($<listnode>1->getitem().c_str());
                 
	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"["+$<listnode>3->getitem()+"]");
	                 fprintf(logtxt, "Line at : %d declaration_list :  ID LTHIRD CONST_INT RTHIRD \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

				 }
				 ;
      statements : statement
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d statements : statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                		
                 }
                 | statements statement
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"  \n"+$<listnode>2->getitem());
	                 fprintf(logtxt, "Line at : %d statements : statements statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                	
                 }
                 ;

	   statement : var_declaration
	             {

		             $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d statement : var_declaration \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
                	
	             }
				 | expression_statement
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d statement : expression_statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
                	
				 }
				 | compound_statement
				 {

				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d statement : compound_statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());

                	
				 }
				 | FOR LPAREN expression_statement expression_statement expression RPAREN statement
				 {
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("for("+$<listnode>3->getitem()+$<listnode>4->getitem()+$<listnode>5->getitem()+")"+$<listnode>7->getitem());
	                 fprintf(logtxt, "Line at : %d statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                	
				 }
				 | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
				 {
				 	 
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("if("+$<listnode>3->getitem()+")"+$<listnode>5->getitem());
	                 fprintf(logtxt, "Line at : %d statement : IF LPAREN expression RPAREN statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

				 }
				 | IF LPAREN expression RPAREN statement ELSE statement
				 {
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("if("+$<listnode>3->getitem()+")"+$<listnode>5->getitem()+"else "+$<listnode>7->getitem());
	                 fprintf(logtxt, "Line at : %d statement : IF LPAREN expression RPAREN statement ELSE statement\n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

				 }

				 | WHILE LPAREN expression RPAREN statement
				 {
				 	 
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("while("+$<listnode>3->getitem()+")"+$<listnode>5->getitem());
	                 fprintf(logtxt, "Line at : %d statement : WHILE LPAREN expression RPAREN statement \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());


				 }
				 | PRINTLN LPAREN ID RPAREN SEMICOLON
				 {

				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("printf("+$<listnode>3->getitem()+");");
	                 fprintf(logtxt, "Line at : %d statement : PRINTLN LPAREN ID RPAREN SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

				 }
				 | RETURN expression SEMICOLON
				 {

				 	 returns = is_integer_or_float_or_variable($<listnode>2->getitem().c_str());

				 	 //fprintf(errortxt, " ekhane dekhi ki print hoy %s\n\n", returns.c_str());
				 	 /*if(returns=="variable"){
				 	 	 returns=s->gettypespec($<listnode>2->getitem().c_str());
				 	 }*/

				 	 returns=$<listnode>2->get_return_type();

				 	 //fprintf(errortxt,"zaha return kore %s\n\n",returns.c_str());

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("return "+$<listnode>2->getitem()+";");
	                 fprintf(logtxt, "Line at : %d statement : return expression SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
                		
				 }
				 ;  
expression_statement : SEMICOLON
                 | expression SEMICOLON
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+";");
	                 fprintf(logtxt, "Line at : %d expression_statement : expression SEMICOLON \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                	
                 }
                 ;    
	    variable : ID
	             {
                     if((s->look_up($<listnode>1->getitem().c_str()))||(s->look_up_from_next_scope($<listnode>1->getitem().c_str())));
	             	 else {
	             	 	 fprintf(errortxt, "Error at line : %d Undeclared Variable %s\n\n",line_count, $<listnode>1->getitem().c_str() );
	             	 	 error_count++;
	             	 }

		             $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d variable : ID \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 string ret;
	                 if(s->look_up($<listnode>1->getitem().c_str())){
	                 	ret=s->gettypespec($<listnode>1->getitem().c_str());
	                 	$<listnode>$->set_return_type(ret);
	                 }
	                 else if(s->look_up_from_next_scope($<listnode>1->getitem().c_str())){
	                 	ret=s->gettypespec_of_next_scope($<listnode>1->getitem().c_str());
	                 	$<listnode>$->set_return_type(ret);

	                 }
                		
	             }
				 | ID LTHIRD expression RTHIRD
				 {
				 	 if((s->look_up($<listnode>1->getitem().c_str()))||(s->look_up_from_next_scope($<listnode>1->getitem().c_str())));
	             	 else {
	             	 	 fprintf(errortxt, "Error at line : %d Undeclared Variable %s\n\n",line_count, $<listnode>1->getitem().c_str() );
	             	 	 error_count++;
	             	 }

				 	 /*if(!is_integer($<listnode>3->getitem().c_str())){
                         fprintf(errortxt, "Error at line : %d Non-integer Array Index \n\n", line_count);
                         error_count++;
				 	 }*/

				 	 if($<listnode>3->get_return_type()!="int "){
				 	 	 fprintf(errortxt, "Error at line : %d Non-integer Array Index \n\n", line_count);
                         error_count++;
				 	 }


					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"["+$<listnode>3->getitem()+"]");
	                 fprintf(logtxt, "Line at : %d variable : ID LTHIRD expression RTHIRD \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());

	                 string ret;
	                 if(s->look_up($<listnode>1->getitem().c_str())){
	                 	ret=s->gettypespec($<listnode>1->getitem().c_str());
	                 	if(ret=="int a"){
	                 	$<listnode>$->set_return_type("int ");
	                 	//fprintf(errortxt, "koi je vul dhortese my bad \n\n");
	                 }
	                    else $<listnode>$->set_return_type("float ");
	                 }
	                 else if(s->look_up_from_next_scope($<listnode>1->getitem().c_str())){

	                 	ret=s->gettypespec($<listnode>1->getitem().c_str());
	                 	if(ret=="int a")
	                 	$<listnode>$->set_return_type("int ");
	                    else $<listnode>$->set_return_type("float ");

	                 }
	                	
				 }
				 ;
      expression : logic_expression
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d expression : logic_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
                		
                 }
	       	     | variable ASSIGNOP logic_expression
	       	     {


/*
	       	     	 if(s->look_up($<listnode>1->getitem().c_str())){
	       	     	 	  string ss=$<listnode>1->getitem().c_str();
	       	     	 	  int length = ss.length();

                          string type_spec = s->gettypespec($<listnode>1->getitem().c_str());
                          if((strcmp(type_spec.c_str(), "int a")==0)&&(ss[length-1]!=']')) {
                          	fprintf(errortxt, "Error at line %d: Type Mismatch\n\n",line_count);
                          	error_count++;
                          }                        

	       	     	 }*/

                     if($<listnode>1->get_return_type()!=""&&$<listnode>3->get_return_type()!=""){
                     if($<listnode>1->get_return_type()=="float ");
                     else if($<listnode>1->get_return_type()!=$<listnode>3->get_return_type()){
                     	fprintf(errortxt, "Error at line  %d : Type Mismatch\n\n", line_count);
                     	error_count++;
                     	//fprintf(errortxt, "%s    %s\n\n",$<listnode>1->get_return_type().c_str(), $<listnode>3->get_return_type().c_str());
                        }
                     }

	       	     	 /*f(s->look_up($<listnode>1->getitem().c_str())){

	       	     	 	string ss=$<listnode>1->getitem().c_str();
	       	     	 	string type_spec = s->gettypespec($<listnode>1->getitem().c_str());

	       	     	 	string what_type=is_integer_or_float_or_variable($<listnode>3->getitem().c_str());




	       	     	 	/*if(what_type=="function"){

                             vector<string> vec;
						     vector<string> vec1;
						     vector<string> vec2;
						     string ss = $<listnode>3->getitem().c_str();
						     string delimiter = "(";

						     size_t pos = 0;
						     string token;
						     while ((pos = ss.find(delimiter)) != string::npos) {
						        token = ss.substr(0, pos);
						        vec.push_back(token);
						        cout << token<<endl;
						        ss.erase(0, pos + delimiter.length());
						     }
						     vec.push_back(ss);
						     cout << ss << endl<<endl;



						     ss = vec[1];
						     delimiter = ")";

						     pos = 0;
						     //string token;
						     while ((pos = ss.find(delimiter)) != string::npos) {
						        token = ss.substr(0, pos);
						        vec1.push_back(token);
						        cout << token<<endl;
						        ss.erase(0, pos + delimiter.length());
						     }
						     vec1.push_back(ss);
						     cout << ss << endl<<endl;

						     ss = vec1[0];
						     delimiter = ",";

						     pos = 0;
						     //string token;
						     while ((pos = ss.find(delimiter)) != string::npos) {
						        token = ss.substr(0, pos);
						        vec2.push_back(token);
						        cout << token<<endl;
						        ss.erase(0, pos + delimiter.length());
						     }
						     vec2.push_back(ss);
						     cout << ss << endl;


						     vector<string> para_list_from_symboltable = s->get_parameter_list_of_next_scope(vec[0]);
						     string return_type = s->get_return_type_of_next_scope(vec[0]);

						     int length=para_list_from_symboltable.size();

						     for(int i=0;i<length;i++)
						     {

		                         string type = s->gettypespec(vec2[i]);
		                         string type2 = para_list_from_symboltable[i];


		                         cout<<"dekha jak first::"<<type<<"abar dekha jak"<<type2<<endl;
		                         if(type2!=type){
		                         	fprintf(errortxt, "Error at line  %d : Type Mismatch\n\n", line_count);
						 	 	    error_count++;
						 	 	    break;
		                         }
		                         else {
		                         	 ;//fprintf(errortxt, "noooooError at line  %d : Type Mismatch\n\n", line_count);
		                         }



						     }
                             string type3 = s->gettypespec($<listnode>1->getitem().c_str());
                             if(return_type!=type3){
                             	 //fprintf(errortxt, "Error at line  %d : return Type Mismatch: %s\n\n", line_count, $<listnode>1->getitem().c_str() );
                             	 error_count++;
                             }

                            
 

	       	     	 	}*/

	       	     	 	/*else if(what_type=="variable"){
	       	     	 		string type_spec2 = s->gettypespec($<listnode>3->getitem().c_str());
	       	     	 		if(type_spec=="int " && type_spec2=="float "){
                     	        //fprintf(errortxt, "Error at line %d : Type Mismatch: %s\n\n",line_count, $<listnode>1->getitem().c_str() );
                     	        error_count++;

	       	     	 		}

	       	     	 	}
	       	     	 	else if(what_type!="others"){
	       	     	 		if(type_spec=="int " && what_type=="float "){
                     	        //fprintf(errortxt, "Error at line %d : Type Mismatch: %s\n\n",line_count, $<listnode>1->getitem().c_str() );
                     	        error_count++;

	       	     	 		}
	       	     	 		else if(type_spec=="int a" && what_type!="int a"){
	       	     	 			//fprintf(errortxt, "Error at line %d : Type Mismatch: %s\n\n",line_count, $<listnode>1->getitem().c_str() );
                     	        error_count++;
	       	     	 		}
	       	     	 	}




	       	     	 }*/
/*
	       	     	 else
	       	     	 {
	       	     	 	 
	       	     	 	 string s1=$<listnode>1->getitem().c_str();
	       	     	 	 int length=s1.length();

	       	     	 	 if(s1[length-1]==']'){
	       	     	 	 	 vector<string> vec;
						     string ss = s1;
						     string delimiter = "[";

						     size_t pos = 0;
						     string token;
						     while ((pos = ss.find(delimiter)) != string::npos) {
						        token = ss.substr(0, pos);
						        vec.push_back(token);
						        cout << token<<endl;
						        ss.erase(0, pos + delimiter.length());
						     }
						     vec.push_back(ss);
						     cout << ss << endl<<endl;

						     if(!s->look_up(vec[0])){
						     	fprintf(errortxt, "Error at Line %d : Undeclared Variable: %s\n\n" ,line_count, vec[0]);
	       	     	 	        error_count++;
						     }

	       	     	 	 }
	       	     	 	 else{
	       	     	 	 fprintf(errortxt, "Error at Line %d : Undeclared Variable: %s\n\n" ,line_count, $<listnode>1->getitem().c_str());
	       	     	 	 error_count++;
	       	     	 	}
	       	     	 }
*/
	       	     	 /*string type_spec = $<listnode>1->getitem().c_str();
	       	     	 int length=type_spec.length();
	       	     	 if(type_spec[length-1]==']');
	       	     	 else{
                     if(!s->look_up($<listnode>1->getitem().c_str())){
                     	error_count++;
                     	fprintf(errortxt, "Error at line %d : Undeclared Variable: %s\n\n",line_count, $<listnode>1->getitem().c_str() );
                     }
                     }

                     if(s->look_up($<listnode>1->getitem().c_str())){
				 	 string type_spec = s->gettypespec($<listnode>1->getitem().c_str());
                     if((strcmp(type_spec.c_str(), "int ")==0)&&(!is_integer($<listnode>3->getitem().c_str())))	{
                     	fprintf(errortxt, "Error at line %d : Type Mismatch\n\n", line_count);
                     	error_count++;
                     }			 	 

				 	}*/


		       	     $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"="+$<listnode>3->getitem());
	                 fprintf(logtxt, "Line at : %d expression : variable ASSIGNOP logic_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                		
	       	     }
		         ;
logic_expression : rel_expression
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d logic_expression : rel_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
                		
                 }
	             | rel_expression LOGICOP rel_expression
	             {

                 	 $<listnode>$=new ListNode();
	                 if(strcmp($<listnode>2->gettype().c_str(), "AND")==0){

		                 $<listnode>$->setitem($<listnode>1->getitem()+"&&"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d logic_expression : rel_expression LOGICOP rel_expression\n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 
	                 }
	                 else
	                 {

		                 $<listnode>$->setitem($<listnode>1->getitem()+"||"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d logic_expression : rel_expression LOGICOP rel_expression\n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 
	                 }
	                 if($<listnode>1->get_return_type()=="void "||$<listnode>3->get_return_type()=="void "){
	                 	 fprintf(errortxt, "Error at line  %d : void funciton in relational expression\n\n", line_count);
                     	 error_count++;
                     	 $<listnode>$->set_return_type("int ");
	                 }
	                 else
	                 $<listnode>$->set_return_type("int ");

	             }
		         ;
  rel_expression : simple_expression
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d rel_expression : simple_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
	                		
                 }
	       	     | simple_expression RELOP simple_expression
	       	     {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"<"+$<listnode>3->getitem());
	                 fprintf(logtxt, "Line at : %d rel_expression : simple_expression RELOP simple_expression\n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 if($<listnode>1->get_return_type()=="void "||$<listnode>3->get_return_type()=="void "){
	                 	 error_count++;
	                 	 fprintf(errortxt, "Error at line %d : returning value from void function", line_count);
	                 	 $<listnode>$->set_return_type("int ");
	                 }
	                 else
	                 $<listnode>$->set_return_type("int ");

	       	     }
		         ;
simple_expression : term
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d simple_expression : term \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
                	
                 }
		         | simple_expression ADDOP term
		         {

			         $<listnode>$=new ListNode();
			         if(strcmp($<listnode>2->gettype().c_str(), "ADDOP")==0)
			         {
		                 $<listnode>$->setitem($<listnode>1->getitem()+"+"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d simple_expression : simple_expression ADDOP term \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 }
	                 else 
	                 {

		                 $<listnode>$->setitem($<listnode>1->getitem()+"-"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d simple_expression : simple_expression ADDOP term \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	               	
	                 }	
	                 if($<listnode>1->get_return_type()=="void "||$<listnode>3->get_return_type()=="void "){
	                 	 error_count++;
	                 	 fprintf(errortxt, "Error at line %d : returning value from void function", line_count);
	                 	 $<listnode>$->set_return_type("void ");
	                 }
	                 else if(($<listnode>1->getitem()=="float ")||($<listnode>3->getitem()=="float ")){
	                 	$<listnode>$->set_return_type("float ");
	                 }
	                 else $<listnode>$->set_return_type("int ");

		         }
		         ;
	        term : unary_expression
	             {

		             $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d term : unary_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
	                		
	             }
				 | term MULOP unary_expression
				 {



					 $<listnode>$=new ListNode();
					 if(strcmp($<listnode>2->gettype().c_str(), "MULOP")==0){
		                 $<listnode>$->setitem($<listnode>1->getitem()+"*"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d term : term MULOP unary_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 }
	                 else
	                 {

	                 	 if($<listnode>1->get_return_type()=="float "||$<listnode>3->get_return_type()=="float "){
	                 	 	fprintf(errortxt, "Error at line %d :Integer operand on modulus operator\n\n",line_count);
					 	 	error_count++;
	                 	 }


					 	 /*if((!is_integer($<listnode>3->getitem().c_str())) || (!is_integer($<listnode>1->getitem().c_str()))) {
					 	 	fprintf(errortxt, "Error at line %d :Integer operand on modulus operator\n\n",line_count);
					 	 	error_count++;
					 	 }*/

		                 $<listnode>$->setitem($<listnode>1->getitem()+"%"+$<listnode>3->getitem());
		                 fprintf(logtxt, "Line at : %d term : MULOP unary_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	               	
	                 }
	                 //fprintf(logtxt, "%s__%s   %s__%s\n\n",$<listnode>1->getitem().c_str(),$<listnode>1->get_return_type().c_str(),$<listnode>3->getitem().c_str() ,$<listnode>3->get_return_type().c_str());
	                 //string s1=$<listnode>1->getitem().c_str();
	                 //string s2=$<listnode>3->getitem().c_str();


	                 if($<listnode>2->gettype()!="MULOP")
	                 {
	                 	 $<listnode>$->set_return_type("int ");
	                 }
	                 else{
	                 if($<listnode>1->get_return_type()=="void "||$<listnode>3->get_return_type()=="void "){
	                 	 error_count++;
	                 	 fprintf(errortxt, "Error at line %d : returning value from void function", line_count);
	                 	 $<listnode>$->set_return_type("void ");
	                 }
	                 else if(($<listnode>1->get_return_type()=="float ")||($<listnode>3->get_return_type()=="float ")){
	                 	$<listnode>$->set_return_type("float ");
	                 }
	                 else $<listnode>$->set_return_type("int ");
	             }

	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );

                	
				 }
				 ;
unary_expression : ADDOP unary_expression
                 {
                 	 $<listnode>$=new ListNode();
                 	 if($<listnode>1->gettype().c_str()=="ADDOP"){
	                 $<listnode>$->setitem("+"+$<listnode>2->getitem());
	                 fprintf(logtxt, "Line at : %d unary_expression : ADDOP unary_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 //$<listnode>$->set_return_type($<listnode>1->get_return_type());
	             }
	                 else{
	                 $<listnode>$->setitem("-"+$<listnode>2->getitem());
	                 fprintf(logtxt, "Line at : %d unary_expression : ADDOP unary_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	             
	                 }
                		
                	 $<listnode>$->set_return_type($<listnode>2->get_return_type());
                 }
	      	     | NOT unary_expression
	      	     {


	      	     	 if($<listnode>2->get_return_type()=="void "){
	      	     	 	 error_count++;
	      	     	 	 fprintf(errortxt, "Error at line %d returning value from void funciton ",line_count );
	      	     	 	 $<listnode>$->set_return_type("void ");
	      	     	 }
	      	     	 $<listnode>$->set_return_type("int ");
	      	     }
				 | factor
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d unary_expression : factor \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
                		
				 }
				 ; 
	      factor : variable
	             {
                 
		             $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d factor : variable \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
                		
	             }
				 | ID LPAREN argument_list RPAREN
				 {


                     if(!s->look_up_from_next_scope($<listnode>1->getitem())){
                     	 fprintf(errortxt, "Error at line : %d wrong id name for funciton call\n\n", line_count);
                     	 error_count++;
                     }
                     else{
                     vector<string > vec1=s->get_parameter_list_of_next_scope($<listnode>1->getitem().c_str());
                     int l=vec1.size();

                     
                     for(int i=0;i<l;i++){
                     	if(arg_list[i]!=vec1[i]){
                     		fprintf(errortxt, "Error at line : %d type Mismatch\n\n", line_count);
                     		error_count++;
                     		break;
                     	}
                     }
                     arg_list.clear();
                 }

				 	/* vector<string> vec;
                     string ss = $<listnode>3->getitem().c_str();
				     string delimiter = ",";

				     size_t pos = 0;
				     string token;
				     while ((pos = ss.find(delimiter)) != string::npos) {
				        token = ss.substr(0, pos);
				        vec.push_back(token);
				        cout << token<<"hoy kisu naki bujhi to na"<<endl;
				        ss.erase(0, pos + delimiter.length());
				     }
				     vec.push_back(ss);
				     cout << ss << endl;


				     vector<string> para_list_from_symboltable = s->get_parameter_list_of_next_scope($<listnode>1->getitem().c_str());

				     int length=para_list_from_symboltable.size();

				     for(int i=0;i<length;i++)
				     {

                         string type = is_integer_or_float_or_variable(vec[i]);
                         string type2 = para_list_from_symboltable[i];

                         if(type=="variable")type=s->gettypespec(vec[0]);

                         if(type!="int "&&type!="float "&&type!="int a")continue;


                         cout<<"dekha jak first::"<<type<<"abar dekha jak"<<type2<<endl;
                         if(type2!=type){
                         	//fprintf(errortxt, "Error at line  %d : Type Mismatch \n\n", line_count);
				 	 	    error_count++;
				 	 	    break;
                         }
                         else {
                         	 ;//fprintf(errortxt, "noooooError at line  %d : Type Mismatch\n\n", line_count);
                         }

				     }
*/


/*
				 	 string ss=$<listnode>3->getitem().c_str();

				 	 string type = s->gettypespec(ss);

				 	 string type2 = s->gettypespec_of_next_scope($<listnode>1->getitem().c_str());

				 	 cout<<"first type: "<<type<<"second type: "<<type2<<endl;

				 	 if(strcmp(type.c_str(), type2.c_str())==
				 	 0);
				 	 else{
				 	 	fprintf(errortxt, "Error at line  %d : Type Mismatch\n\n", line_count);
				 	 	error_count++;
				 	 }*/
				 	

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"("+$<listnode>3->getitem()+")");
	                 fprintf(logtxt, "Line at : %d factor : ID LPAREN argument_list RPAREN \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 if(!s->look_up_from_next_scope($<listnode>1->getitem())){
	                 	$<listnode>$->set_return_type("int ");
	                 }
	                 else{
	                 string ret=s->get_return_type_of_next_scope($<listnode>1->getitem().c_str());
	                 $<listnode>$->set_return_type(ret);
	             }

                	
				 }
				 | LPAREN expression RPAREN
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("("+$<listnode>2->getitem()+")");
	                 fprintf(logtxt, "Line at : %d factor : LPAREN expression RPAREN \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type($<listnode>2->get_return_type());
                	
				 }
				 | CONST_INT
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d factor : CONST_INT \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type("int ");
                		
				 }
				 | CONST_FLOAT
				 {

					 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d factor : CONST_FLOAT \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 $<listnode>$->set_return_type("float ");
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
                	
				 }
				 | variable INCOP
				 {
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"++");
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
				 }
				 | variable DECOP
				 {
				 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+"--");
	                 $<listnode>$->set_return_type($<listnode>1->get_return_type());
				 }
				 ;
   argument_list : argument_list COMMA logic_expression
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem()+","+$<listnode>3->getitem());
	                 fprintf(logtxt, "Line at : %d argument_list : argument_list COMMA logic_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 arg_list.push_back($<listnode>3->get_return_type());
	                 //fprintf(logtxt, "%s\n\n",$<listnode>$->get_return_type().c_str() );
	                	
                 }
                 | logic_expression
                 {

	                 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem($<listnode>1->getitem());
	                 fprintf(logtxt, "Line at : %d argument_list : logic_expression \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 arg_list.push_back($<listnode>1->get_return_type());
                		
                 }
                 | 
                 {
                 	 $<listnode>$=new ListNode();
	                 $<listnode>$->setitem("");
	                 fprintf(logtxt, "Line at : %d argument_list :  \n\n", line_count);fprintf(logtxt, "%s\n\n",$<listnode>$->getitem().c_str());
	                 //arg_list.push_back($<listnode>1->get_return_type());
                		
                 }
                 ;
       






%%


bool is_integer(string a)
{
	int l=a.length();


    for(int i=0;i<l;i++){
    	if((a[i]>='0'&&a[i]<='9')||(a[i]=='.'));
    	else return true;
    }

	for(int i=0;i<l;i++){
		if(a[i]>='0'&&a[i]<='9');
		else return false;
	}
	return true;

}

string is_integer_or_float_or_variable(string a)
{
	int l=a.length();
	int i;

	for(i=0;i<l;i++){
		if(a[i]=='*'||a[i]=='&'||a[i]=='|'||a[i]=='<'||a[i]=='+')return "others";
	}

	for(i=0;i<l;i++){
		if(a[i]>='0'&&a[i]<='9');
		else break;
	}

	if(i==l)return "int ";

    i=0;
    for(i=0;i<l;i++){
    	if((a[i]>='0'&&a[i]<='9')||(a[i]=='.'));
    	else break;
    }

	if(i==l) return "float ";


	i=0;
	for(i=0;i<l;i++){
    	if(a[i]=='(')return "function";
    }

    i=0;
	for(i=0;i<l;i++){
		if(i==0)
    	{
    	 if((a[i]>='a'&&a[i]<='z')||(a[i]>='A'&&a[i]<='Z')||(a[i]=='_'));
         
         else break;
         }
        else if(i!=0){
        	if((a[i]>='a'&&a[i]<='z')||(a[i]>='A'&&a[i]<='Z')||(a[i]=='_')||(a[0]>='0'&&a[i]<='9'));
        	else break;
        }
    }
    if(i==l) return "variable";

    return "others";

}



int main(int argc , char *argv[])
{
	FILE *fp;
	fp = fopen(argv[1] , "r");
	yyin = fp;

    s->insert_a_new_hash();

   	yyparse();

   	s->print_all_scope_table();

   	fprintf(errortxt, "Total errors : %d\n", error_count );
   	fprintf(logtxt, "Total errors : %d\n", error_count);
   	fprintf(logtxt, "Total lines : %d \n", line_count);
	return 0;
}
