class Pos {
  int x, y, z;

  Pos(int x_, int y_, int z_) {
    x=x_;
    y=y_;
    z=z_;
  }

  boolean same(Pos pos) {
    return pos.x==x&&pos.y==y&&pos.z==z;
  }

  Pos clone() {
    return new Pos(x, y, z);
  }
}
