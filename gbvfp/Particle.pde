/*
    This is a simple example implemenation of Goal-Based Vector Field Pathfinding
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

public class Particle {
  private PVector pos;
  private PVector vel;
  private PVector acc;
  
  gbvfp main;
  
  public Particle(gbvfp main, float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    
    this.main = main;
  }
  
  public void update() {
    vel.add(acc);
    pos.add(vel);
    
    vel.limit(20f);
    vel.mult(0.99f);
    
    acc.x = 0;
    acc.y = 0;
    
    edges();
    target();
  }
  
  public void edges() {
    int x = floor(pos.x / main.getSclW()), y = floor(pos.y / main.getSclH());
    
    if(x > main.field.sizeW - 1) {
      pos.x = 0;
    }
    if(x < 0) {
      pos.x = main.getSclW() * (main.field.sizeW - 1);
    }
    
    if(y > main.field.sizeH - 1) {
      pos.y = 0;
    }
    if(y < 0) {
      pos.y = main.getSclH() * (main.field.sizeH - 1);
    }
  }
  
  public void target() {
    int x = floor(pos.x / main.getSclW()), y = floor(pos.y / main.getSclH());
    Field field = main.field.fields[x][y];
    
    vel.x = cos(field.direction) * 10f;
    vel.y = sin(field.direction) * 10f;
    
    /*for(int i = 0; i < main.particles.size(); i++) {
      PVector pos2 = main.particles.get(i).pos;
      if(pos.dist(pos2) < RADIUS / 2f) { //StrokeWeight is the doubled amount, thats why is used RADIUS instead of RADIUS * 2f
        pos.x += (pos.x - pos2.x) / 10f;
        pos.y += (pos.y - pos2.y) / 10f;
      }
    }*/
  }
  
  public void draw() {
    if (pos.x > 0 && pos.x < width 
        && pos.y > 0 && pos.y < height) {
          stroke(
            color(
              (pos.x / width) * 255f, 
              255f, 
              (((pos.y / height) * 0.5f) + 0.5f) * 255f, 
              100f
            )
          );
          
          point(pos.x, pos.y);
    }
  }
}