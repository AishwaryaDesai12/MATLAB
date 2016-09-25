function CartoonImage
close all;      % to close all the existing windows
            
img= imread('castle.jpg');% reads the image and stores it in img
img = im2double(img);
bilat = bilateralFilter(img, 9, 5, 10);

matlabbilat = bfilter2(img, 4, 5, 10);
str = strcat('Bilateral Filter RMSE: ',int2str(RMSerror(bilat, matlabbilat)) );
str
edges = Canny(rgb2gray(img), 100, 200);
matlabedges = edge(rgb2gray(img),'canny');

str = strcat('Canny Edge RMSE: ',int2str(RMSerror(edges, matlabedges)) );
str
cartoon = cartoonImage(bilat, edges);
figure;
imshow(bilat);
title('BILATERAL');imwrite( bilat,'BilateralOutput.jpg');
figure;
imshow(edges);
title('CANNY');
imwrite(edges,'CannyOutput.jpg')
figure;
imshow( cartoon);
title('CARTOON');
imwrite( cartoon,'CartoonOutput.jpg');

end

%BILATERAL :

function I = bilateralFilter(img, kSize, sigmaColor, sigmaSpace)

imshow(img);         % displays the image
title('original ');
img1=padarray(img,[4,4],'circular'); % for padding the array
img2=rgb2lab(img1);             %converting it to LAB
final=0;
window_final=0;
l_colour = img2(:,:,1);
a_colour = img2(:,:,2);
b_colour = img2(:,:,3);
[r,c]=size(a_colour);
window_expFinal=zeros(size(a_colour));
final1=zeros(size(a_colour));
k=1:kSize-1;
l=1:kSize-1;
for i=1:r-4
    for j=1:c-4
        for k1=1:length(k)
            if((k(k1)<r-4) && (l(k1)<c-4))
                window1=-(((abs(l_colour(i,j))-(l_colour(k(k1),l(k1))))^2)/(2*(sigmaSpace^2)));
                window_exp1=exp(window1);
                window2=-(((a_colour(i)-a_colour(k(k1))).^2)+(b_colour(j)-b_colour(l(k1))).^2)/(2*sigmaColor^2);
                window_exp2=exp(window2);
                window_expFinal(i,j)=window_exp1+window_exp2;
                final=final+l_colour(i,j)*window_expFinal(i,j);
                window_final=window_final+window_expFinal(i,j);
                
            end
        end
        final1(i,j)=final/window_final;
        final=0;
        window_final=0;
    end
end

%cropping the image
img2(:,:,1)=final1;
img2(:,1:4,:)=[];
img2(r-4:end,:,:)=[];
img2(1:4,:,:)=[];
img2(:,c-6:end,:)=[];
img2(isnan(img2))=0;
img2=imresize(img2,[267 400]);

I=lab2rgb(img2);

end

%CANNY :

function I = Canny(img, thresh1, thresh2)

img=imgaussfilt(img,[0.0001 0.0001]); % the gaussian filter
img2= double(img);
Gy = [1 +2 +1; 0 0 0; -1 -2 -1];    %sobel filter
Gx = Gy';
img2=padarray(img2,[1,1],'circular');
[r,c]=size(img2);
img_x=zeros(size(img2));
img_y=zeros(size(img2));
%intensity gradient
for i=2:r-1  
    for j=2:c-1
        temp=img2(i-1:i+1,j-1:j+1);
        gx1=Gx.*temp;
        sum_x=sum(sum(gx1));
        img_x(i,j)=sum_x;
        
        gy1=Gy.*temp;
        sum_y=sum(sum(gy1));
        img_y(i,j)=sum_y;
    end
end
Gm=sqrt((img_x.^2)+(img_y.^2));
Go=radtodeg(atan2(img_x,img_y));
img3=zeros(size(Gm));
thresh1=thresh1/255;
thresh2=thresh2/255;
%non-maximum suppression
for i=2:r-1
    for j=2:c-1
        temp=abs(Go(i,j));
        if temp>180
            temp=temp-180;
        end
        switch logical(true)
            case (temp>165 && temp<=180 )|| ((temp>=0) && (temp<25)), Go(i,j)=0;
            case (temp>=25 && temp<60 ), Go(i,j)=45;
            case (temp>=60 && temp<=110 ), Go(i,j)=135;
            case (temp>110 && temp<=165 ),Go(i,j)=135;
           
        end;
        if (Go(i,j)==0)
            if((Gm(i,j)>Gm(i-1,j)) && (Gm(i,j) > Gm(i+1,j)))
                img3(i,j)=Gm(i,j);
            else
                img3(i,j)=0;
            end
        end
        if (Go(i,j)==45)
            if((Gm(i,j)>Gm(i-1,j-1)) && (Gm(i,j) > Gm(i+1,j+1)))
                img3(i,j)=Gm(i,j);
            else
                img3(i,j)=0;
            end
        end
        if (Go(i,j)==90)
            if((Gm(i,j)>Gm(i,j-1)) && (Gm(i,j) > Gm(i,j+1)))
                img3(i,j)=Gm(i,j);
            else
                img3(i,j)=0;
            end
        end
        if (Go(i,j)==135)
            if((Gm(i,j)>Gm(i+1,j-1)) && (Gm(i,j) > Gm(i-1,j+1)))
                img3(i,j)=Gm(i,j);
            else
                img3(i,j)=0;
            end
        end
        %double thersholding
        if img3(i,j)>=thresh2
            img3(i,j)=1;
        else
            if img3(i,j)>=thresh1 && img3(i,j)<thresh2
                img3(i,j)=0.5;
            else
                img3(i,j)=0;
            end
        end
%edge hystersis
        temp=img3(i-1:i+1,j-1:j+1);
        temp1=max(max(temp));
        if (img3(i,j)==1)
            img3(i,j)=1;
        else if ((img3(i,j)==0.5)&& (temp1==1))
                img3(i,j)=1;
            else
                img3(i,j)=0;
            end
        end
    end
end
img3(1:2,:)=[];
img3(r-1:end,:)=[];
img3(:,1:2)=[];
img3(:,c-1:end)=[];

I=(img3);

end

%CARTOON :

function I = cartoonImage(filtered, edges)
tic;
for i=1:size(edges,1)
    for j=1:size(edges,2)
        if(edges(i,j)==1)
            
            filtered(i,j,1)=0;
            filtered(i,j,2)=0;
            filtered(i,j,3)=0;
        end
    end
end
I=filtered;
toc;
end

%RMSE:

function RMSE = RMSerror(img1, img2)
    diff = img1 - img2;
    squaredErr = diff .^2;
    meanSE = mean(squaredErr(:));
    RMSE = sqrt(meanSE);
end
