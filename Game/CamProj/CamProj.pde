import java.util.Collections;

import processing.video.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

Capture cam;
PImage img;
PImage image;
PImage hue_tresh;
PImage int_tresh;
PImage sobel;
PImage blurred;

int image_length = 1200;
int image_height = 400;

float discretizationStepsPhi = 0.06f;
float discretizationStepsR = 2.5f;
int phiDim = (int) (Math.PI / discretizationStepsPhi);
int rDim =  (int) (((image_length + image_height) * 2 + 1) / discretizationStepsR);
float[] tabSin = new float[phiDim];
float[] tabCos = new float[phiDim];
  

void settings() {
size(image_length, image_height);
pre_compute(tabSin, tabCos);
}
void setup() {
image = loadImage("board2.jpg");
image.resize(400,400);

String[] cameras = Capture.list();
if (cameras.length == 0) {
  println("There are no cameras available for capture.");
  exit();
} else {
  println("Available cameras:");
  for (int i = 0; i < cameras.length; i++) {
    println(cameras[i]);
   }
  cam = new Capture(this, cameras[0]);
  cam.start();
  }
}
void draw() {
if (cam.available() == true) {
cam.read();
}
//img = cam.get();
hue_tresh = hue_thresholding(image);
blurred = gaussian_blur(hue_tresh);
int_tresh = intensity_tresholding(blurred);
sobel = sobel(int_tresh);
image(image, 0, 0);
hough(sobel, 4);
image(sobel,800,0);

}

PImage hue_thresholding(PImage img){
   PImage result = createImage(img.width, img.height, ALPHA);
   loadPixels();
   for (int i = 0; i < (img.width*img.height); ++i){
   result.pixels[i] = color(255);
   float b = brightness(img.pixels[i]);
   float s = saturation(img.pixels[i]);
   float h = hue(img.pixels[i]);
   //correspond a l'image de la plaque en jpeg
   if(h > 50 && h < 140){
      if(b > 20){
        if(s > 60){
          result.pixels[i] = color(0);
        }
      }
    }
    else{
      result.pixels[i] = color(255);
    }
  }
  updatePixels();
  return result;
}

PImage intensity_tresholding(PImage img){
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < (img.width*img.height); ++i){
    result.pixels[i] = color(255);
    float h = hue(img.pixels[i]);
    if (h > 80 && h < 130){
      result.pixels[i] = color(0);
    }
    else {
      result.pixels[i] = color(255);
    }
  }
  return result;
}

PImage sobel(PImage img) {
float[][] hKernel = { { 0, 1, 0 },
{ 0, 0, 0 },
{ 0, -1, 0 } };
float[][] vKernel = { { 0, 0, 0 },
{ 1, 0, -1 },
{ 0, 0, 0 } };
float weight = 1.f;

PImage result = createImage(img.width, img.height, ALPHA);
// clear the image
for (int i = 0; i < img.width * img.height; i++) {
result.pixels[i] = color(0);
}
float max=0;
float[] buffer = new float[img.width * img.height];

for (int i = 1; i < img.height -1; ++i){
  for (int j = 1; j < img.width -1; ++j){
    float sum_h = 0;
    float sum_v = 0;
    float result_pixel = 0;
    for (int k = -1; k <=1 ; ++k){
      for (int l = -1; l <=1 ; ++l){
        sum_h += img.pixels[j+l + (i+k)*img.width] * hKernel[l+1][k+1];
        sum_v += img.pixels[j+l + (i+k)*img.width] * vKernel[l+1][k+1];
      }
    }
    sum_h = sum_h/weight;
    sum_v = sum_v/weight;
    result_pixel = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
    if (result_pixel > max){
      max = result_pixel;
    }
    buffer[j + i*img.width] = result_pixel;
  }
}

for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
for (int x = 2; x < img.width - 2; x++) { // Skip left and right
if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
result.pixels[y * img.width + x] = color(250);
} else {
result.pixels[y * img.width + x] = color(0);
}
}
}
return result;
}

PImage gaussian_blur(PImage img){
  float[][] kernel = { { 0.09, 0.11, 0.09 },
   { 0.11, 0.15, 0.11 },
  { 0.09, 0.11, 0.09 } };
  float weight = 1.f;
  PImage result = createImage(img.width, img.height, RGB); 
  for (int i = 1; i < img.height -1; ++i){
  for (int j = 1; j < img.width -1; ++j){
    float result_value = 0;
    for (int k = -1; k <=1 ; ++k){
      for (int l = -1; l <=1 ; ++l){
        result_value += img.pixels[j+l + (i+k)*img.width] * kernel[l+1][k+1];
      }
    }
    result.pixels[i*img.width + j] = color((int)(result_value/weight));
  }
  }
  return result;
}

void hough(PImage edgeImg, int nLines) {

  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        list_candidates(accumulator, x, y);
      }
    }
  }
   //pour obtenir les lignes les plus voté
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
  
  int neighbourhood = 10;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  int minVotes = 100;
choose_best_candidates(accumulator, minVotes, neighbourhood, bestCandidates);
Collections.sort(bestCandidates, new HoughComparator(accumulator));
  
  // a continuer
ArrayList<PVector> lines = new ArrayList<PVector>();
  
plot_the_lines(nLines, bestCandidates, lines, edgeImg);
quad_build(lines, edgeImg);

lines = getIntersections(lines); 

  //display the accumulator
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
 houghImg.resize(400, 400);
 houghImg.updatePixels();
 image(houghImg, 400,0);
}

ArrayList<PVector> getIntersections(List<PVector> lines){
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
        PVector line1 = lines.get(i);
        for (int j = i + 1; j < lines.size(); j++) {
            PVector line2 = lines.get(j);
            float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
            float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y))/d;
            float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y))/d;
            
            PVector result = new PVector(x,y);
            intersections.add(result);
            // compute the intersection and add it to ’intersections’
            // draw the intersection
            fill(255, 128, 0);
            ellipse(x, y, 10, 10);
        }
    }
  return intersections;
}
PVector intersection (PVector line1, PVector line2){
   float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
   float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y))/d;
   float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y))/d;
   PVector result = new PVector(x,y);
   return result;
}
void pre_compute(float[] tabSin, float[] tabCos){
 
    float ang = 0;
    float inverseR = (1.f / discretizationStepsR);
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
}

void list_candidates(int accumulator[], int x, int y) {
for (int phi = 0; phi < phiDim; phi++ ) {
  int rIndex = (int)((tabCos[phi]*x) +(tabSin[phi]*y));
  rIndex += (rDim-1)/2;
  accumulator[((phi+1)*(rDim+2)) + (rIndex+1)] += 1;
}
}

void choose_best_candidates(int accumulator[], int minVotes, int neighbourhood, ArrayList<Integer> bestCandidates) {
  for (int accR = 0; accR < rDim; accR++) {
  for (int accPhi = 0; accPhi < phiDim; accPhi++) {
    // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for(int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for(int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
        // check we are not outside the image
            if(accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
                if(accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
                  bestCandidate=false;
                  break;
                }
          }
    
        if(!bestCandidate) break;
        }
      if(bestCandidate) {
    // the current idx *is* a local maximum
      bestCandidates.add(idx);
      }
    }
  }
}
}

void plot_the_lines(int nLines, ArrayList<Integer> bestCandidates, ArrayList<PVector> lines, PImage edgeImg) {
    int max = min(nLines, bestCandidates.size());

  for (int i = 0; i < max; i++) {
    int idx = bestCandidates.get(i);
   
      int accPhi = (int) (idx / (rDim + 2)) - 1;
     
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
     
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
     
      float phi = accPhi * discretizationStepsPhi;
      PVector tmp = new PVector(r, phi);
      lines.add(tmp);
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      //int y0 = (int)(r/tabSin[accPhi]);
      int x1 = (int) (r / cos(phi));
      //int x1 = (int) (r / tabCos[accPhi]);
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      //int y2 = (int) (-(y0/x1) * x2 + y0);
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      //int x3 = (int) (-(y3 - y0) * (x1/y0));

       
      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
  }
}

void quad_build(ArrayList<PVector> lines, PImage edgeImg) {
 QuadGraph Quad = new QuadGraph();
  Quad.build(lines, edgeImg.width, edgeImg.height);
  List<int[]> quads = Quad.findCycles();
  
  
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
   
      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);
      // Choose a random, semi-transparent colour
    
      /*Random random = new Random();
      fill(color(min(255, random.nextInt(300)),
      min(255, random.nextInt(300)),
      min(255, random.nextInt(300)), 50));*/
      fill(180, 50, 100, 180);
      quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
 
  }
}