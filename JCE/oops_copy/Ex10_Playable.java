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
