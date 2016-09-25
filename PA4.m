
%%%%%%MATLAB STUB%%%%%%%%%
%implement the TODOs then run the PA4 function from 
%the matlab command line simply with 'PA4' (make sure the Current
%Matlab folder on left has this file.
%
function PA4
img1= im2double(rgb2gray(imread('aerial1.jpg')));
img2= im2double(rgb2gray(imread('aerial2.jpg')));
imgspace=zeros(527,200);
imgspace(:,:)=255;
imgfinal=[img1,imgspace,img2];     %concatenation of the 2 images provided with an image for space

%allocate matrix to hold features1 and features 2
%HOG vecs are 128 length, and we are providing 5 keypoints
%each column will be a feature vector
features1 = zeros(128,5);
features2 = zeros(128,5);

keyPoints1 = [402 372;
371 230;
156 381;
419 231;
323 322];
  
keyPoints2 = [325 232;
300 90;
81 230;
348 94;
249 182];  
  
for i = 1:5
    curr = keyPoints1(i,:);
    features1(:,i) = HOG(img1,curr(1),curr(2));
    
    curr = keyPoints2(i,:);
    features2(:,i) = HOG(img2,curr(1),curr(2));
end
%TODO: print result in meaningful way,
%      unless using specified format, see matchFeatures description

result=matchFeatures(features1',features2',imgfinal,keyPoints1,keyPoints2);
number_ofpoints_given=[1,2,3,4,5];
disp('The matched features are :');
for i=1:length(result)
    if(~isempty(find(number_ofpoints_given==result(i,1), 1)))       
    disp([num2str(result(i,1)),' and ',num2str(result(i,2))]);
    end
end
end
%Function that calculates a 128 element Histogram of Gradients feature
%vector for a given keypoint (x,y) in the provided image.
%TODO: Run HOG algorithm centered around the point x,y and return the 
%      generated feature vector

function out_vec = HOG(img, x,y)
   close all;
[row,col]=size(img);
Gy = [1 +2 +1; 0 0 0; -1 -2 -1];            %sobel filter
Gx = Gy';
img_x=zeros(size(img));
img_y=zeros(size(img));
e=0.5;
%Intensity Gradients
for i=2:row-1
    for j=2:col-1
        temp=img(i-1:i+1,j-1:j+1);
        gx1=Gx.*temp;
        sum_x=sum(sum(gx1));
        img_x(i,j)=sum_x;
        
        gy1=Gy.*temp;
        sum_y=sum(sum(gy1));
        img_y(i,j)=sum_y;
    end
end
Gm=sqrt((img_x.^2)+(img_y.^2));             %magnitude of each pixel
Go=radtodeg(atan2(img_x,img_y))+180;        %orientation of each pixel
window=16;
bins=8;
step=8;
step1=4;
bin_number=zeros(1,bins);
i=x;
j=y;
magnitude=Gm(i-step:i+step,j-step:j+step);
angle=Go(i-step:i+step,j-step:j+step);
feature_vector1=[]; 
for m=0:step1:window-1
  for n=0:step1:window-1
     mag=magnitude(m+1:m+step1,n+1:n+step1);
     ang=angle(m+1:m+step1,n+1:n+step1);
      %binning
     for k=1:step1                         
       for l=1:step1
          if((ang(k,l)>=0)&&(ang(k,l)<=45)) 
             bin_number(1)=bin_number(1)+mag(k,l);
          end
          if((ang(k,l))>45)&&((ang(k,l)<=90))
             bin_number(2)=bin_number(2)+mag(k,l);
          end
          if((ang(k,l)>90)&&(ang(k,l)<=135))
             bin_number(3)=bin_number(3)+mag(k,l);
          end
          if((ang(k,l)>135)&&(ang(k,l)<=180))
             bin_number(4)=bin_number(4)+mag(k,l);
          end
          if((ang(k,l)>180)&&(ang(k,l)<=225))
             bin_number(5)=bin_number(5)+mag(k,l);
          end
          if((ang(k,l)>225)&&(ang(k,l)<=280))
             bin_number(6)=bin_number(6)+mag(k,l);
          end
          if((ang(k,l)>280)&&(ang(k,l)<=325))
             bin_number(7)=bin_number(7)+mag(k,l);
          end
          if((mag(k,l)>325)&&(mag(k,l)<=360))
             bin_number(8)=bin_number(8)+mag(k,l);
          end
       end
     end
     feature_vector1=[feature_vector1 bin_number];
  end
end
f1=sqrt((norm(feature_vector1).^2)+e.^2); %using L2 norm f1 is normalized form
f=feature_vector1/f1;
out_vec=f;
end

function out_indicies=matchFeatures(features1,features2,imgfinal,keyPoints1,keyPoints2)
   %Function that takes in a matrix with feature vectors as columns
   %dim(features1) = 128 by n = dim(features2)
   %where n is the number of feature vectors being compared.
   %Output should indicate which columns (indicies) are the best matches
   %between the features1 and features2. One possibility is 
   %dim(out_indicies) = n by 2, where n is the same as before. 
   %The first column could be the elements 1:n (indicies of columns of
   %features1), and then for each row the element in the second column is
   %the column index of the best match from features2.
   %Your output does not have to be exactly of this format, but should
   %clearly indicate which columns from features1 match with features2, if
   %not points will be deducted.
   %
   %TODO: Calculate the closest match for the vectors in the columns of
   %features1 to the columns of features2 and return the a matrix that
   %indicates the matched indicies.
   close all;    
   feature_norm_1=sqrt(sum(features1.^2));
   feature_normalized_1=features1/feature_norm_1; 
   feature_norm_2=sqrt(sum(features2.^2));
   feature_normalized_2=features2/feature_norm_2;
   a1=[];
   b1=[];
   temp=[];
   imshow(imgfinal);hold on;

   for i=1:length(feature_normalized_1)
     for j=1:length(feature_normalized_2)
       if((abs(feature_normalized_1(i)-feature_normalized_2(j))<0.0155)&&(i==j))
         if( (length(find(b1==j)))==0) 
           a1(i)=i;
           b1(i)=j;
           
           out_indicies(i,1)=i; 
           out_indicies(i,2)=j; 
           
           x1=keyPoints1(a1(i),1);
           y1=keyPoints1(a1(i),2);
     
           x2=keyPoints2(b1(i),1);
           y2=keyPoints2(b1(i),2);
           plot([x1 904+x2],[y1 y2],'G');
           break;
         end 
       end
    end
    if( (length(find(a1==i)))==0)
      temp(i)=i;
    end
        
   end 
 
  for i=1:length(temp)
    if temp(i)>0
       x1=keyPoints1(i,1);
       y1=keyPoints1(i,2);
     
       x2=keyPoints2(i,1);
       y2=keyPoints2(i,2);
       plot([x1 904+x2],[y1 y2],'R');
    end
    
  end
 
end

