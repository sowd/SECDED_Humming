// 4bit number binary encoding/decoding with 1-bit error correction
// and 2-bits error detection.

// toCode() takes at most 4-bit int num(<16) as parameter and returns 8bits array
//          as encoded bit pattern
// fromCode() takes noisy 8-bit pattern as input and outputs the recovered number.
//          If two bits are changed, this detects it and returns -1.

// http://sun.ac.jp/prof/hnagano/houkoku/h24information-09.html
// https://news.mynavi.jp/article/architecture-268/

int[] toCode(int num){
  int[] code = new int[8];
  for( int i=0;i<4;++i ){
    code[3-i] = num&1;
    num >>= 1 ;
  }
  
  code[4] = (code[0]+code[1]+code[2]        )%2 ;
  code[5] = (code[0]        +code[2]+code[3])%2 ;
  code[6] = (        code[1]+code[2]+code[3])%2 ;
  
  // all bits parity
  code[7] = 0;
  for( int i=0;i<7;++i ) code[7] += code[i] ;
  code[7] %= 2 ;

  return code ;
}

int fromCode(int[] code){
  int[] s = {
    (code[0]+code[1]+code[2]        +code[4]                )%2,
    (code[0]        +code[2]+code[3]        +code[5]        )%2,
    (        code[1]+code[2]+code[3]                +code[6])%2,
  };
  
  int er = s[0]*4+s[1]*2+s[2];

  int parity = 0 ;
  for( int i=0;i<8;++i ) parity += code[i] ;
  parity %= 2 ;
  
  if( parity == 0 && er != 0 ) // 2bits error.
    return -1 ;

  switch(er){
    case 6 : code[0] = 1-code[0]; break ;
    case 5 : code[1] = 1-code[1]; break ;
    case 7 : code[2] = 1-code[2]; break ;
    case 3 : code[3] = 1-code[3]; break ;
    case 0 :

    break ; // no error
  }
  
  int ret = 0 ;
  for( int i=0;i<4;++i ){
    ret <<= 1 ;
    ret |= code[i] ;
  }
  
  return ret ;
}

void setup(){

  for( int i=0;i<16;++i ){
    
    int[] b = toCode(i);
    
    // Shuffule at most 2 bits
    int r1 = (int)(random(7));
    b[r1] = 1-b[r1];

    int r2 = (int)(random(7));
    b[r2] = 1-b[r2];

    println( fromCode(b) );

  }

}