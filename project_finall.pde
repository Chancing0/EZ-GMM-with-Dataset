void setup() {
  println("here setup");
  int nums=310;
  String sample_path_old="C:\\Users\\chanc\\Desktop\\project_finall\\samples";
  String sample_path="VideoP";
  String Save_path="samples";
  String BG_path="background.png";
  String FG_path="FG";
  float lambda=300;
  float alpha=0.8;
  int[] Threshold=new int[3];Threshold[0]=50;Threshold[1]=50;Threshold[2]=50;
//  ReName_Samples(nums, sample_path_old,Save_path);
//  Guss_Background(nums, lambda, alpha, sample_path, BG_path);
  BFDivided(nums, sample_path, BG_path, FG_path,Threshold);
  println("finish");
}
void Guss_Background(int filenums, float lambda, float alpha, String samples_path, String BG_path) {
  println("here is Guss Background Image bultding");
  PImage Video = loadImage(samples_path+"\\1.png");
  PImage background = createImage(Video.width, Video.height, RGB);
  background.loadPixels();
  float [][][] parameter = new float [Video.width][Video.height][6];
  for (int i=1; i<=filenums; i++) {
    Video=loadImage(samples_path+"\\"+str(i)+".png");
    for (int w = 0; w<Video.width; w++) {
      for (int h = 0; h<Video.height; h++) {
        int local=w+h*Video.width;
        if (i==1) {
          parameter[w][h][0]=red(Video.pixels[local]);
          parameter[w][h][1]=20;
          parameter[w][h][2]=green(Video.pixels[local]);
          parameter[w][h][3]=20;
          parameter[w][h][4]=blue(Video.pixels[local]);
          parameter[w][h][5]=20;
        } else {
          if (abs(red(Video.pixels[local]) - parameter[w][h][0])<(lambda*parameter[w][h][1]) && 
            abs(green(Video.pixels[local]) - parameter[w][h][2])<(lambda*parameter[w][h][3]) &&
            abs(blue(Video.pixels[local]) - parameter[w][h][4])<(lambda*parameter[w][h][5]))
          {
            background.pixels[local] = Video.pixels[local];
            parameter[w][h][0] = (1-alpha)*parameter[w][h][0]+alpha*red(Video.pixels[local]);
            float beta = (red(Video.pixels[local])-parameter[w][h][0]);
            parameter[w][h][1] = sqrt((1-alpha)*parameter[w][h][1]*parameter[w][h][1]+alpha*beta*beta);

            parameter[w][h][2] = (1-alpha)*parameter[w][h][2]+alpha*green(Video.pixels[local]);
            beta = (green(Video.pixels[local])-parameter[w][h][2]);
            parameter[w][h][3] = sqrt((1-alpha)*parameter[w][h][3]*parameter[w][h][3]+alpha*beta*beta);

            parameter[w][h][4] = (1-alpha)*parameter[w][h][4]+alpha*blue(Video.pixels[local]);
            beta = (blue(Video.pixels[local])-parameter[w][h][4]);
            parameter[w][h][5] = sqrt((1-alpha)*parameter[w][h][5]*parameter[w][h][5]+alpha*beta*beta);
          }
        }
      }
    }
  }
  background.save(BG_path);
}
void BFDivided(int filenums, String samples_path, String BG_path, String PG_path, int[] Threshold) {
  PImage background=loadImage(BG_path);
  PImage frontground = createImage(background.width, background.height, RGB);
  PImage Video;
  println("here BFDivided");
  for (int i=1; i<=filenums; i++) {
    Video=loadImage(samples_path+"\\"+str(i)+".png");
    for (int w = 0; w<background.width; w++) {
      for (int h = 0; h<background.height; h++) {
        int local=w+h*background.width;
        if (abs(red(Video.pixels[local])-red(background.pixels[local])) <= Threshold[0] &&
          abs(green(Video.pixels[local])-green(background.pixels[local])) <= Threshold[1] &&
          abs(blue(Video.pixels[local])-blue(background.pixels[local])) <= Threshold[2])
          frontground.pixels[local] = color(0, 0, 0);
        else
          frontground.pixels[local] = Video.pixels[local];
      }
    }
    frontground.save(PG_path+"\\"+str(i)+".png");
  }
}
//Below PreProcesse is depent on your data's name and path
void ReName_Samples(int numbers, String Samples_path,String Save_path){
  println("Here is ReName the dataset");
  PImage Image;
  String zeros;
  for (int i=1; i<=numbers; i++) {
  if(i<10)
    zeros="000";
  else if(10<=i&&i<100)
    zeros="00";
  else
    zeros="0";
  Image=loadImage(Samples_path+"\\"+zeros+str(i)+".jpg");//you could change it before running
  Image.save(Save_path+"\\"+str(i)+".png");
  }
}