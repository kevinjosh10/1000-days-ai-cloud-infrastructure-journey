// Define an interface named 'Playable'
// Interfaces define a contract that implementing classes must follow
interface Playable {
    void play(); // Abstract method declaration for 'play'
    void country(); // Abstract method declaration for 'country'
}

// Class Basketball implements the Playable interface
class Basketball implements Playable {
    // Must override and provide implementation for play()
    @Override
    public void play(){
        System.out.println("THERE ARE 10 PLAYERS IN BASKETBALL!"); // Print specific info
    }
    
    // Must override and provide implementation for country()
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN BASKETBALL IS USA"); // Print specific info
    }
}

// Class Football implements the Playable interface
class Football implements Playable {
    // Provide implementation for play()
    @Override
    public void play(){
        System.out.println("THERE ARE 11 PLAYERS IN FOOTBALL!"); // Print specific info
    }
    
    // Provide implementation for country()
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN FOOTBALL IS ARGENTINA"); // Print specific info
    }
}

// Class Volleyball implements the Playable interface
class Volleyball implements Playable {
    // Provide implementation for play()
    @Override
    public void play(){
        System.out.println("THERE ARE SIX PLAYERS IN VOLLEYBALL!"); // Print specific info
    }
    
    // Provide implementation for country()
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN VOLLEYBALL IS POLAND"); // Print specific info
    }
}

// Public class containing the main method
public class Main {
    public static void main(String[] args){
        // Create a Basketball object but reference it via the Playable interface type
        Playable bb = new Basketball();
        bb.play(); // Calls Basketball's implementation of play()
        bb.country(); // Calls Basketball's implementation of country()
        
        // Create a Football object but reference it via the Playable interface type
        Playable fb = new Football();
        fb.play(); // Calls Football's implementation of play()
        fb.country(); // Calls Football's implementation of country()
        
        // Create a Volleyball object but reference it via the Playable interface type
        Playable vb = new Volleyball();
        vb.play(); // Calls Volleyball's implementation of play()
        vb.country(); // Calls Volleyball's implementation of country()
    }
}

/*
CODE FLOW:
1. Execution starts in the `main` method of the `Main` class.
2. A `Basketball` object is created but assigned to a reference variable of type `Playable` named `bb`.
3. The `bb.play()` method is called. Since `bb` references a `Basketball` object at runtime, the overridden `play()` method inside the `Basketball` class is executed, printing its specific string.
4. The `bb.country()` method is called, executing the overridden `country()` method inside the `Basketball` class.
5. Next, a `Football` object is created and assigned to the `Playable` reference `fb`. 
6. `fb.play()` and `fb.country()` are called, routing execution to the overridden methods inside the `Football` class due to dynamic method dispatch.
7. Finally, a `Volleyball` object is created and assigned to the `Playable` reference `vb`.
8. `vb.play()` and `vb.country()` are called, executing the methods inside the `Volleyball` class.
9. The program terminates successfully.

SUMMARY:
This Java program demonstrates Abstraction and Interfaces.
- An interface `Playable` is defined as a blueprint. It contains two abstract method signatures (`play()` and `country()`) without any method body.
- Three distinct classes (`Basketball`, `Football`, `Volleyball`) implement the `Playable` interface.
- According to Java rules, each implementing class *must* provide a concrete implementation (via `@Override`) for all abstract methods declared in the interface.
- In the `main` method, objects of the specific classes are instantiated but are referenced using the interface type (`Playable bb = new Basketball()`), showcasing runtime polymorphism and loose coupling.
*/
