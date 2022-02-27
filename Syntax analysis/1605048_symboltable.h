#include <stdlib.h>
#include <stdio.h>
#include <bits/stdc++.h>
#include<iostream>
#include<cstdio>
#include<cstdlib>
#include<cstring>
#include<cmath>

//#include"1605048_symbolinfo_as_linked_list.cpp"
//it's actually the scope_table class
#define ll long long

using namespace std;


//#include<iostream>

//using namespace std;

#define NULL_VALUE -99999
#define SUCCESS_VALUE 99999
//it's actually the symbol_info class
//int cluster[100100];

//FILE * log;

class ListNode
{
private:
    string item;
    string type;
    string type_specifier;
    vector<string> vec;
    string return_type;
public:

    ListNode(){;}
    ListNode(string a, string b){
    item=a;
    type=b;
    }

    ListNode * next;

    void setitem(string a){item=a;}
    void settype(string b){type=b;}
    void settype_specifier(string b){type_specifier=b;}
    void set_parameter_list(vector<string> v){
        vec=v;
    }
    void set_return_type(string a){
        return_type=a;
    }

    string getitem(){return item;}
    string gettype(){return type;}
    string gettype_specifier(){return type_specifier;}
    vector<string> get_parameter_list(){return vec;}
    string get_return_type(){return return_type;}
};


class LinkedList
{

    ListNode * list;
    int length;

public:
    LinkedList()
    {
        list=0; //initially set to NULL
        length=0;
    }

    int getLength()
    {
        return length;
    }

    int getitem(string x)
    {
        ListNode * temp= list;
        int c=0;
        while(temp!=0){
            //cout<<temp->item<<"  ";
            if(temp->getitem()==x) break;
            else c++;

            temp=temp->next;
        }
        return c;
    }

    string getfirst()
    {
        if(list==0) return "jan";
        return list->getitem();
    }

    int insertItem(string item, string type) //insert at the beginning
    {
        ListNode * newNode = new ListNode() ;
        newNode->setitem(item);
        newNode->settype(type);
        newNode->settype_specifier("");

        newNode->next = list ; //point to previous first node
        list = newNode ; //set list to point to newnode as this is now the first node
        length++;

        return SUCCESS_VALUE ;
    }

    int insertItem(string item, string type, string type_specifier) //insert at the beginning
    {
        ListNode * newNode = new ListNode() ;
        newNode->setitem(item);
        newNode->settype(type);
        newNode->settype_specifier(type_specifier);

        newNode->next = list ; //point to previous first node
        list = newNode ; //set list to point to newnode as this is now the first node
        length++;

        return SUCCESS_VALUE ;
    }

///here i am the man
    int insertItem(string item, string type, vector<string> v) //insert at the beginning
    {

        ListNode * newNode = new ListNode() ;
        newNode->setitem(item);
        newNode->settype(type);
        //newNode->settype_specifier(type_specifier);
        newNode->set_parameter_list(v);

        newNode->next = list ; //point to previous first node
        list = newNode ; //set list to point to newnode as this is now the first node
        length++;

        return SUCCESS_VALUE ;
    }


int insertItem(string item, string type, vector<string> v, string return_type) //insert at the beginning
    {

        ListNode * newNode = new ListNode() ;
        newNode->setitem(item);
        newNode->settype(type);
        //newNode->settype_specifier(type_specifier);
        newNode->set_parameter_list(v);
        newNode->set_return_type(return_type);

        newNode->next = list ; //point to previous first node
        list = newNode ; //set list to point to newnode as this is now the first node
        length++;

        return SUCCESS_VALUE ;
    }

    int deleteItem(string item)
    {
        ListNode *temp, *prev ;
        temp = list ; //start at the beginning
        while (temp != 0)
        {

            if (temp->getitem() == item) break ;
            prev = temp;
            temp = temp->next ; //move to next node
        }
        if (temp == 0) return NULL_VALUE ; //item not found to delete
        if (temp == list) //delete the first node
        {
            list = list->next ;
            delete temp;
            length--;
        }
        else
        {
            prev->next = temp->next ;
            delete temp;
            length--;
        }
        return SUCCESS_VALUE ;
    }
    int is_there_or_not(string x){
        int c=0;
        ListNode * temp=list;
        while(temp!=0){
            //cout<<temp->item<<"  ";
            if(temp->getitem()==x) return c;
            temp=temp->next;
            c++;
        }
        return -10;

    }
    string is_there_or_not_type(string x){
        int c=0;
        ListNode * temp=list;
        while(temp!=0){
            //cout<<temp->item<<"  ";
            if(temp->getitem()==x) return temp->gettype_specifier();
            temp=temp->next;
            c++;
        }
        return "";

    }

    vector<string> is_there_or_not_parameter_list(string x){
        int c=0;
        ListNode * temp=list;
        while(temp!=0){
            //cout<<temp->item<<"  ";
            if(temp->getitem()==x) return temp->get_parameter_list();
            temp=temp->next;
            c++;
        }
        vector<string> v;
        return v;

    }

    string is_there_or_not_return_type(string x){
        int c=0;
        ListNode * temp=list;
        while(temp!=0){
            //cout<<temp->item<<"  ";
            if(temp->getitem()==x) return temp->get_return_type();
            temp=temp->next;
            c++;
        }
        return "";

    }


    void printList(FILE *logout3)
    {
        ListNode * temp= list;
        while(temp!=0){fprintf(logout3," < %s %s > -->", temp->getitem().c_str(), temp->gettype().c_str());
            
            cout<<"<"<<temp->getitem().c_str()<<"  "<<temp->gettype().c_str()<<">"<<" --> ";
            temp=temp->next;
        }
        fprintf(logout3, "\n");
        cout<<endl;
        //cout<<length<<endl;
    }

    //------------write code for the functions below-----------




    ~LinkedList()
    {
        ListNode *n,*prev;
        ListNode *temp=list;
        while(temp!=NULL){
            prev=temp;
            temp=temp->next;
            delete(prev);
        }
        //write your codes here
    }

};




class Hash
{
    public:
    int position;

    ll BUCKET;    // No. of buckets

    LinkedList *table;

    Hash * next;

    //LinkedList *table2;
    //list<int> *table;
public:
    Hash(ll b)
    {
    this->BUCKET = b;
    table = new LinkedList[BUCKET+1];
//    table2= new LinkedList[BUCKET+1];
    }

    void insertItem(string key, string type)
    {
        ll index = hashFunction(key);
        //cout<<index<<endl;
        table[index].insertItem(key, type);

        cout<<"Inserted in ScopeTable# "<<position+1<<" at position "<<index<<","<<table[index].getLength()-1<<endl;

    }

    void insertItem(string key, string type, string type_specifier)
    {
        ll index = hashFunction(key);
        //cout<<index<<endl;
        table[index].insertItem(key, type, type_specifier);

        cout<<"Inserted in ScopeTable# "<<position+1<<" at position "<<index<<","<<table[index].getLength()-1<<endl;

    }

    void insertItem(string key, string type, vector<string> v)
    {
        ll index = hashFunction(key);
        //cout<<index<<endl;
        table[index].insertItem(key, type, v);

        cout<<"Inserted in ScopeTable# "<<position+1<<" at position "<<index<<","<<table[index].getLength()-1<<endl;

    }

    void insertItem(string key, string type, vector<string> v, string return_type)
    {
        ll index = hashFunction(key);
        //cout<<index<<endl;
        table[index].insertItem(key, type, v, return_type);

        cout<<"Inserted in ScopeTable# "<<position+1<<" at position "<<index<<","<<table[index].getLength()-1<<endl;

    }

    void deleteItem(string key)
    {
        int index = hashFunction(key);

        int a;
        a=table[index].is_there_or_not(key);
        if(a==-10){
        cout<<"Not Found"<<endl;
    }
  else table[index].deleteItem(key), cout<<"Deleted entry at  "<<index<<","<<a<<"  from current scopetable #"<<position+1<<endl;

    }
    int power(int a, int i)
    {
        int s=1;
        while(i--)
        {
            s=(s%BUCKET*a%BUCKET)%BUCKET;
        }
        return s;
    }

    bool finding(string key)
    {
        int index=hashFunction(key);
        int a=table[index].is_there_or_not(key);
        if(a==-10){cout<<"Not Found"<<endl;return false;}
        else {
            cout<<"Found in ScopeTable# "<<position+1<<" at position "<<index<<","<<a<<endl;
            return true;
        }
    }

    string finding_for_type(string key)
    {
        int index=hashFunction(key);
        string aa="";
        aa=table[index].is_there_or_not_type(key);
        return aa;
    }


    vector<string> finding_for_parameter_list(string key)
    {
        int index=hashFunction(key);
        string aa="";
        vector<string> v=table[index].is_there_or_not_parameter_list(key);
        return v;
    }

    string finding_for_return_type(string key)
    {
        int index=hashFunction(key);
        string aa="";
        string ss=table[index].is_there_or_not_return_type(key);
        return ss;
    }
    
    bool finding1(string key)
    {
        int index=hashFunction(key);
        int a=table[index].is_there_or_not(key);
        if(a==-10){return false;}
        else {
            return true;
        }
    }

    ll hashFunction(string x) {
        ll l=x.length(),s=0, a, b, rr;
        for(ll i=0;i<l;i++)
        {
        a=(ll)x[i];
        b=power(1000000009,i);

        rr=(a%BUCKET*b%BUCKET)%BUCKET;

        s=s+rr;
        }

        return s%BUCKET;
    }

    ll hashFunction2(string x) {
        ll l=x.length(),s=0, a, b, rr;
        for(ll i=0;i<l;i++)
        {
        a=(ll)(x[i]);
        b=power(1000000007,i);

        rr=(a%BUCKET*b%BUCKET)%BUCKET;

        s=s+rr;
        }
        return s%BUCKET;
    }




    void displayHash(FILE *logout2) {

      //cout<<"second=="<<endl;
      for (ll i = 0; i < BUCKET; i++) {
        fprintf(logout2, " %d", i);
        cout<<i<<":";
        table[i].printList(logout2);
      }
    }
    //void insertItem2(string key);
};




//void Hash::insertItem2(string key)





class symbol_table{
    int serial;
    int bucket;
    int length;
    FILE *logout;
    //FILE * logg;
public:
    Hash * list1;

    symbol_table(int b, FILE * a){
        list1=0;
        serial=0;
        length=0;
        bucket=b;
        logout=a;
        //logg=a;
 
    }

    string gettypespec(string i)
    {
        
        string a=list1->finding_for_type(i);
        return a;
    }

    string gettypespec_of_next_scope(string i)
    {
        Hash * temp=list1;
        temp=temp->next;
        string a=temp->finding_for_type(i);
        return a;
    }

    vector<string> get_parameter_list_of_next_scope(string i)
    {
        Hash * temp=list1;
        temp=temp->next;
        vector<string> v=temp->finding_for_parameter_list(i);
        return v;
    }


    string get_return_type_of_next_scope(string i)
    {
        Hash * temp=list1;
        temp=temp->next;
        string v=temp->finding_for_return_type(i);
        return v;
    }


    void insert_before(string a, string b)
    {
        Hash * temp=list1;
        temp=temp->next;
        if(!temp->finding1(a))
        temp->insertItem(a, b);
    }

    void insert_before(string a, string b, string c)
    {
        Hash * temp=list1;
        temp=temp->next;
        if(!temp->finding1(a))
        temp->insertItem(a, b, c);
    }

    int insert_before(string a, string b, vector<string> v){

    //fprintf(logtxt,"valoi na");

        Hash * temp=list1;
        temp=temp->next;
        if(!temp->finding1(a))
        temp->insertItem(a, b, v);

    }

    int insert_before(string a, string b, vector<string> v, string return_type){

    //fprintf(logtxt,"valoi na");

        Hash * temp=list1;
        temp=temp->next;
        if(!temp->finding1(a))
        temp->insertItem(a, b, v, return_type);

    }

    int getlength(){return length;}

    int insert_a_new_hash(){

        cout<<"new hash created"<<endl;

        fprintf(logout, "New Scopetable with id : %d created\n\n", length+1);

        Hash *h=new Hash(bucket);

        h->position=length+1;
        h->next=list1;

        list1=h;
        //h->position=serial;
        if(length==0);
        else
            cout<<"Scope table with  id "<<list1->position<<" is created"<<endl;
            serial++;
            length++;
            return 1;

    }

    bool checking_all(string a)
    {
        Hash * temp=list1;
        while(temp!=0){
            bool b=temp->finding1(a);
            if(b){
                return true;
            }
            temp=temp->next;
        }

        return false;
    }

    int insert_symbol(string a, string b){

    //fprintf(logtxt,"valoi na");

        if(!list1->finding1(a))
        list1->insertItem(a, b);
        else cout<<"<"<<a<<","<<b<<">"<<"already exist in current scope table"<<endl;

    }

    int insert_symbol(string a, string b, string c){

    //fprintf(logtxt,"valoi na");

        if(!list1->finding1(a))
        list1->insertItem(a, b, c);
        else cout<<"<"<<a<<","<<b<<">"<<"already exist in current scope table"<<endl;

    }

    int insert_symbol(string a, string b, vector<string> v, string c){

    //fprintf(logtxt,"valoi na");

        if(!list1->finding1(a))
        list1->insertItem(a, b, v, c);
        else cout<<"<"<<a<<","<<b<<">"<<"already exist in current scope table"<<endl;

    }

    

    void delete_key(string key){
        list1->deleteItem(key);
    }

    bool look_up(string key){
        return (list1->finding(key));
    }

    bool look_up_from_next_scope(string key){
        Hash * temp=list1;
        temp=temp->next;
        return (temp->finding(key));
    }


    void print_currnet_scope_table(){
        int c=length;
        fprintf(logout, "ScopeTable # %d \n", length);
        cout<<"ScopeTable  # "<<c<<endl;
        list1->displayHash(logout);
    }

    void print_all_scope_table(){
    Hash * temp=list1;
    int c=length;
        while(temp!=0){
            fprintf(logout, "ScopeTable # %d\n", temp->position);
            cout<<"ScopeTable  # "<<temp->position<<endl;
            temp->displayHash(logout);
            cout<<endl<<endl;
            temp=temp->next;
            c--;
        }
    }

    void exit_scope(){
    
        cout<<"exitting from the table"<<endl;
        fprintf(logout, "Scopetable with id %d removed\n\n", length);
        //length--;
        //cout<<"Scope table with  id "<<list1->position+1<<" is removed"<<endl;
        //Hash *temp=list1;
        
        list1=list1->next;
        //delete(temp);
    }





};

/*
int main()
{
       int bucket;
       ifstream inFile;
       inFile.open("input.txt");
       inFile>>bucket;
       symbol_table s(bucket);
       s.insert_a_new_hash();

       string str, a, b;
       while(1){
       inFile>>str;
       if(str=="I"){
        inFile>>a>>b;
        s.insert_symbol(a, b);
       }
       else if(str=="L"){
        inFile>>a;
        s.look_up(a);
       }
       else if(str=="P"){
        inFile>>a;
        if(a=="A")s.print_all_scope_table();
        else s.print_currnet_scope_table();
       }
       else if(str=="D"){
        inFile>>a;
        s.delete_key(a);
       }
       else if(str=="S"){
        s.insert_a_new_hash();
       }
       else if(str=="E"){
        s.exit_scope();
       }
       else if(str=="close"){
        inFile.close();
        break;
       }

       }


  return 0;
}


*/

