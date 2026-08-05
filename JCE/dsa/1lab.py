class list:
    def __init__(self):
        self.items=[]
    def is_empty(self):
        return self.items==[]
    def insert_at_beg(self):
        data=int(input("enter the value:"))
        self.items.insert(0,data)
    def insert_at_x(self):
        x=int(input("enter the position:"))
        data=int(input("enter the value:"))
        self.items.insert(x,data)
    def insert_at_end(self):
        data=int(input("enter the value:"))
        self.items.append(data)
    def del_at_beg(self):
        return self.items.pop(0)
    def del_data(self):
        data=int(input("enter the data to be deleted:"))
        self.items.remove(data)
        return data
    def del_at_end(self):
        return self.items.pop()
    def search(self,x):
        for i in range(len(self.items)):
            if self.items[i]==x:
                return i
        return -1
    def display(self):
        print(self.items)

s=list()
while True:
    print("1.insert at the beginning")
    print("2.insert at the given position")
    print("3.insert at the end")
    print("4.delete at the beginning")
    print("5.delete at the end")
    print("6.delete the given data")
    print("7.search")
    print("8.display")
    print("9.quit")
    ch=int(input("enter the option:"))
    if ch==1:
        s.insert_at_beg()
    elif ch==2:
        s.insert_at_x()
    elif ch==3:
        s.insert_at_end()
    elif ch==4:
        if s.is_empty():
            print("list is empty")
        else:
            print("deleted value:",s.del_at_beg())
    elif ch==5:
        if s.is_empty():
            print("list is empty")
        else:
            print("deleted value:",s.del_at_end())
    elif ch==6:
        if s.is_empty():
            print("list is empty")
        else:
            print("deleted value:",s.del_data())
    elif ch==7:
        x=int(input("enter the value to be searched:"))
        f=s.search(x)
        if f==-1:
            print("element not found")
        else:
            print("element found at:",f+1)
    elif ch==8:
        s.display()
    elif ch==9:
        break
    else:
        print("invalid choice")
