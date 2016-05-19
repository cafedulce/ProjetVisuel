PImage img;
PImage convolved;
PImage hue_convolved;
PImage blurred;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");
  //convolved = sobel(img);
  //hue_convolved = hue_tresholding(img);
  blurred = gaussian_blur(img);
  hue_convolved = hue_tresholding(blurred);
  convolved = sobel(hue_convolved);

  noLoop(); // no interactive behaviour: draw() will be called only once.
}
void draw() {
  image(convolved,0,0);
  hough(convolved);
  //image(convolved, 0, 0);
  //image(hue_convolved, 0, 0);
  //image(blurred, 0, 0);
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

  for (int i = 1; i < img.height -1; ++i) {
    for (int j = 1; j < img.width -1; ++j) {
      float sum_h = 0;
      float sum_v = 0;
      float result_pixel = 0;
      for (int k = -1; k <=1; ++k) {
        for (int l = -1; l <=1; ++l) {
          sum_h += img.pixels[j+l + (i+k)*img.width] * hKernel[l+1][k+1];
          sum_v += img.pixels[j+l + (i+k)*img.width] * vKernel[l+1][k+1];
        }
      }
      sum_h = sum_h/weight;
      sum_v = sum_v/weight;
      result_pixel = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      if (result_pixel > max) {
        max = result_pixel;
      }
      buffer[j + i*img.width] = result_pixel;
    }
  }

  // *************************************
  // Implement here the double convolution
  // *************************************
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}

PImage hue_tresholding(PImage img) {
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int i = 0; i < (img.width*img.height); ++i) {
    result.pixels[i] = color(0);
    if (img.pixels[i] > color(80)) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
  }
  return result;
}

PImage gaussian_blur(PImage img) {
  float[][] kernel = { { 0.09, 0.11, 0.09 }, 
    { 0.11, 0.15, 0.11 }, 
    { 0.09, 0.11, 0.09 } };
  float weight = 1.f;
  PImage result = createImage(img.width, img.height, RGB); 
  for (int i = 1; i < img.height -1; ++i) {
    for (int j = 1; j < img.width -1; ++j) {
      float result_value = 0;
      for (int k = -1; k <=1; ++k) {
        for (int l = -1; l <=1; ++l) {
          result_value += img.pixels[j+l + (i+k)*img.width] * kernel[l+1][k+1];
        }
      }
      result.pixels[i*img.width + j] = color((int)(result_value/weight));
    }
  }
  return result;
}

//algo de ouf

void hough(PImage edgeImg) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

        for (int phi = 0; phi < phiDim; phi++ ) {
          float r = (x*cos(phi*discretizationStepsPhi)) + (y*sin(phi*discretizationStepsPhi));
          int rIndex = (int)(r/discretizationStepsR);
            rIndex += (rDim-1)/2;
          accumulator[((phi+1)*(rDim+2)) + (rIndex+1)] += 1;
        }
      }
    }
  }
  PImage houghImg = createImage((rDim + 2), (phiDim + 2), ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(400, 400);
  //houghImg.updatePixels();
  image(houghImg, 0, 0);

  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 200) {
      println(accumulator[idx]);
      println(idx);
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      println(accPhi);
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      println(accR);
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      println(r);
      while (r < 0) {
        r += rDim/2;
      }
      println(r);
      float phi = accPhi * discretizationStepsPhi;
      println(phi);
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      println(x0, x1, x2, x3, y0, y1, y2, y3); 
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
}