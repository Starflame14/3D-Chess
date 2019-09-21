class Piece {
  char type;
  /*
  
   b - bishop
   K - King
   k - knight
   p - pawn
   q - queen
   r - rook
   
   */
  Pos pos;

  Piece(char type_, Pos pos_) {
    type=type_;
    pos=pos_.clone();
  }

  String asString() {
    return type+" "+pos.x+" "+pos.y+" "+pos.z;
  }

  void show() {
    pushMatrix();
    translate(d*(pos.x-3.5), d*(pos.y-3.5), d*(pos.z-3.5));
    switch(type) {
    case 'p':
      box(d/5);
      break;
    case 'k':
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          for (int k=-1; k<2; k++) {
            if (abs(i)+abs(j)+abs(k)<2) {
              pushMatrix();
              translate(d/5*i, d/5*j, d/5*k);
              box(d/5);
              popMatrix();
            }
          }
        }
      }
      break;
    case 'b':
      octa(d/3);
      break;
    case 'r':
      box(d/2.4);
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          for (int k=-1; k<2; k++) {
            if (abs(i)+abs(j)+abs(k)<2) {
              pushMatrix();
              translate(d/8*i, d/8*j, d/8*k);
              box(d/4);
              popMatrix();
            }
          }
        }
      }
      break;
    case 'q':
      octa(d/2.25);
      box(d/2);
      break;
    case 'K':
      sphere(d/2.25);
      break;
    }
    popMatrix();
  }

  void octa(float size) {
    size=size/sqrt(2);
    pushMatrix();
    rotateY(QUARTER_PI);
    for (int i=0; i<4; i++) {
      pushMatrix();
      translate(size, 0, 0);
      rotateY(HALF_PI);
      rotateX(PI+acos(1.0/3)/2);
      triangle(-size, 0, size, 0, 0, size*sqrt(3));
      popMatrix();
      rotateY(HALF_PI);
    }
    rotateX(PI);
    for (int i=0; i<4; i++) {
      pushMatrix();
      translate(size, 0, 0);
      rotateY(HALF_PI);
      rotateX(PI+acos(1.0/3)/2);
      triangle(-size, 0, size, 0, 0, size*sqrt(3));
      popMatrix();
      rotateY(HALF_PI);
    }
    popMatrix();
  }

  Piece clone() {
    return new Piece(type, pos.clone());
  }
}
