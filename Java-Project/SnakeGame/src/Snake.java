import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.KeyEvent;


public class Snake {

	Node head = null;
	Node tail = null;
	int size = 0;
	// set the direction for head
	Dir dir = Dir.U;
	public Snake() {
		head = new Node(10,15);
		tail = head;
		size = 1;
	}




	public void draw(Graphics g){
		if(!checkDead())
			move();
		for(Node n = head; n != null; n = n.next){
			n.draw(g);
		}


	}

	private boolean checkDead() {
		// TODO Auto-generated method stub
		if(head.row < 0 ||( head.col < 0) ||( head.row > Yard.ROWS-3)
				|| (head.col >  Yard.COLS-3))
			return true;
		for(Node n = head.next; n != null; n = n.next){
			if(head.col == n.col && head.row == n.row)
				return true;
		}
		
		return false;
	}




	// make the last section of the snake to the first section
	private void move() {
		addToHead();
		delFromTail();
	}

	// del from tail for drawing the snake
	private void delFromTail() {
		Node n = tail.prev;
		tail.prev = null;
		n.next = null;
		tail = n;	
	}


	// add the tail to head
	private void addToHead() {
		Node n = new Node();
		switch(dir){
		case L : 
			n.col = head.col - 1;
			n.row = head.row;
			break;
		case R :
			n.col = head.col + 1;
			n.row = head.row;
			break;
		case U :
			n.col = head.col;
			n.row = head.row - 1;
			break;
		case D :		
			n.col = head.col ;
			n.row = head.row + 1;
			break;
		}
		n.next = head;
		head.prev = n;
		head = n;
	}






	class Node{
		int col,row;
		Node next;
		Node prev;
		public Node() {
		}
		public Node(int col, int row) {
			this.col = col;
			this.row = row;
		}

		public void draw(Graphics g){
			Color c = g.getColor();
			g.setColor(Color.BLACK);
			g.fillRect(col * Yard.BLOCK_SIZE, row * Yard.BLOCK_SIZE, Yard.BLOCK_SIZE, Yard.BLOCK_SIZE);
			g.setColor(c);
		}



	}



	public void responseKeyPress(KeyEvent e) {
		// TODO Auto-generated method stub
		switch(e.getKeyCode()){
		case KeyEvent.VK_UP :
			dir = Dir.U;
			break;
		case KeyEvent.VK_DOWN:
			dir = Dir.D;
			break;
		case KeyEvent.VK_LEFT:
			dir = Dir.L;
			break;
		case KeyEvent.VK_RIGHT:
			dir = Dir.R;
			break;

		}

	}


	public void eat(Egg e) {

		if(intersect(this,e)){
			e.changePosition();
			this.addToHead();
		}	
	}

	private boolean intersect(Snake snake, Egg e) {
		if((snake.head.col == e.col) && (snake.head.row == e.row))
			return true;

		return false;
	}
}
