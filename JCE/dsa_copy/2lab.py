class Node: # Define a Node class which represents a single element in the Linked List
    def __init__(self, data): # Constructor to initialize the node
        self.data = data  # Stores the actual value/data payload of the node
        self.next = None  # Pointer/reference to the next node, initialized to None

class SinglyLinkedList: # Define the Singly Linked List class
    def __init__(self): # Constructor for the list
        self.head = None  # Initial list is empty, so head pointer is None

    def insert_at_end(self, data): # Method to insert a new node at the tail of the list
        new_node = Node(data) # Create a new Node object with the given data
        if not self.head: # Check if the list is completely empty (head is None)
            self.head = new_node # If empty, the new node becomes the head
            print(f"Successfully inserted {data} as the head node.")
            return # Exit the function
        current = self.head # Start traversal from the head node
        while current.next: # Loop as long as there is a next node
            current = current.next # Move to the next node
        current.next = new_node # We've reached the last node, set its 'next' to the new node
        print(f"Successfully inserted {data} at the end.")

    def insert_at_beginning(self, data): # Method to insert a new node at the head
        new_node = Node(data) # Create the new node
        new_node.next = self.head # Make the new node point to the current head
        self.head = new_node # Update the head pointer to be the new node
        print(f"Successfully inserted {data} at the beginning.")

    def delete_by_value(self, key): # Method to delete a node containing a specific value
        current = self.head # Start at the head
        if not current: # If list is empty
            print("The list is empty. Nothing to delete.")
            return
        if current.data == key: # Special case: if the node to delete is the head node itself
            self.head = current.next # Move head to the second node
            print(f"Deleted node containing value: {key}")
            return
        prev = None # Keep track of the previous node for linking
        while current and current.data != key: # Traverse until the end or until the key is found
            prev = current # Update prev to current
            current = current.next # Move current forward
        if not current: # If we reached the end and didn't find the key
            print(f"Value {key} not found in the list.")
            return
        prev.next = current.next # We found it. Link the previous node to the node AFTER the current one, bypassing 'current'
        print(f"Deleted node containing value: {key}")

    def display(self): # Method to print the list visually
        if not self.head: # Check if empty
            print("Linked List is empty: None")
            return
        current = self.head # Start at head
        print("Linked List: ", end="") # Print prefix without a newline
        while current: # Loop through all nodes
            print(current.data, end=" -> ") # Print node data and an arrow
            current = current.next # Move to next node
        print("None") # End the visual chain with 'None'

def main(): # Main execution function
    linked_list = SinglyLinkedList() # Instantiate the SinglyLinkedList object
    while True: # Infinite menu loop
        print("1. Insert at Beginning")
        print("2. Insert at End")
        print("3. Delete by Value")
        print("4. Display List")
        print("5. Exit")
        choice = input("Enter your choice (1-5): ").strip() # Get stripped user input
        
        if choice == '1': # Insert at beginning
            value = input("Enter value to insert at beginning: ")
            linked_list.insert_at_beginning(value)
        elif choice == '2': # Insert at end
            value = input("Enter value to insert at end: ")
            linked_list.insert_at_end(value)
        elif choice == '3': # Delete
            value = input("Enter value to delete: ")
            linked_list.delete_by_value(value)
        elif choice == '4': # Display
            linked_list.display()
        elif choice == '5': # Exit
            print("Exiting program. Goodbye!")
            break
        else: # Invalid input
            print("Invalid choice! Please select an option between 1 and 5.")

if __name__ == "__main__": # Ensure script only runs main() if executed directly, not if imported
    main()

'''
CODE FLOW:
1. The script begins in the `if __name__ == "__main__":` block, which calls `main()`.
2. Inside `main()`, a `SinglyLinkedList` object is initialized. Its `self.head` is `None`.
3. An interactive loop prompts the user. If they choose to insert at the end (2), it creates a `Node`. If `head` is empty, it assigns `head` to this node. Otherwise, it uses a `while current.next:` loop to traverse the list and attach the new node to the very end.
4. If they insert at the beginning (1), the new node's `next` pointer is set to the current `head`, and `head` is reassigned to the new node, pushing everything else back.
5. Deletion (3) requires two pointers (`prev` and `current`). It walks down the list until `current.data` matches the key. It then modifies `prev.next = current.next` to remove the node from the chain.
6. Display (4) iterates through the nodes starting from `head`, printing the `data` and moving via `.next` until it hits `None`.

SUMMARY:
This Python program implements a classic Singly Linked List Data Structure from scratch. 
Instead of relying on built-in dynamic arrays (like Python lists), it manually allocates `Node` objects in memory and links them together via pointers (`self.next`). 
This demonstrates low-level memory management concepts (node traversal, pointer reassignment, head management) in a high-level language.
'''
