class stack:

    def __init__(self):
        self.items=[]

    def isempty(self):
        return self.items==[]

    def push(self, data):
        self.items.append(data)

    def pop(self):
        return self.items.pop()

    def peek(self):
        return self.items[-1]

    def size(self):
        return len(self.items)

s = stack()
while True:
    print('push<value>')
    print('pop')
    print('peek')
    print('stacksize')
    print('quit')
    do = input('what would u like to do? ').split()
    operation = do[0].strip().lower()
    if operation == 'push':
        s.push(int(do[1]))
    elif operation == 'pop':
        if s.isempty():
            print('stack is empty')
        else:
            print('popped value:', s.pop())
    elif operation == 'peek':
        print('peek value', s.peek())
    elif operation == 'stacksize':
        print('stack size', s.size())
    elif operation == 'quit':
        break
