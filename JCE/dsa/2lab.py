class Node:
    def __init__(self, data):
        self.data = data  # Stores the actual value
        self.next = None  # Pointer/reference to the next node

class SinglyLinkedList:
    def __init__(self):
        self.head = None  # Initial list is empty

    def insert_at_end(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            print(f"Successfully inserted {data} as the head node.")
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
        print(f"Successfully inserted {data} at the end.")

    def insert_at_beginning(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
        print(f"Successfully inserted {data} at the beginning.")

    def delete_by_value(self, key):
        current = self.head
        if not current:
            print("The list is empty. Nothing to delete.")
            return
        if current.data == key:
            self.head = current.next
            print(f"Deleted node containing value: {key}")
            return
        prev = None
        while current and current.data != key:
            prev = current
            current = current.next
        if not current:
            print(f"Value {key} not found in the list.")
            return
        prev.next = current.next
        print(f"Deleted node containing value: {key}")

    def display(self):
        if not self.head:
            print("Linked List is empty: None")
            return
        current = self.head
        print("Linked List: ", end="")
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")

def main():
    linked_list = SinglyLinkedList()
    while True:
        print("1. Insert at Beginning")
        print("2. Insert at End")
        print("3. Delete by Value")
        print("4. Display List")
        print("5. Exit")
        choice = input("Enter your choice (1-5): ").strip()
        
        if choice == '1':
            value = input("Enter value to insert at beginning: ")
            linked_list.insert_at_beginning(value)
        elif choice == '2':
            value = input("Enter value to insert at end: ")
            linked_list.insert_at_end(value)
        elif choice == '3':
            value = input("Enter value to delete: ")
            linked_list.delete_by_value(value)
        elif choice == '4':
            linked_list.display()
        elif choice == '5':
            print("Exiting program. Goodbye!")
            break
        else:
            print("Invalid choice! Please select an option between 1 and 5.")

if __name__ == "__main__":
    main()
