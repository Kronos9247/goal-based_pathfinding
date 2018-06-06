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

public final float RADIUS = 10; //because of processing(java) isn't allow statics in subclasses

public class Field {
  float direction = radians(45);
  int distance;
  
  int x, y;
  
  Field pre;
  
  boolean translucent = true;
  boolean visited;
  
  public Field(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw(float cx, float cy) {
    /*stroke(255);
    line(cx, cy, cx + cos(direction) * RADIUS, cy + sin(direction) * RADIUS);
    
    
    fill(255);
    text(String.valueOf(distance), cx - 4.5f, cy + 5f);*/
  }
  
  public void updateDir(Field to) {
    direction = atan2(to.y - y, to.x - x);
  }
}