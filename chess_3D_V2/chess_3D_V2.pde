ArrayList<Piece> white;
ArrayList<Piece> black;
boolean[] keys;
PVector r3d;
float d;
Pos cursor;
boolean first;
int selected;
PrintWriter output;

String load="201909060211";

void setup() {
  fullScreen(P3D);
  //size(780, 360, P3D);
  colorMode(RGB, 1);
  perspective(PI/3, (float)width/height, 0.1, Float.MAX_VALUE);
  sphereDetail(12, 6);
  hint(ENABLE_DEPTH_TEST); 
  keys=new boolean[10];
  cursor=new Pos(0, 7, 0);
  first=true;
  selected=-1;

  d=20;
  r3d=new PVector(0, HALF_PI, height/2.0/tan(PI/6)-12*d);

  white=new ArrayList<Piece>();
  black=new ArrayList<Piece>();

  load="0";
  if (load.length()>3) {
    String[] lines=loadStrings("saved_games/"+load+".txt");
    int w=int(lines[0]);
    for (int i=0; i<w; i++) {
      String[] l=lines[i+1].split(" ");
      white.add(new Piece(l[0].charAt(0), new Pos(int(l[1]), int(l[2]), int(l[3]))));
    }
    int b=int(lines[w+1]);
    for (int i=0; i<b; i++) {
      String[] l=lines[i+w+2].split(" ");
      black.add(new Piece(l[0].charAt(0), new Pos(int(l[1]), int(l[2]), int(l[3]))));
    }
  } else {
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        white.add(new Piece('p', new Pos(x, y, 1)));
        black.add(new Piece('p', new Pos(x, y, 6)));
      }
    }
    boolean[][] b=new boolean[8][8];
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        for (int i=0; i<4; i++) {
          if (!(b[x][y])) {
            if (x==i||y==i||x==7-i||y==7-i) {
              switch(i) {
              case 0:
                white.add(new Piece('r', new Pos(x, y, 0)));
                break;
              case 1:
                white.add(new Piece('k', new Pos(x, y, 0)));
                break;
              case 2:
                white.add(new Piece('b', new Pos(x, y, 0)));
                break;
              case 3:
                white.add(new Piece('q', new Pos(x, y, 0)));
                break;
              }
              b[x][y]=true;
            }
          }
        }
      }
    }
    white.remove(91);
    white.add(0, new Piece('K', new Pos(3, 3, 0)));

    b=new boolean[8][8];
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        for (int i=0; i<4; i++) {
          if (!(b[x][y])) {
            if (x==i||y==i||x==7-i||y==7-i) {
              switch(i) {
              case 0:
                black.add(new Piece('r', new Pos(x, y, 7)));
                break;
              case 1:
                black.add(new Piece('k', new Pos(x, y, 7)));
                break;
              case 2:
                black.add(new Piece('b', new Pos(x, y, 7)));
                break;
              case 3:
                black.add(new Piece('q', new Pos(x, y, 7)));
                break;
              }
              b[x][y]=true;
            }
          }
        }
      }
    }
    black.remove(91);
    black.add(0, new Piece('K', new Pos(3, 3, 7)));
  }
}

void draw() {
  if (frameCount%1==0) {
    for (int t=0; t<10; t++) {
      //randomStep();
    }
  }
  println(frameRate);
  //translate(width/8, 0);
  //camera(width/1, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  navigate();
  background(0);

  stroke(0, 1, 0);
  strokeWeight(2);
  noFill();
  box(8*d);

  stroke(1);
  strokeWeight(2);
  noFill();
  pushMatrix();
  translate(d*(cursor.x-3.5), d*(cursor.y-3.5), d*(cursor.z-3.5));
  box(d/1.5);
  popMatrix();

  if (keys[6]) {
    int xx, yy, zz;
    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      xx++;
      yy++;
    }
    xx--;
    yy--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 1);
      line(d*(cursor.x-3.5+1.0/3), d*(cursor.y-3.5+1.0/3), d*(cursor.z-3.5), d*(xx-3), d*(yy-3), d*(zz-3.5));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      xx--;
      yy++;
    }
    xx++;
    yy--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 1);
      line(d*(cursor.x-3.5-1.0/3), d*(cursor.y-3.5+1.0/3), d*(cursor.z-3.5), d*(xx-4), d*(yy-3), d*(zz-3.5));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      xx++;
      yy--;
    }
    xx--;
    yy++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 1);
      line(d*(cursor.x-3.5+1.0/3), d*(cursor.y-3.5-1.0/3), d*(cursor.z-3.5), d*(xx-3), d*(yy-4), d*(zz-3.5));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      xx--;
      yy--;
    }
    xx++;
    yy++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 1);
      line(d*(cursor.x-3.5-1.0/3), d*(cursor.y-3.5-1.0/3), d*(cursor.z-3.5), d*(xx-4), d*(yy-4), d*(zz-3.5));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      yy++;
      zz++;
    }
    yy--;
    zz--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(0, 0, 1);
      line(d*(cursor.x-3.5), d*(cursor.y-3.5+1.0/3), d*(cursor.z-3.5+1.0/3), d*(xx-3.5), d*(yy-3), d*(zz-3));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      yy--;
      zz++;
    }
    yy++;
    zz--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(0, 0, 1);
      line(d*(cursor.x-3.5), d*(cursor.y-3.5-1.0/3), d*(cursor.z-3.5+1.0/3), d*(xx-3.5), d*(yy-4), d*(zz-3));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      yy++;
      zz--;
    }
    yy--;
    zz++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 0);
      line(d*(cursor.x-3.5), d*(cursor.y-3.5+1.0/3), d*(cursor.z-3.5-1.0/3), d*(xx-3.5), d*(yy-3), d*(zz-4));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      yy--;
      zz--;
    }
    yy++;
    zz++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 0);
      line(d*(cursor.x-3.5), d*(cursor.y-3.5-1.0/3), d*(cursor.z-3.5-1.0/3), d*(xx-3.5), d*(yy-4), d*(zz-4));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      zz++;
      xx++;
    }
    zz--;
    xx--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(0, 0, 1);
      line(d*(cursor.x-3.5+1.0/3), d*(cursor.y-3.5), d*(cursor.z-3.5+1.0/3), d*(xx-3), d*(yy-3.5), d*(zz-3));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      zz--;
      xx++;
    }
    zz++;
    xx--;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 0);
      line(d*(cursor.x-3.5+1.0/3), d*(cursor.y-3.5), d*(cursor.z-3.5-1.0/3), d*(xx-3), d*(yy-3.5), d*(zz-4));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      zz++;
      xx--;
    }
    zz--;
    xx++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(0, 0, 1);
      line(d*(cursor.x-3.5-1.0/3), d*(cursor.y-3.5), d*(cursor.z-3.5+1.0/3), d*(xx-4), d*(yy-3.5), d*(zz-3));
    }

    xx=cursor.x;
    yy=cursor.y;
    zz=cursor.z;
    while (in(xx, yy, zz)) {
      zz--;
      xx--;
    }
    zz++;
    xx++;
    if (!cursor.same(new Pos(xx, yy, zz))) {
      stroke(1, 0, 0);
      line(d*(cursor.x-3.5-1.0/3), d*(cursor.y-3.5), d*(cursor.z-3.5-1.0/3), d*(xx-4), d*(yy-3.5), d*(zz-4));
    }
  } else {
    line(d*(cursor.x-4), d*(cursor.y-3.5), d*(cursor.z-3.5), -4*d, d*(cursor.y-3.5), d*(cursor.z-3.5));
    line(d*(cursor.x-3), d*(cursor.y-3.5), d*(cursor.z-3.5), 4*d, d*(cursor.y-3.5), d*(cursor.z-3.5));
    line(d*(cursor.x-3.5), d*(cursor.y-4), d*(cursor.z-3.5), d*(cursor.x-3.5), -4*d, d*(cursor.z-3.5));
    line(d*(cursor.x-3.5), d*(cursor.y-3), d*(cursor.z-3.5), d*(cursor.x-3.5), 4*d, d*(cursor.z-3.5));
    line(d*(cursor.x-3.5), d*(cursor.y-3.5), d*(cursor.z-4), d*(cursor.x-3.5), d*(cursor.y-3.5), -4*d);
    line(d*(cursor.x-3.5), d*(cursor.y-3.5), d*(cursor.z-3), d*(cursor.x-3.5), d*(cursor.y-3.5), 4*d);
  }

  stroke(1, 0.7);
  strokeWeight(0.7);

  fill(0, 0, 1, 0.7);
  for (int i=0; i<white.size(); i++) {
    white.get(i).show();
  }
  fill(1, 0, 0, 0.7);
  for (int i=0; i<black.size(); i++) {
    black.get(i).show();
  }

  boolean[][][] b=new boolean[8][8][8];
  if (selected==-1) {
    if (first) {
      for (int i=0; i<white.size(); i++) {
        if (cursor.same(white.get(i).pos)) {
          b=canGo(i, true);
          break;
        }
      }
    } else {
      for (int i=0; i<black.size(); i++) {
        if (cursor.same(black.get(i).pos)) {
          b=canGo(i, false);
          break;
        }
      }
    }
  } else {
    if (first) {
      b=canGo(selected, true);
    } else {
      b=canGo(selected, false);
    }
  }
  fill(1, 0.5);
  for (int x=0; x<8; x++) {
    for (int y=0; y<8; y++) {
      for (int z=0; z<8; z++) {
        if (b[x][y][z]) {
          pushMatrix();
          translate(d*(x-3.5), d*(y-3.5), d*(z-3.5));
          box(d/2);
          popMatrix();
        }
      }
    }
  }
}

void randomStep() {
  if (first) {
    selected=int(random(white.size()));
    ArrayList<Integer> xx=new ArrayList<Integer>();
    ArrayList<Integer> yy=new ArrayList<Integer>();
    ArrayList<Integer> zz=new ArrayList<Integer>();
    boolean[][][] b=canGo(selected, true);
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        for (int z=0; z<8; z++) {
          if (b[x][y][z]) {
            xx.add(x);
            yy.add(y);
            zz.add(z);
          }
        }
      }
    }
    if (xx.size()>0) {
      int j=int(random(xx.size()));
      white.get(selected).pos=new Pos(xx.get(j), yy.get(j), zz.get(j));
      if (white.get(selected).type=='p'&&white.get(selected).pos.z==7) {
        white.get(selected).type='q';
      }
      for (int i=0; i<black.size(); i++) {
        if (new Pos(xx.get(j), yy.get(j), zz.get(j)).same(black.get(i).pos)) {
          black.remove(i);
          break;
        }
      }
      first=!first;
      selected=-1;
    }
  } else {
    selected=int(random(black.size()));
    ArrayList<Integer> xx=new ArrayList<Integer>();
    ArrayList<Integer> yy=new ArrayList<Integer>();
    ArrayList<Integer> zz=new ArrayList<Integer>();
    boolean[][][] b=canGo(selected, false);
    for (int x=0; x<8; x++) {
      for (int y=0; y<8; y++) {
        for (int z=0; z<8; z++) {
          if (b[x][y][z]) {
            xx.add(x);
            yy.add(y);
            zz.add(z);
          }
        }
      }
    }
    if (xx.size()>0) {
      int j=int(random(xx.size()));
      black.get(selected).pos=new Pos(xx.get(j), yy.get(j), zz.get(j));
      if (black.get(selected).type=='p'&&black.get(selected).pos.z==0) {
        black.get(selected).type='q';
      }
      for (int i=0; i<white.size(); i++) {
        if (new Pos(xx.get(j), yy.get(j), zz.get(j)).same(white.get(i).pos)) {
          white.remove(i);
          break;
        }
      }
      first=!first;
      selected=-1;
    }
  }
}

boolean[][][] canGo(int pi, boolean wh) {
  boolean[][][] b=new boolean[8][8][8];
  boolean[][][] m=new boolean[8][8][8];
  boolean[][][] o=new boolean[8][8][8];
  if (wh) {
    for (Piece p : white) {
      m[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : black) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    int x=white.get(pi).pos.x;
    int y=white.get(pi).pos.y;
    int z=white.get(pi).pos.z;

    int xx;
    int yy;
    int zz;
    switch(white.get(pi).type) {
    case 'p':
      z++;
      if (!m[x][y][z]&&!o[x][y][z]) {
        b[x][y][z]=true;
        z++;
        if (z==3&&!m[x][y][z]&&!o[x][y][z]) {
          b[x][y][z]=true;
        }
        z--;
      }
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (abs(i)+abs(j)==1) {
            if (in(x+i, y+j, z)) {
              if (o[x+i][y+j][z]) {
                b[x+i][y+j][z]=true;
              }
            }
          }
        }
      }
      break;
    case 'k':
      for (int i=-2; i<3; i++) {
        for (int j=-2; j<3; j++) {
          for (int k=-2; k<3; k++) {
            if (abs(i)+abs(j)+abs(k)==3) {
              if (abs(i)>1||abs(j)>1||abs(k)>1) {
                if (in(x+i, y+j, z+k)) {
                  if (!m[x+i][y+j][z+k]) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
      }
      break;
    case 'K':
      boolean[][][] a=attacked(false);
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          for (int k=-1; k<2; k++) {
            if (i!=0||j!=0||k!=0) {
              if (abs(i)+abs(j)+abs(k)<3) {
                if (in(x+i, y+j, z+k)) {
                  if (!m[x+i][y+j][z+k]) {
                    if (!a[x+i][y+j][z+k]) {
                      b[x+i][y+j][z+k]=true;
                    }
                  }
                }
              }
            }
          }
        }
      }
      break;
    case 'r':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    case 'b':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    case 'q':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }


      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    }

    Pos copy=white.get(pi).pos.clone();
    for (int i=0; i<8; i++) {
      for (int j=0; j<8; j++) {
        for (int k=0; k<8; k++) {
          if (b[i][j][k]) {
            white.get(pi).pos=new Pos(i, j, k);
            Piece pcopy=null;
            for (int l=0; l<black.size(); l++) {
              if (new Pos(i, j, k).same(black.get(l).pos)) {
                pcopy=black.get(l).clone();
                black.remove(l);
                break;
              }
            }
            boolean[][][] a=attacked(false);
            if (a[white.get(0).pos.x][white.get(0).pos.y][white.get(0).pos.z]) {
              b[i][j][k]=false;
            }
            if (pcopy!=null) {
              black.add(pcopy.clone());
            }
          }
        }
      }
    }
    white.get(pi).pos=copy;
  } else {
    for (Piece p : black) {
      m[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : white) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    int x=black.get(pi).pos.x;
    int y=black.get(pi).pos.y;
    int z=black.get(pi).pos.z;

    int xx;
    int yy;
    int zz;
    switch(black.get(pi).type) {
    case 'p':
      z--;
      if (!m[x][y][z]&&!o[x][y][z]) {
        b[x][y][z]=true;
        z--;
        if (z==4&&!m[x][y][z]&&!o[x][y][z]) {
          b[x][y][z]=true;
        }
        z++ ;
      }
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (abs(i)+abs(j)==1) {
            if (in(x+i, y+j, z)) {
              if (o[x+i][y+j][z]) {
                b[x+i][y+j][z]=true;
              }
            }
          }
        }
      }
      break;
    case 'k':
      for (int i=-2; i<3; i++) {
        for (int j=-2; j<3; j++) {
          for (int k=-2; k<3; k++) {
            if (abs(i)+abs(j)+abs(k)==3) {
              if (abs(i)>1||abs(j)>1||abs(k)>1) {
                if (in(x+i, y+j, z+k)) {
                  if (!m[x+i][y+j][z+k]) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
      }
      break;
    case 'K':
      boolean[][][] a=attacked(true);
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          for (int k=-1; k<2; k++) {
            if (i!=0||j!=0||k!=0) {
              if (abs(i)+abs(j)+abs(k)<3) {
                if (in(x+i, y+j, z+k)) {
                  if (!m[x+i][y+j][z+k]) {
                    if (!a[x+i][y+j][z+k]) {
                      b[x+i][y+j][z+k]=true;
                    }
                  }
                }
              }
            }
          }
        }
      }
      break;
    case 'r':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    case 'b':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    case 'q':
      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }


      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx++;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        xx--;
        yy--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy++;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        yy--;
        zz--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx++;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz++;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }

      xx=x;
      yy=y;
      zz=z;
      while (true) {
        zz--;
        xx--;
        if (in(xx, yy, zz)) {
          if (m[xx][yy][zz]) {
            break;
          }
          b[xx][yy][zz]=true;
        } else {
          break;
        }
        if (o[xx][yy][zz]) {
          break;
        }
      }
      break;
    }


    Pos copy=black.get(pi).pos.clone();
    for (int i=0; i<8; i++) {
      for (int j=0; j<8; j++) {
        for (int k=0; k<8; k++) {
          if (b[i][j][k]) {
            black.get(pi).pos=new Pos(i, j, k);
            Piece pcopy=null;
            for (int l=0; l<white.size(); l++) {
              if (new Pos(i, j, k).same(white.get(l).pos)) {
                pcopy=white.get(l).clone();
                white.remove(l);
                break;
              }
            }
            boolean[][][] a=attacked(true);
            if (a[black.get(0).pos.x][black.get(0).pos.y][black.get(0).pos.z]) {
              b[i][j][k]=false;
            }
            if (pcopy!=null) {
              white.add(pcopy.clone());
            }
          }
        }
      }
    }
    black.get(pi).pos=copy;
  }

  return b;
}

boolean[][][] attacked(boolean wh) {
  boolean[][][] b=new boolean[8][8][8];
  boolean[][][] o=new boolean[8][8][8];
  if (wh) {
    for (Piece p : white) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : black) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : white) {
      int x=p.pos.x;
      int y=p.pos.y;
      int z=p.pos.z;

      int xx;
      int yy;
      int zz;
      switch(p.type) {
      case 'p':
        z++;
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            if (abs(i)+abs(j)==1) {
              if (in(x+i, y+j, z)) {
                b[x+i][y+j][z]=true;
              }
            }
          }
        }
        break;
      case 'k':
        for (int i=-2; i<3; i++) {
          for (int j=-2; j<3; j++) {
            for (int k=-2; k<3; k++) {
              if (abs(i)+abs(j)+abs(k)==3) {
                if (abs(i)>1||abs(j)>1||abs(k)>1) {
                  if (in(x+i, y+j, z+k)) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
        break;
      case 'K':
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            for (int k=-1; k<2; k++) {
              if (i!=0||j!=0||k!=0) {
                if (abs(i)+abs(j)+abs(k)<3) {
                  if (in(x+i, y+j, z+k)) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
        break;
      case 'r':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      case 'b':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      case 'q':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }


        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      }
    }
  } else {
    for (Piece p : black) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : white) {
      o[p.pos.x][p.pos.y][p.pos.z]=true;
    }
    for (Piece p : black) {
      int x=p.pos.x;
      int y=p.pos.y;
      int z=p.pos.z;

      int xx;
      int yy;
      int zz;
      switch(p.type) {
      case 'p':
        z--;
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            if (abs(i)+abs(j)==1) {
              if (in(x+i, y+j, z)) {
                b[x+i][y+j][z]=true;
              }
            }
          }
        }
        break;
      case 'k':
        for (int i=-2; i<3; i++) {
          for (int j=-2; j<3; j++) {
            for (int k=-2; k<3; k++) {
              if (abs(i)+abs(j)+abs(k)==3) {
                if (abs(i)>1||abs(j)>1||abs(k)>1) {
                  if (in(x+i, y+j, z+k)) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
        break;
      case 'K':
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            for (int k=-1; k<2; k++) {
              if (i!=0||j!=0||k!=0) {
                if (abs(i)+abs(j)+abs(k)<3) {
                  if (in(x+i, y+j, z+k)) {
                    b[x+i][y+j][z+k]=true;
                  }
                }
              }
            }
          }
        }
        break;
      case 'r':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      case 'b':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      case 'q':
        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }


        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx++;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          xx--;
          yy--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy++;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          yy--;
          zz--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx++;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz++;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }

        xx=x;
        yy=y;
        zz=z;
        while (true) {
          zz--;
          xx--;
          if (in(xx, yy, zz)) {
            b[xx][yy][zz]=true;
          } else {
            break;
          }
          if (o[xx][yy][zz]) {
            break;
          }
        }
        break;
      }
    }
  }
  return b;
}

boolean in(int x, int y, int z) {
  return (x>=0&&x<8&&y>=0&&y<8&&z>=0&&z<8);
}

void navigate() {
  translate(width/2, height/2, r3d.z);
  float sc=15;
  rotateX(r3d.x);
  rotateY(r3d.y);
  if (keys[0]) {
    r3d.x-=sc/(width+height);
  }
  if (keys[1]) {
    r3d.x+=sc/(width+height);
  }
  if (keys[2]) {
    r3d.y-=sc/(width+height);
  }
  if (keys[3]) {
    r3d.y+=sc/(width+height);
  }
  if (keys[4]) {
    r3d.z++;
  }
  if (keys[5]) {
    r3d.z--;
  }
  r3d.x=constrain(r3d.x, -1.2, 1.2);
  r3d.y=(r3d.y+TWO_PI)%TWO_PI;
  r3d.z=constrain(r3d.z, height/2.0/tan(PI/6)-16*d, height/2.0/tan(PI/6)-1.5*d);
}

void keyPressed() {
  if (keyCode==32) {
    r3d.y=(r3d.y+PI)%TWO_PI;
  }
  if (key=='r') {
    r3d=new PVector(0, HALF_PI, height/2.0/tan(PI/6)-12*d);
  }

  if (key=='o'||key=='O') {
    cursor.y--;
  }
  if (key=='u'||key=='U') {
    cursor.y++;
  }
  if (key=='i'||key=='I') {
    int dir=int(((r3d.y+QUARTER_PI)%TWO_PI)/HALF_PI);
    switch(dir) {
    case 0:
      cursor.z--;
      break;
    case 1:
      cursor.x++;
      break;
    case 2:
      cursor.z++;
      break;
    case 3:
      cursor.x--;
      break;
    }
  }
  if (key=='k'||key=='K') {
    int dir=int(((r3d.y+QUARTER_PI)%TWO_PI)/HALF_PI);
    switch(dir) {
    case 0:
      cursor.z++;
      break;
    case 1:
      cursor.x--;
      break;
    case 2:
      cursor.z--;
      break;
    case 3:
      cursor.x++;
      break;
    }
  }
  if (key=='l'||key=='L') {
    int dir=int(((r3d.y+QUARTER_PI+HALF_PI)%TWO_PI)/HALF_PI);
    switch(dir) {
    case 0:
      cursor.z--;
      break;
    case 1:
      cursor.x++;
      break;
    case 2:
      cursor.z++;
      break;
    case 3:
      cursor.x--;
      break;
    }
  }
  if (key=='j'||key=='J') {
    int dir=int(((r3d.y+QUARTER_PI+HALF_PI)%TWO_PI)/HALF_PI);
    switch(dir) {
    case 0:
      cursor.z++;
      break;
    case 1:
      cursor.x--;
      break;
    case 2:
      cursor.z--;
      break;
    case 3:
      cursor.x++;
      break;
    }
  }
  cursor.x=(cursor.x+8)%8;
  cursor.y=(cursor.y+8)%8;
  cursor.z=(cursor.z+8)%8;

  if (keyCode==ENTER) {
    if (selected!=-1) {
      if (first) {
        if (cursor.same(white.get(selected).pos)) {
          selected=-1;
        } else {
          boolean[][][] b=canGo(selected, true);
          if (b[cursor.x][cursor.y][cursor.z]) {
            white.get(selected).pos=cursor.clone();
            if (white.get(selected).type=='p'&&white.get(selected).pos.z==7) {
              white.get(selected).type='q';
            }
            for (int i=0; i<black.size(); i++) {
              if (cursor.same(black.get(i).pos)) {
                black.remove(i);
                break;
              }
            }
            first=!first;
            selected=-1;
          }
        }
      } else {
        if (cursor.same(black.get(selected).pos)) {
          selected=-1;
        } else {
          boolean[][][] b=canGo(selected, false);
          if (b[cursor.x][cursor.y][cursor.z]) {
            black.get(selected).pos=cursor.clone();
            if (black.get(selected).type=='p'&&black.get(selected).pos.z==0) {
              black.get(selected).type='q';
            }
            for (int i=0; i<white.size(); i++) {
              if (cursor.same(white.get(i).pos)) {
                white.remove(i);
                break;
              }
            }
            first=!first;
            selected=-1;
          }
        }
      }
    } else {
      if (first) {
        for (int i=0; i<white.size(); i++) {
          if (cursor.same(white.get(i).pos)) {
            selected=i;
          }
        }
      } else {
        for (int i=0; i<black.size(); i++) {
          if (cursor.same(black.get(i).pos)) {
            selected=i;
          }
        }
      }
    }
  }

  if (key=='p'||key=='P') {
    output=createWriter("saved_games/"+nf(year(), 4)+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+".txt");
    output.println(white.size());
    for (int i=0; i<white.size(); i++) {
      output.println(white.get(i).asString());
    }
    output.println(black.size());
    for (int i=0; i<black.size(); i++) {
      output.println(black.get(i).asString());
    }
    output.flush();
    output.close();
  }


  if (key=='w'||key=='W') {
    keys[0]=true;
  } 
  if (key=='s'||key=='S') {
    keys[1]=true;
  } 
  if (key=='d'||key=='D') {
    keys[2]=true;
  } 
  if (key=='a'||key=='A') {
    keys[3]=true;
  }
  if (key=='e'||key=='E') {
    keys[4]=true;
  }
  if (key=='q'||key=='Q') {
    keys[5]=true;
  }
  if (keyCode==SHIFT) {
    keys[6]=true;
  }
}

void keyReleased() {
  if (key=='w'||key=='W') {
    keys[0]=false;
  } 
  if (key=='s'||key=='S') {
    keys[1]=false;
  } 
  if (key=='d'||key=='D') {
    keys[2]=false;
  } 
  if (key=='a'||key=='A') {
    keys[3]=false;
  }
  if (key=='e'||key=='E') {
    keys[4]=false;
  }
  if (key=='q'||key=='Q') {
    keys[5]=false;
  }
  if (keyCode==SHIFT) {
    keys[6]=false;
  }
}
