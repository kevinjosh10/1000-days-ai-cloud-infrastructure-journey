import java.util.Scanner;

class Employee {
    String name;
    int id;
    int grossSalary, HRA, medical, transport, PF, tax;

    public Employee(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax) {
        this.name = name;
        this.id = id;
        this.grossSalary = grossSalary;
        this.HRA = HRA;
        this.medical = medical;
        this.transport = transport;
        this.PF = PF;
        this.tax = tax;
    }

    void getDetails() {
        System.out.println("Name: " + name);
        System.out.println("ID: " + id);
        System.out.println("Gross Salary: " + grossSalary);
        System.out.println("HRA: " + HRA);
        System.out.println("Medical Insurance: " + medical);
        System.out.println("Transport: " + transport);
        System.out.println("PF: " + PF);
        System.out.println("Income Tax: " + tax);
    }

    String display() {
        int benefits = calculateBenefits();
        int basicSalary = grossSalary + benefits - (HRA + medical + transport + PF + tax);
        System.out.println("Basic Salary: " + basicSalary);
        return "Basic Salary: " + basicSalary;
    }

    int calculateBenefits() {
        return 0; 
    }
}

class Programmer extends Employee {
    int hike;
    public Programmer(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int hike) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax);
        this.hike = hike;
    }
    @Override
    int calculateBenefits() {
        return hike;
    }
    void call() {
        System.out.println("Programmer Salary");
        getDetails();
        display();
    }
}

class AssistantProfessor extends Employee {
    int researchAllowance;
    public AssistantProfessor(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int researchAllowance) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax);
        this.researchAllowance = researchAllowance;
    }
    @Override
    int calculateBenefits() {
        return researchAllowance;
    }
    void call() {
        System.out.println("Assistant Professor Salary");
        getDetails();
        display();
    }
}

class Professor extends Employee {
    int publicationBonus;
    public Professor(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int publicationBonus) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax);
        this.publicationBonus = publicationBonus;
    }
    @Override
    int calculateBenefits() {
        return publicationBonus;
    }
    void call() {
        System.out.println("Professor Salary");
        getDetails();
        display();
    }
}

public class SalaryProgram {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter name: ");
        String name = sc.nextLine();
        System.out.print("Enter ID: ");
        int id = sc.nextInt();
        sc.nextLine(); 
        System.out.print("Enter profession (Programmer/AssistantProfessor/Professor): ");
        String profession = sc.nextLine();
        
        System.out.print("Enter Gross Salary: ");
        int grossSalary = sc.nextInt();
        System.out.print("Enter HRA: ");
        int HRA = sc.nextInt();
        System.out.print("Enter Medical Insurance: ");
        int medical = sc.nextInt();
        System.out.print("Enter Transport: ");
        int transport = sc.nextInt();
        System.out.print("Enter PF: ");
        int PF = sc.nextInt();
        System.out.print("Enter Tax: ");
        int tax = sc.nextInt();
        
        if (profession.equalsIgnoreCase("Programmer")) {
            System.out.print("Enter Hike: ");
            int hike = sc.nextInt();
            Programmer p = new Programmer(name, id, grossSalary, HRA, medical, transport, PF, tax, hike);
            p.call();
        } else if (profession.equalsIgnoreCase("AssistantProfessor")) {
            System.out.print("Enter Research Allowance: ");
            int researchAllowance = sc.nextInt();
            AssistantProfessor ap = new AssistantProfessor(name, id, grossSalary, HRA, medical, transport, PF, tax, researchAllowance);
            ap.call();
        } else if (profession.equalsIgnoreCase("Professor")) {
            System.out.print("Enter Publication Bonus: ");
            int publicationBonus = sc.nextInt();
            Professor pr = new Professor(name, id, grossSalary, HRA, medical, transport, PF, tax, publicationBonus);
            pr.call();
        } else {
            System.out.println("Invalid profession entered.");
        }
        sc.close();
    }
}
