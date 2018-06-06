/*
    This is a simple example implementation of Goal-Based Vector Field Pathfinding
    Copyright (C) 2018  Rafael Orman

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

//Goal-Based Vector Field Pathfinding
/*

  Left Mouse ... to make the tile solid
  Right Mouse ... to make the tile translucent
  
  Keybord Number 1 ... to spawn particles
  Keybord Number 2 ... to go set the goal to the current mouse pos
  Keybord Number 3 ... to let the goal follow the mouse
  
  Keybord Enter ... to start
  
*/

boolean follow = false;

VecField field;
ArrayList<Particle> particles;

public void setup() {
  size(800, 800, P2D);
  
  field = new VecField(50, 50);
  particles = new ArrayList<Particle>();
}

public float getSclW() {
  return width / (float)field.sizeW;
}

public float getSclH() {
  return height / (float)field.sizeH;
}

public void draw() {
  background(51);
  
  strokeWeight(1);
  
  colorMode(RGB);
  
  float sclW = getSclW();
  float sclH = getSclH();
  for(int x = 0; x < field.sizeW; x++) {
    for(int y = 0; y < field.sizeH; y++) {
      /*if(field.fields[x][y].visited) 
        fill(color(255,100,100));
      else*/
        fill(field.fields[x][y].translucent ? color(51) : color(100, 255, 100));
      
      noStroke();
      rect(x * sclW, y * sclH, sclW, sclH);
      
      if(field.fields[x][y].translucent)
        field.fields[x][y].draw(x * sclW + sclW/2f, y * sclH + sclH/2f);
    }
  }
  
  colorMode(HSB);
  
  stroke(255);
  strokeWeight(RADIUS);
  for(int i = 0; i < particles.size(); i++) {
    particles.get(i).update();
    particles.get(i).draw();
  }
  
  /*if(keyPressed && key == '4') {
    for(int i = 0; i < 10; i++)
      field.step();
  }*/
  
  if(follow) {
    int x = floor(mouseX / getSclW()), y = floor(mouseY / getSclH());
    
    field.goal(x, y);
  }
}

public void keyPressed() {
  if(key == '1') {
    particles.clear();
    
    println("spawned particles");
    
    float sclW = getSclW();
    float sclH = getSclH();
    for(int x = 0; x < field.sizeW; x++) {
      for(int y = 0; y < field.sizeH; y++) {
        if(field.fields[x][y].translucent) {
          particles.add(new Particle(this, x * sclW + sclW/2f, y * sclH + sclH/2f));
        }
      }
    }
  }
  
  if(key == '2') {
    int x = floor(mouseX / getSclW()), y = floor(mouseY / getSclH());
    
    field.goal(x, y);
    
    follow = false;
  }
  
  if(key == '3') {
    follow = true;
  }
}

public void mouseEvent() {
  int x = floor(mouseX / getSclW()), y = floor(mouseY / getSclH());
  
  if(x >= 0 && x < field.sizeW && y >= 0 && y < field.sizeH) {
    if(mouseButton == LEFT)
      field.fields[x][y].translucent = false;
      
    if(mouseButton == RIGHT)
      field.fields[x][y].translucent = true;  
  }
}

public void mousePressed() {
  mouseEvent();
}

public void mouseDragged() {
  mouseEvent();
}
