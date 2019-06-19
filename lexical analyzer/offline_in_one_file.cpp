/*#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<bits/stdc++.h>

using namespace std;


//it's actually the symbol_info class
int cluster[100100];*/


#define NULL_VALUE -99999
#define SUCCESS_VALUE 99999

class ListNode
{
private:
    string item;
    string type;
public:

    ListNode * next;

    void setitem(string a){item=a;}
    void settype(string b){type=b;}

    string getitem(){return item;}
    string gettype(){return type;}
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


/*
    ListNode * searchItem(int item)
    {
        ListNode * temp ;
        temp = list ; //start at the beginning
        while (temp != 0)
        {
            if (temp->item == item) return temp ;
            temp = temp->next ; //move to next node
        }
        return 0 ; //0 means invalid pointer in C, also called NULL value in C
    }
*/
    void printList()
    {
        ListNode * temp= list;
        while(temp!=0){

            //myfile<<"<"<<temp->getitem()<<"  "<<temp->gettype()<<">"<<" --> ";

            char ch[100]="", ch1[100]="";
            string a, b;
            a=temp->getitem();
            b=temp->gettype();
            int c=0;
            for(int i=0;i<a.length();i++){

            ch[c++]=a[i];

            }
            ch[c]='\0';


            c=0;
            for(int i=0;i<b.length();i++){

            ch1[c++]=b[i];

            }
            ch1[c]='\0';
            fprintf(logout, "< %s  %s -->>",ch, ch1);


            cout<<"<"<<temp->getitem()<<"  "<<temp->gettype()<<">"<<" --> ";
            temp=temp->next;
        }
        //myfile<<endl;
        fprintf(logout, "\n");
        cout<<endl;
        //cout<<length<<endl;
    }

    //------------write code for the functions below-----------

  /*  int insertLast(int item)
    {
         ListNode *n=new ListNode();
         ListNode *temp,*prev;
         temp=list;
         if(list==0){
            n->item=item;
            n->next=0;
            list=n;
            length++;
            return 1;

         }
         while(temp!=0){
            prev=temp;
            temp=temp->next;
         }
         //cout<<temp->item<<endl;
         n->item=item;
         n->next=0;
         prev->next=n;
         length++;
         return 1;
        //write your codes here
    }
*//*
    int insertAfter(int oldItem, int newItem)
    {

        ListNode *n= new ListNode();
        ListNode *temp, *prev;
        temp=list;
        while(temp!=0){
            if(temp->item==oldItem){
                break;
            }
            prev=temp;
            temp=temp->next;
        }
        n->next=temp->next;
        n->item=newItem;
        temp->next=n;
        length++;

        return 1;

        //write your codes here
    }

    ListNode * getItemAt(int pos)
    {
        int c=0;
        ListNode *n;
        ListNode *temp=list;
        while(temp!=NULL){
            c++;
            if(c==pos){
                break;
            }
            temp=temp->next;
        }
        return temp;

         //write your codes here

    }
*/

//    int deleteFirst()
//    {
//        ListNode *temp=list;
//        list=list->next;
//        delete(temp);
//        length--;
//        return 1;
//
//        //write your codes here
//    }



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

//
//int main()
//{
//    LinkedList l1;
//    l1.insertItem("hey bra");
//    l1.insertItem("kikhobor");
//    l1.printList();
//
////    ListNode ln;
////    ln.item="shaon";
////    ln.next=nullptr;
////
////    cout<<ln.item<<endl;
//
//
//}
/*
int main(void)
{


    LinkedList l1;
    l1.insertItem("1","2");
    l1.printList();



}
*/

//    while(1)
//    {
//        printf("1. Insert new item. 2. Delete item. 3. Search item. \n");
//        printf("4. (Add from homework). 5. Print. 6. insertlast. 7.insertafter.  10.exit\n");
//        printf("8. getitemat.  9.deletefirst\n");
//
//        int ch;
//        scanf("%d",&ch);
//        if(ch==1)
//        {
//            int item;
//            scanf("%d", &item);
//            ll.insertItem(item);
//        }
//        else if(ch==2)
//        {
//            int item;
//            scanf("%d", &item);
//            ll.deleteItem(item);
//        }
//        else if(ch==3)
//        {
//            int item;
//            scanf("%d", &item);
//            ListNode * res = ll.searchItem(item);
//            if(res!=0) printf("Found.\n");
//            else printf("Not found.\n");
//        }
//        else if(ch==5)
//        {
//            ll.printList();
//        }
//        else if(ch==7)
//        {
//            int a, b;
//            cin>>a>>b;
//            ll.insertAfter(a, b);
//        }
//        else if(ch==6)
//        {
//            int  a;
//            cin>>a;
//            ll.insertLast(a);
//        }
//        else if(ch==8)
//        {
//            int pos;
//            cin>>pos;
//            cout<<ll.getItemAt(pos)->item<<endl;
//        }
//        else if(ch==9)
//        {
//            ll.deleteFirst();
//        }
//        else if(ch==10)
//        {
//        break;
//        }
//
//    }




















/////////////////////////////////////////////////////////////
//////////////////////////////////////////////
////////////////////////////////////////////////////////////
//#include <fstream>
//#include<iostream>
//#include<bits/stdc++.h>
//#include <list>
//#include"1605048_symbolinfo_as_linked_list.cpp"
//it's actually the scope_table class
#define ll long long

using namespace std;

//#define ll long long

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
    Hash(ll V);
    void insertItem(string x, string y);

    void deleteItem(string key);
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



    void displayHash();
    void insertItem2(string key);
};

Hash::Hash(ll b)
{
    this->BUCKET = b;
    table = new LinkedList[BUCKET+1];
//    table2= new LinkedList[BUCKET+1];


}

void Hash::insertItem(string key, string type)
{
    ll index = hashFunction(key);
    //cout<<index<<endl;
    table[index].insertItem(key, type);

    cout<<"Inserted in ScopeTable# "<<position+1<<" at position "<<index<<","<<table[index].getLength()-1<<endl;
//    ll index2=hashFunction2(key);
//    //cout<<"index222===->"<<index2<<endl;
//    table2[index2].insertItem(key);

}
//void Hash::insertItem2(string key)


void Hash::deleteItem(string key)
{
  int index = hashFunction(key);

  int a;
  a=table[index].is_there_or_not(key);
  if(a==-10){
    cout<<"Not Found"<<endl;
  }
  else table[index].deleteItem(key), cout<<"Deleted entry at  "<<index<<","<<a<<"  from current scopetable #"<<position+1<<endl;

}

void Hash::displayHash() {

  //cout<<"second=="<<endl;
  for (int i = 0; i < BUCKET; i++) {

    if(table[i].getLength()==0)continue;
    fprintf(logout, "%d :", i);
    cout<<i<<":";
    table[i].printList();
  }
  fprintf(logout, "\n");
}

class symbol_table{
    int serial;
    int bucket;
    int length;
public:
    Hash * list1;

    symbol_table(int b){
    list1=0;
    serial=0;
    length=0;
    bucket=b;
    }

    int insert_a_new_hash(){

    Hash *h=new Hash(bucket);

    h->position=serial;
    h->next=list1;

    list1=h;
    h->position=serial;
    if(length==0);
    else
    cout<<"Scope table with  id "<<list1->position+1<<" is created"<<endl;
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

    if(!list1->finding1(a))
    list1->insertItem(a, b);
    else cout<<"<"<<a<<","<<b<<">"<<"already exist in current scope table"<<endl;

    return 1;

    }

    void delete_key(string key){
    list1->deleteItem(key);
    }

    void look_up(string key){
    list1->finding(key);
    }


    void print_currnet_scope_table(){
    int c=length;
    //fprintf(logout, "Scopetable # %d", c);
    cout<<"ScopeTable  # "<<c<<endl;
    list1->displayHash();
    }

    void print_all_scope_table(){
    Hash * temp=list1;
    int c=length;
        while(temp!=0){
            cout<<"ScopeTable  # "<<c<<endl;
            temp->displayHash();
            cout<<endl<<endl;
            temp=temp->next;
            c--;
        }
    }

    void exit_scope(){
    cout<<"Scope table with  id "<<list1->position+1<<" is removed"<<endl;
    Hash *temp=list1;
    list1=list1->next;
    delete(temp);
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

