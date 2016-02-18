import java.awt.Color;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


public class Yard extends Frame{

	protected static final int ROWS = 30;
	protected static final int COLS = 30;
	protected static final int BLOCK_SIZE = 15;
	// create a thread
	Thread paintThread = new Thread(new Runnable(){
		@Override
		public void run(){
		
			while(true){
				repaint();
				try{
					Thread.sleep(80);
				}
				catch(InterruptedException e){
					
				}
				
			}
			
		}
	});
	
	Snake s = new Snake();
	Egg e = new Egg();
	
	
	
	// draw the background and sth. else
	@Override
	public void paint(Graphics g) {
		Color c = g.getColor();
		g.setColor(Color.BLACK);
		for(int i = 0; i <= COLS ; i++)
			g.drawLine(i * BLOCK_SIZE, 0, i * BLOCK_SIZE, ROWS * BLOCK_SIZE);
		for(int i = 0; i <= ROWS ; i++)
			g.drawLine(0, i * BLOCK_SIZE, ROWS * BLOCK_SIZE, i * BLOCK_SIZE);
		
		s.eat(e);
		e.draw(g);
		s.draw(g);


		g.setColor(c);
	}

	// perform the code
	public void launch(){
		
		this.setLocation(200, 200);
		this.setSize(ROWS * BLOCK_SIZE, COLS * BLOCK_SIZE);
		this.setResizable(false);
		this.setVisible(true);
		this.addWindowListener(new WindowAdapter(){
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
			
		});
		// add a key listener
		this.addKeyListener(new KeyAdapter(){
			@Override
			public void keyPressed(KeyEvent e) {
			s.responseKeyPress(e);
			}
			
		});
		
		paintThread.start();
		
	}
	
	public static void main(String[] arg){
		new Yard().launch();
	}
}
