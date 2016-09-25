function hybridimage()

close all;   % to close all the existing windows
img=imread('Dog1.jpg');% reads the image and stores it in img
img=rgb2gray(img);% converts the rgb image to gray
figure;
imshow(img);
title('Dog');

a=zeros(1,512);
img=padarray(img,[75,51]);% padding the array
img=[img;a];

img1=imread('Cat1.jpg');
img1=rgb2gray(img1);
figure;
imshow(img1);
title('Cat');

img1=padarray(img1,[75,51]);
img1=[img1;a];

cat=cooley_tuckey(double(img1));
dog=cooley_tuckey(double(img));

[r,c]=size(cat);
filter = fspecial('gaussian',[r c],12);
[maxNumCol, ~] = max(filter);
[maxNum, ~] = max(maxNumCol);
filter=filter./maxNum;
low = dog.*(filter);
high = cat.*(1-filter);
hybrid_image = (low.*2) + (high.*3);

hy=log(abs(ifft(hybrid_image)));
[maxNumCol, ~] = max(hy);
 [maxNum, ~] = max(maxNumCol);
hy=hy./maxNum;
hy=imcrop(hy,[51 75 410 361]);
hy1=imadjust(hy);

figure;
imshow(hy1,[]);
title('Final');
end
%-----------COOLEY TUCKEY----------------------------------------------
function Y2=cooley_tuckey(X)

Y1=zeros(size(X));
[r,c]=size(X);
for i=1:r
    Y1(i,:)=cooley_tuckey1(X(i,:));
end
Y1=Y1';
for i=1:r
    Y2(i,:)=cooley_tuckey1(Y1(i,:));
end
 Y2=Y2';
 Y2=fftshif(Y2);
end

function Y=cooley_tuckey1(X)
N=length(X);
  if N==1
    Y(1)=X(1);
  else
    XE=X(1:2:N);
    Y(1:N/2)=cooley_tuckey1(XE);
    XO=X(2:2:N);
    Y((N/2+1):N)=cooley_tuckey1(XO);
    for k=1:N/2
        Twiddle_factor= (((2*pi*(-1i)*(k-1)))/N);
        temp=Y(k);
        Y(k) = temp + exp(Twiddle_factor)*Y(k+(N/2));
        Y(k+(N/2)) = temp -exp(Twiddle_factor)* Y(k+(N/2));
    end   
  end

end
%-----------FFTSHIFT----------------------------------------------
function Y12=fftshif(x1)
 [r,c]=size(x1);
for i=1:r
    Y121(i,:)=fftshif1(x1(i,:));
end
Y121=Y121';
for i=1:r
    Y12(i,:)=fftshif1(Y121(i,:));
end
Y12=Y12';
 end

function Y1=fftshif1(x1)
N=length(x1);
if N==1
    Y1(1)=x1(1);
else
    Y1=[x1((N/2)+1:N) x1(1:N/2)];
end
end

%-----------IFFTSHIFT----------------------------------------------
function Y21=iffshif(Y12)
x1=Y12;

[r,c]=size(x1);

for i=1:r
    Y21(i,:)=iffshif1(x1(i,:));
end


Y21=Y21';
for i=1:r
    Y12(i,:)=iffshif1(Y21(i,:));
end
Y12=Y12';
Y21=Y12;

end

function Y1=iffshif1(Y21)
x1=Y21;
N=length(x1);
if N==1
    Y1(1)=x1(1);
else
    Y1=[x1(1:N/2) x1((N/2)+1:N)];
end
end

%-----------IFFT----------------------------------------------
function Y1=ifft(X)
X=iffshif(X);
Y1=zeros(size(X));
[r,c]=size(X);

for i=1:r
    Y1(i,:)=ifft1(X(i,:));
end
Y1=Y1';
for i=1:r
    Y2(i,:)=ifft1(Y1(i,:));
  
end
Y2=Y2';
Y1=Y2; 
end

function Y2=ifft1(X)


N=length(X);

if N==1
    Y2(1)=X(1);
else
    XE=X(1:2:N);
    Y2(1:N/2)=ifft1(XE);
    XO=X(2:2:N);
    Y2((N/2+1):N)=ifft1(XO);
    for k=1:N/2
        Twiddle_factor= (((2*pi*(1i)*(k-1)))/N);
        temp=Y2(k);
        Y2(k) = temp + exp(Twiddle_factor)*Y2(k+(N/2));
        Y2(k+N/2) = temp -exp(Twiddle_factor)* Y2(k+(N/2));
        
    end
    
end
end
