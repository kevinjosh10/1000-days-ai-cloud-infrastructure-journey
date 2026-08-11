class list: # Define a class named 'list' (shadows built-in list, but used for lab)
    def __init__(self): # Constructor method to initialize the object
        self.items=[] # Initialize an empty built-in list to store elements
    def is_empty(self): # Method to check if the list is empty
        return self.items==[] # Returns True if items is empty, False otherwise
    def insert_at_beg(self): # Method to insert an element at the beginning (index 0)
        data=int(input("enter the value:")) # Prompt user for integer input
        self.items.insert(0,data) # Use built-in insert() to place data at index 0
    def insert_at_x(self): # Method to insert at a specific position
        x=int(input("enter the position:")) # Prompt user for the index position
        data=int(input("enter the value:")) # Prompt user for the value
        self.items.insert(x,data) # Insert the data at index 'x'
    def insert_at_end(self): # Method to insert an element at the end
        data=int(input("enter the value:")) # Prompt user for value
        self.items.append(data) # Use built-in append() to add data to the end
    def del_at_beg(self): # Method to delete the first element
        return self.items.pop(0) # Use pop(0) to remove and return the item at index 0
    def del_data(self): # Method to delete a specific value by its data
        data=int(input("enter the data to be deleted:")) # Prompt user for the value to delete
        self.items.remove(data) # Use built-in remove() to find and delete the first occurrence of data
        return data # Return the deleted data
    def del_at_end(self): # Method to delete the last element
        return self.items.pop() # Use pop() with no argument to remove and return the last item
    def search(self,x): # Method to search for a value 'x'
        for i in range(len(self.items)): # Iterate through the indices of the list
            if self.items[i]==x: # If the item at index 'i' matches 'x'
                return i # Return the index where it was found
        return -1 # Return -1 if the element is not found after checking all items
    def display(self): # Method to display the entire list
        print(self.items) # Print the underlying built-in list

s=list() # Instantiate a new object 's' of our custom 'list' class
while True: # Start an infinite loop for the menu-driven program
    print("1.insert at the beginning") # Print menu option 1
    print("2.insert at the given position") # Print menu option 2
    print("3.insert at the end") # Print menu option 3
    print("4.delete at the beginning") # Print menu option 4
    print("5.delete at the end") # Print menu option 5
    print("6.delete the given data") # Print menu option 6
    print("7.search") # Print menu option 7
    print("8.display") # Print menu option 8
    print("9.quit") # Print menu option 9
    ch=int(input("enter the option:")) # Prompt user for their menu choice
    if ch==1: # If user chooses 1
        s.insert_at_beg() # Call insert_at_beg()
    elif ch==2: # If user chooses 2
        s.insert_at_x() # Call insert_at_x()
    elif ch==3: # If user chooses 3
        s.insert_at_end() # Call insert_at_end()
    elif ch==4: # If user chooses 4
        if s.is_empty(): # Check if list is empty before deleting
            print("list is empty") # Print error message
        else:
            print("deleted value:",s.del_at_beg()) # Delete and print the popped value
    elif ch==5: # If user chooses 5
        if s.is_empty(): # Check if list is empty
            print("list is empty")
        else:
            print("deleted value:",s.del_at_end()) # Delete from end and print
    elif ch==6: # If user chooses 6
        if s.is_empty(): # Check if list is empty
            print("list is empty")
        else:
            print("deleted value:",s.del_data()) # Delete specific data and print
    elif ch==7: # If user chooses 7
        x=int(input("enter the value to be searched:")) # Get value to search for
        f=s.search(x) # Call search() and store the returned index in 'f'
        if f==-1: # If -1 was returned
            print("element not found") # The element doesn't exist
        else:
            print("element found at:",f+1) # Print 1-based position (index + 1)
    elif ch==8: # If user chooses 8
        s.display() # Call display() to show all items
    elif ch==9: # If user chooses 9
        break # Break out of the while loop, terminating the program
    else: # If user enters an invalid number
        print("invalid choice") # Print error message

'''
CODE FLOW:
1. The script defines a custom `list` class that wraps a standard Python list (`self.items`) with helper methods.
2. An object `s` of this class is created.
3. An infinite `while True` loop begins, acting as the main menu.
4. The user inputs a choice (`ch`).
5. A large `if-elif` chain directs the flow based on the choice. For insertion (1-3), it prompts for data and calls the respective method, mutating `self.items`.
6. For deletions (4-6), it first checks `is_empty()`. If false, it removes the item using Python's `pop()` or `remove()` and prints it.
7. For search (7), it iterates through the list. If found, it prints the 1-based index (`f+1`). If not, it prints "element not found".
8. For display (8), it simply prints the list.
9. Choosing 9 executes `break`, breaking the loop and ending the script.

SUMMARY:
This Python program implements a basic menu-driven List Data Structure using Object-Oriented principles. 
It uses Python's built-in list as the underlying storage but abstracts the operations (insertion, deletion, searching) into class methods. 
This provides a safe interface to manipulate the list, demonstrating encapsulation and standard data structure operations.
'''
