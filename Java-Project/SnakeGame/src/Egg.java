import java.awt.Color;
import java.awt.Graphics;


public class Egg {

	int col,row;

	public Egg() {
		this.col = (int)(Math.random()* Yard.COLS);
		this.row = 3 + (int)(Math.random()*(Yard.ROWS - 3));
	//	System.out.println(col);
	//	System.out.println(row);
	}
	
	public void changePosition(){
		col = (int)(Math.random()* Yard.COLS);
		row = 3 + (int)(Math.random()*(Yard.ROWS - 3));
	}
	
	public void draw(Graphics g){
		Color c = g.getColor();
		g.setColor(Color.GREEN);
		g.fillOval(col * Yard.BLOCK_SIZE,row * Yard.BLOCK_SIZE,  Yard.BLOCK_SIZE, Yard.BLOCK_SIZE);
		g.setColor(c);
	}
	
	
}
