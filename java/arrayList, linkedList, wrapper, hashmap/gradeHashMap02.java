import java.util.HashMap;
import java.util.Scanner;

public class Sungjuk {
	String hakbun, irum;
	int kor, eng, math, tot;
	double avg;
	String grade;

	Sungjuk()
	{
	}
	Sungjuk(String hakbun, String irum, int kor, int eng, int math)
	{
		this.hakbun = hakbun;
		this.irum = irum;
		this.kor = kor;
		this.eng = eng;
		this.math = math;
	}
	
	boolean input(HashMap<String, Sungjuk> hashmap)
	{
		Scanner scan = new Scanner(System.in); 
		System.out.print("�й� �Է� => ");
		hakbun = scan.next();
		
		//if (hashmap.containsKey(hakbun))  // Ű�� hakbun�� �����ϴ��� Ȯ��
		if (hashmap.get(hakbun) != null) // Ű�� hakbun�� �����ϴ��� Ȯ��. ������ null�� ��ȯ
		{
			return true;
		}
		
		System.out.print("�̸� �Է� => ");
		irum = scan.next();
		System.out.print("���� �Է� => ");
		kor = scan.nextInt();
		System.out.print("���� �Է� => ");
		eng = scan.nextInt();
		System.out.print("���� �Է� => ");
		math = scan.nextInt();
		
		return false;
	}
	
	void process()
	{
		tot = kor + eng + math;
		avg = tot / 3.;
		
		switch ((int)(avg/10))
		{
			case 10:
			case 9:
				grade = "��";
				break;
			case 8:
				grade = "��";
				break;
			case 7:
				grade = "��";
				break;
			case 6:
				grade = "��";
				break;
			default:
				grade = "��";
				break;
		}
	}
	
	void output()
	{
		System.out.printf("%4s   %3s   %4d    %4d    %4d    %4d    %5.2f  %4s\n",
			hakbun, irum, kor, eng, math, tot, avg, grade);
	}
}