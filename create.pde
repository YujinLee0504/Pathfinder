import java.util.*;

public class Node {
  private int xPos;
  private int yPos;
  private color col;
  private boolean isStart;
  private boolean isEnd;
  private boolean visited;
  private ArrayList<Node> neighbors;
  private Node parent;
  boolean isPath;

  public Node(int newX, int newY, color co, boolean start, boolean end, Node p) {
    xPos = newX;
    yPos = newY;
    col = co;
    isStart = start;
    isEnd = end;
    visited = false;
    neighbors = new ArrayList<Node>();
    parent = p;
    isPath = false;
  }

  public int getX() {
    return xPos;
  }

  public int getY() {
    return yPos;
  }

  public void setCol(color red) {
        this.col = red;
   }

  public void setStart() {
    isStart = true;
  }

  public boolean isStart() {
    return isStart;
  }

  public void setEnd() {
    isEnd = true;
  }

  public boolean isEnd() {
    return isEnd;
  }

  public boolean isVisited() {
    return visited;
  }

  public void setVisited(boolean v) {
    visited = v;
  }

  public ArrayList<Node> getNeighbors() {
    return neighbors;
  }
  
  public Node getParent() {
    return parent;
}

  public void addNeighbor(Node n){
    neighbors.add(n);
  }

  public void setIsPath(boolean yes){
    this.isPath = yes;
  }

  public boolean isPath(){
    return isPath;
  }

  public void drawNode() {
    fill(col);
    ellipse(xPos, yPos, 10, 10);
  }
  
  public void drawPath() {
    color pathColor = color(255, 50, 50);
    this.setCol(pathColor);
    this.drawNode();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//window resolution : 1920, 1080
  int wh = 1000;
  int gridSize = wh/20;
//determines the size(x/y) of the grid has to be even
ArrayList<ArrayList<Node>> adj;
ArrayList<ArrayList<Node>> grid;
LinkedList<Node> q;
Node p;
Node startNode;
Node endNode;

void setup() {
  size(1000,1000);
  background(255, 255, 255);
  frameRate(20);

  adj = new ArrayList<ArrayList<Node>>(); //adjacency List
  grid = new ArrayList<ArrayList<Node>>();
  color black = color(0, 0, 0);
  
  //finds the middle point of every coordinate and fills the grid list (nodes)
  for (int midX = gridSize; midX < wh; midX = midX + gridSize) {
    ArrayList<Node> innerNode = new ArrayList<Node>();
    for (int midY = gridSize; midY < wh; midY += gridSize) {
      Node node = new Node(midX, midY, black, false, false, p);
      innerNode.add(node);
    }
    grid.add(innerNode);
  }

// Add neighbors to each node in the grid
   for (int i = 0; i < grid.size(); i++) {
    for (int j = 0; j < grid.get(i).size(); j++) {
      Node current = grid.get(i).get(j);

      //right
      if (j < grid.get(i).size()-1) {
        current.addNeighbor(grid.get(i).get(j+1));
      }

      //left
      if (j > 0) {
        current.addNeighbor(grid.get(i).get(j-1));
      }

      //up
      if (i > 0) {
        current.addNeighbor(grid.get(i-1).get(j));
      }

      //down
      if (i < grid.size()-1) {
        current.addNeighbor(grid.get(i+1).get(j));
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

void draw(){
  //Draws grid
  for (int i = 0; i <= wh; i = i+gridSize){
    line(0, i, wh, i);
    for(int j = 0; j <= wh; j = j+gridSize){
      line(j, 0, j, wh);
    }
  }

//draw node
  for (int i = 0; i < grid.size(); i++) {
    for (int j = 0; j < grid.get(i).size(); j++) {
      for(int limit = 0; limit <= wh; limit = limit+gridSize){
        if (grid.get(i).get(j).isStart()){
        grid.get(i).get(j).drawNode();
        }
        else if (grid.get(i).get(j).isEnd()){
        grid.get(i).get(j).drawNode();
        }
        
    }
  }  
}

}



//draw the nodes that indicate the bfs results
public void drawPath(Node sNode, Node eNode){
 // end node to the parent nodes
 Node cNode = eNode;
 while (cNode != sNode){
   cNode = cNode.getParent();
   cNode.setIsPath(true);
 }
 
 //drawww
 for (int i = 0; i < grid.size(); i ++){
   for (int j = 0; j < grid.get(i).size(); j++){
     Node node = grid.get(i).get(j);
     if (node.isPath) {
       node.drawPath();
     }
   }
 }
}


//O(VE)
public void bfs(Node sNode, Node eNode) {
  // q for BFS
  LinkedList<Node> q = new LinkedList<Node>();

  // current Node is visited and enqueued
  sNode.visited = true;
  q.add(sNode);
  while (q.size() != 0) {
    // Dequeue a node and draw
    Node currentNode = q.poll();
    //if end node, break out of loop
    if (currentNode == eNode) {
      break;
    }

    // get all adjacent nodes of the current node
    ArrayList<Node> adjNodes = currentNode.getNeighbors();

    // enqueue all the adjacent nodes that haven't been visited
    for (Node adjNode : adjNodes) {
      if (!adjNode.visited) {
        adjNode.visited = true;
        adjNode.parent = currentNode;
        q.add(adjNode);
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

//set node as start or end
void mouseClicked() {
  int row = floor(mouseX/gridSize);
  int column = floor(mouseY/gridSize);

//System.out.println(row);
//System.out.println(column);
    if (mouseButton == LEFT) {
      grid.get(row).get(column).setStart();
      startNode = grid.get(row).get(column);
    }
    if (mouseButton == RIGHT) {
      grid.get(row).get(column).setEnd();
      endNode = grid.get(row).get(column);
    }
  if(startNode != null && endNode != null){
    bfs(startNode, endNode);
    drawPath(startNode, endNode);
  }
  }
