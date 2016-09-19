function[]=assignment1(file_name)
close all;                  % to close all the existing windows
img=imread(file_name);  % reads the image and stores it in img

figure;                     % opens a new window
imshow(img);                % displays the image
title('NAME : Aishwarya Desai ORIGINAL IMAGE');
impixelinfo;                % gives us the pixel count
imwrite(img,'Flowers.jpeg');% to change image format
figure;
imshow(img);
title('NAME : Aishwarya Desai IMAGE converted to JPEG');

%original image to gray scale image
img1 = 0.2989*img(:,:,1) + 0.5870*img(:,:,2) + 0.1140*img(:,:,3);
figure;
imshow(img1);
title('GRAY SCALE IMAGE');

%gray scale image to binary image
binary_image=im2bw(img1,0.6);
figure;
imshow(binary_image);
title('BINARY IMAGE');

red=img;
green=img;
blue=img;

figure;
subplot(3,3,1);% divides the current figure into an m-by-n grid and creates an axes for a subplot in the position specified by p. 
imshow(img);
title('ORIGINAL IMAGE');

subplot(3,3,2);
imshow(img1);
title('GRAY SCALE');


%red :
red(:,:,1);
red(:,:,2)=0;
red(:,:,3)=0;

subplot(3,3,3);
imshow(red);
title('RED CHANNEL');


%green :
green(:,:,1)=0;
green(:,:,2);
green(:,:,3)=0;

subplot(3,3,4);
imshow(green);
title('GREEN CHANNEL');


%blue:
blue(:,:,1)=0;
blue(:,:,2)=0;
blue(:,:,3);

subplot(3,3,5);
imshow(blue);
title('BLUE CHANNEL');

subplot(3,3,6);
imshow(binary_image);
title('BINARY IMAGE');

%Arithmetic Operations :
subplot(3,3,7);
newimage1=(img .*(((blue*2)-(green*10))+(red/5)).^3);
imshow(newimage1);
title('ARITHMETIC IMAGE 1');

subplot(3,3,8);
newimage2=img + ((red*10)+(green/2)+(blue-5));
imshow(newimage2);
title('ARITHMETIC IMAGE 2');

img2=imread('minions.jpg');
img2=imresize(img2, [768 1024]);
newimage=double(img-img2);
subplot(3,3,9);
imshow(newimage);
title('ARITHMETIC IMAGE 3');
figure;
imshow(newimage);

figure;
subplot(1,2,1);
imshow(img);
title('Input Image A');
subplot(1,2,2);
[m,n]=size(img1);

%computing histogram :

total=m*n;
histogram_matrix=zeros(256,1);
pdf=zeros(256,1);
cdf=zeros(256,1);
cum=zeros(256,1);

for i=1:m
    for j=1:n
        value=img1(i,j);
    histogram_matrix(value+1)=(histogram_matrix(value+1)+1); %occurances of each pixel stored in histogram_matrix
    pdf(value+1)=histogram_matrix(value+1)/total;            %Probability Density Function calculated
    end
end

plot(histogram_matrix); %displaying the histogram       
title('Histogram Image B');

figure;
plot(pdf);%displaying the PDF    
title('PDF');


figure;
sum=0; 

for i=1:size(pdf)
  sum=sum+histogram_matrix(i);
  cum(i)=sum;
  cdf(i)=cum(i)/total;%CDF calculated
  
end 
plot(cdf);%displaying the CDF  
title('CDF');

%histogram equilization :
image_hist=imread('highway.png');
image_hist=imresize(image_hist, [768 1024]);
image_hist1= 0.2989*image_hist(:,:,1) + 0.5870*image_hist(:,:,2) + 0.1140*image_hist(:,:,3);
[m1,n1]=size(image_hist1);
hist_equi=zeros(256,1);
matrix1=(zeros(m,n));
matrix1=uint8(matrix1);
pdf1=zeros(256,1);
cdf1=zeros(256,1);
cum1=zeros(256,1);
out=zeros(256,1);

total1=m1*n1;

for i=1:m1
    for j=1:n1
      value1=image_hist1(i,j);
      hist_equi(value1+1)=(hist_equi(value1+1)+1);
      pdf1(value1+1)=hist_equi(value1+1)/total1;
    end
end    

sum1=0;L=255;

for i=1:size(pdf1)
  sum1=sum1+hist_equi(i);
  cum1(i)=sum1;
  cdf1(i)=cum1(i)/total1;
  
end 
out=cdf1.*L;
for i=1:m1
    for j=1:n1
    matrix1(i,j)=out(image_hist1(i,j)+1);
    end
end


figure;
subplot(1,2,1);
imshow(adapthisteq(rgb2gray(image_hist)));
title('ORIGINAL IMAGE');

subplot(1,2,2);
imshow(matrix1);

title('IMAGE AFTER HISTOGRAM EQUILIZATION');
end
