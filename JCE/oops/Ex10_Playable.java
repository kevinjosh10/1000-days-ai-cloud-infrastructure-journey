interface Playable {
    void play();
    void country();
}

class Basketball implements Playable {
    @Override
    public void play(){
        System.out.println("THERE ARE 10 PLAYERS IN BASKETBALL!");
    }
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN BASKETBALL IS USA");
    }
}

class Football implements Playable {
    @Override
    public void play(){
        System.out.println("THERE ARE 11 PLAYERS IN FOOTBALL!");
    }
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN FOOTBALL IS ARGENTINA");
    }
}

class Volleyball implements Playable {
    @Override
    public void play(){
        System.out.println("THERE ARE SIX PLAYERS IN VOLLEYBALL!");
    }
    @Override
    public void country(){
        System.out.println("THE LEADING COUNTRY IN VOLLEYBALL IS POLAND");
    }
}

public class Main {
    public static void main(String[] args){
        Playable bb=new Basketball();
        bb.play();
        bb.country();
        
        Playable fb=new Football();
        fb.play();
        fb.country();
        
        Playable vb=new Volleyball();
        vb.play();
        vb.country();
    }
}
