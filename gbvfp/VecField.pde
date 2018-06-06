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

public class VecField {
  int sizeW, sizeH;
  
  Field[][] fields;
  
  ArrayList<Field> next; //in progress
  ArrayList<Field> newNext; //new
  
  public VecField(int sizeW, int sizeH) {
    this.sizeW = sizeW;
    this.sizeH = sizeH;
    
    next = new ArrayList<Field>();
    newNext = new ArrayList<Field>();
    
    fields = new Field[sizeW][sizeH];
    for(int x = 0; x < sizeW; x++) {
      for(int y = 0; y < sizeH; y++) {
        fields[x][y] = new Field(x, y);
      }
    }
  }
  
  private void test(int x, int y, Field field) {
    if(fields[x][y].translucent) {
      if(fields[x][y].visited == false) {
        fields[x][y].pre = field;
        fields[x][y].distance = field.distance + 1;
        fields[x][y].visited = true;
        
        //fields[x][y].updateDir(field); // this made it not look nice, because the pre-Field isn't always the nearest
        
        newNext.add(fields[x][y]);
      }
    }
  }
  
  private boolean testCorner(int x, int y, int nx, int ny) {
    return fields[nx][y].translucent && fields[x][ny].translucent;
  }
  
  private void step() {
    //synchronized(next) { synchronized(newNext) {
      if(next.size() > 0) {
        Field field = next.remove(next.size() - 1);
        field.visited = true;
        
        int x = field.x;
        int y = field.y;
        if(x > 0) test(x - 1, y, field);
        if(x < sizeW - 1) test(x + 1, y, field);
        
        if(y > 0) test(x, y - 1, field);
        if(y < sizeH - 1) test(x, y + 1, field);
        
        
        //Corner check (to make it look nicer) (nope, they are just adding more bugs to fix)
        if(x > 0) {
          if(y > 0 && testCorner(x, y, x - 1, y - 1)) test(x - 1, y - 1, field);
          if(y < sizeH - 1 && testCorner(x, y, x - 1, y + 1)) test(x - 1, y + 1, field);
        }
        if(x < sizeW - 1) {
          if(y > 0 && testCorner(x, y, x + 1, y - 1)) test(x + 1, y - 1, field);
          if(y < sizeH - 1 && testCorner(x, y, x + 1, y + 1)) test(x + 1, y + 1, field);
        }
      }
      else {
        next.clear();
        ArrayList<Field> _new = next;
        next = newNext;
        newNext = _new;
      }
    //}}
  }
  
  public void goal(int x, int y) {
    goal(fields[x][y]);
  }
  
  private Field getSmallest(ArrayList<Field> fields) {
    Field field = null;
    
    for(int i = 0; i < fields.size(); i++) {
      if(fields.get(i) == null || !fields.get(i).translucent) continue;
      
      if(field == null) field = fields.get(i);
      else if(field.distance > fields.get(i).distance) field = fields.get(i);
    }
    
    fields.clear();
    
    return field;
  }
  
  public void goal(Field field) {
    for(int x = 0; x < sizeW; x++) {
      for(int y = 0; y < sizeH; y++) {
        fields[x][y].visited = false;
      }
    }
    
    field.pre = null;
    field.distance = 0;
    
    next.clear();
    next.add(field);
    
    while(next.size() > 0 || newNext.size() > 0) step();
    
    ArrayList<Field> smallest = new ArrayList<Field>();
    for(int x = 0; x < sizeW; x++) {
      for(int y = 0; y < sizeH; y++) {
        if(x > 0) smallest.add(fields[x - 1][y]);
        if(x < sizeW - 1) smallest.add(fields[x + 1][y]);
        if(y > 0) smallest.add(fields[x][y - 1]);
        if(y < sizeH - 1) smallest.add(fields[x][y + 1]);
        
        if(x > 0) {
          if(y > 0 && testCorner(x, y, x - 1, y - 1)) smallest.add(fields[x - 1][y - 1]);
          if(y < sizeH - 1 && testCorner(x, y, x - 1, y + 1)) smallest.add(fields[x - 1][y + 1]);
        }
        if(x < sizeW - 1) {
          if(y > 0 && testCorner(x, y, x + 1, y - 1)) smallest.add(fields[x + 1][y - 1]);
          if(y < sizeH - 1 && testCorner(x, y, x + 1, y + 1)) smallest.add(fields[x + 1][y + 1]);
        }
        
        Field small = getSmallest(smallest);
        fields[x][y].updateDir(small);
      }
    }
  }
}