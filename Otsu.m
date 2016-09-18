function[]=Otsu(file_name)
close all;               % to close all the existing windows
figure;
img=imread(file_name);% reads the image and stores it in img
img1=imresize(img,[768 1024]);% will resize the image where row=768 and col=1024
imshow(img1);                 % displays the image
title('Original Image');
img1=0.2989*img1(:,:,1) + 0.5870*img1(:,:,2) + 0.1140*img1(:,:,3); %original image to gray scale image

%computing histogram :
T=0;%Thershold Value
[r,c]=size(img1);
value=zeros(1,256);
for i=1:r
    for j=1:c
       value(img1(i,j)+1)=value(img1(i,j)+1)+1;
    end
end

pdf=value./(r*c); %Probability Density Function calculated
final=zeros(1,255);

while ~(T==255)
     
       sum1=0;
       sum2=0;
       mean1=0;
       mean2=0;
       var1=0;
       var2=0;
   %Sum calculated for every cycle 
   for k=1:256
         if k>T  %If the value is greater than T then it will add it to sum2
           sum2=sum2+value(k);
          else
           sum1=sum1+value(k);
        end
   end  
   %Mean calculated for every cycle
   for l=1:256
       if l>T
           mean2=mean2+((l*value(l))/sum2);
       else
           mean1=mean1+((l*value(l))/sum1);
       end
   end 
    
   %Variance calculated for every cycle
   for m=1:256

       if m>T
           var2=var2+((m-mean2)*(m-mean2))*(value(m)/sum2);
       else
           var1=var1+((m-mean1)*(m-mean1))*(value(m)/sum1);
       end
    end
   
   var3=(sum1*var1)+(sum2*var2);
   final(T+1)=var3;
   T=T+1;

end
min_arr=find(final==(min(final))); 
val=(min_arr-1)/256;
disp(['Ideal Threshold Value :' num2str(val)]);
figure;
im=im2bw(img1,val);%Converting image to binary
imshow(im);
title('After Otsu Implements');