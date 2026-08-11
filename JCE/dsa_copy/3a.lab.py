class stack: # Define a class named 'stack'

    def __init__(self): # Constructor to initialize the stack
        self.items=[] # Use a built-in Python list as the underlying dynamic array

    def isempty(self): # Check if stack is empty
        return self.items==[] # Returns True if length is 0, else False

    def push(self, data): # Method to push (add) an element to the top of the stack
        self.items.append(data) # Appends to the end of the array (representing the top)

    def pop(self): # Method to pop (remove) the top element
        return self.items.pop() # Removes and returns the last element in the array

    def peek(self): # Method to look at the top element without removing it
        return self.items[-1] # Accesses the last element using negative indexing

    def size(self): # Method to get the current number of elements
        return len(self.items) # Returns the length of the underlying list

s = stack() # Instantiate a stack object named 's'
while True: # Infinite loop for the user interface
    print('push<value>') # Instructions for pushing
    print('pop')         # Instructions for popping
    print('peek')        # Instructions for peeking
    print('stacksize')   # Instructions for checking size
    print('quit')        # Instructions to exit
    do = input('what would u like to do? ').split() # Get input and split into a list of words (e.g. ['push', '10'])
    operation = do[0].strip().lower() # The first word is the operation, convert to lowercase for easy matching
    
    if operation == 'push': # If operation is push
        s.push(int(do[1])) # Convert the second word (do[1]) to integer and push it
    elif operation == 'pop': # If operation is pop
        if s.isempty(): # Check for underflow
            print('stack is empty') # Print error
        else:
            print('popped value:', s.pop()) # Pop and print the returned value
    elif operation == 'peek': # If operation is peek
        print('peek value', s.peek()) # Call peek() and print
    elif operation == 'stacksize': # If operation is stacksize
        print('stack size', s.size()) # Call size() and print
    elif operation == 'quit': # If operation is quit
        break # Exit the while loop

'''
CODE FLOW:
1. The `stack` class is initialized wrapping a standard Python list `self.items`.
2. A `stack` object `s` is created.
3. A `while True` loop starts to accept user commands continuously.
4. The user types a command like "push 50". `input().split()` converts this into `['push', '50']`.
5. The first element `do[0]` determines the operation.
6. If it's a push, `s.push(int(do[1]))` executes, calling `.append()` to add 50 to the end of `items`.
7. If it's a pop, it checks `s.isempty()`. If false, `s.pop()` removes the very last element of the list (LIFO principle) and returns it for printing.
8. `peek` simply accesses `self.items[-1]` to show the top element without mutating the list.

SUMMARY:
This program implements a Stack Data Structure using a dynamic array (Python List). 
A stack follows the Last-In-First-Out (LIFO) principle. By restricting interactions strictly to `append()` (push) and `pop()` at the very end of the array, the list perfectly mimics a stack. 
The program also utilizes Python's string manipulation methods to parse text commands into function calls.
'''
