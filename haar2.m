function []=haar2(file_name)
close all; % to close all the existing windows
a=imread(file_name);% reads the image and stores it in img
a=double(a);
[r,c]=size(a);
j=a;
h=0;
k12=0;
while h<r 
    h=power(2,k12);
    k12=k12+1;
end
for k=1:length(a)
  n=length(a);
 for counter=1:k12-1
    diff2=(n/2)+1;
    i=1;
    i1=1;
    while(i<n+1)
        diff1=0;
        avg=0;
        avg=((a(k,i)+a(k,i+1))/2);
        diff1=a(k,i)-avg;
        j(k,i1)=avg;
        j(k,diff2)=diff1;
        i=i+2;
        i1=i1+1;
        diff2=diff2+1;
    end
    a=j;
    n=n/2;
end
end
b=a;
a=a';
%Column Transformation
j=a;
for k=1:length(a)
 n=length(a);
 for counter=1:k12-1
    diff2=(n/2)+1;
    i=1;
    i1=1;
   while(i<n+1)
        diff1=0;
        avg=0;
        avg=((a(k,i)+a(k,i+1))/2);
        diff1=a(k,i)-avg;
        j(k,i1)=avg;
        j(k,diff2)=diff1;
        i=i+2;
        i1=i1+1;
        diff2=diff2+1;
    end
    a=j;
    n=n/2;
end
end

a=a';
b2=a;

thershold=5;%the thersholding value
for k=1:length(a)
    for i=1:length(a);
        if(abs(a(k,i))  <thershold)
            a(k,i)=0;
        end
    end
end
%Inverse Wavelength Transformation
b1=a;
b123=b1';
mat=b123;
a=b123;
j=a;
 for k=1:length(a)
  n=1;
  for counter=1:k12-1
    diff2=(n+1);
    i=1;
    i1=1;
    while(i<n+1)
        add=0;
        sub=0;
        add=((a(k,i)+a(k,diff2)));
        sub=a(k,i)-a(k,diff2);
        j(k,i1)=add;
        j(k,i1+1)=sub;
        i=i+1;
        i1=i1+2;
        diff2=diff2+1;
    end
    a=j;
    n=n*2;
 end
end
a=a';
j=a;
 for k=1:length(a)
  n=1;
  for counter=1:k12-1
    diff2=(n+1);
    i=1;
    i1=1;
    while(i<n+1)
        add=0;
        sub=0;
        add=((a(k,i)+a(k,diff2)));
        sub=a(k,i)-a(k,diff2);
        j(k,i1)=add;
        j(k,i1+1)=sub;
        i=i+1;
        i1=i1+2;
        diff2=diff2+1;
    end
    a=j;
    n=n*2;
 end
 end
 imshow(uint8(a));

final=uint8(a);
imwrite(final,'Buttress.jpg');
imshow(final);
title('COMPRESSED IMAGE');
end