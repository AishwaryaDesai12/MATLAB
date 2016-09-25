function[]=CLAHE(file_name)

close all;                           % to close all the existing windows

img=imread(file_name);               % reads the image and stores it in img
imshow(file_name);                   % displays the image
title('Original Image');
figure;

ResizedImg=imresize(img,[1024 1024]);% to resize the image
GrayImg=rgb2gray(ResizedImg);        % converts an image to gray scaled

imshow(GrayImg);
title('Gray Scale Image');
figure;

[r,c]=size(GrayImg);
ClipLimit=0.9;
disp(ClipLimit);
eqcount=(zeros(r,c));
x1=1;
y1=1;
% CLAHE Algorithm as per the paper provided
while(y1<c)
    
    for x=x1:x1+8;
        for y=y1:y1+8;
            eqcount(x,y)=0;
            for i=1:8;
                for j=1:8;
                    if GrayImg(x1+i,y1+j)==GrayImg(x1+i,y1+j)
                        eqcount(x,y)=eqcount(x,y) + 1;
                    end
                end
            end
        end
    end
    if x1==1;
        x1=x1+7;
    else
        x1=x1+8;
    end
    if x1>=r
        x1=1;
        if y1==1;
            y1=y1+7;
        else
            y1=y1+8;
        end
        
        %disp(['ysize ' +num2str(y1)]);
    end
    %disp([num2str(x) 'xsize ' +num2str(x1)] );
    
end
Output=(zeros(r,c));

y1=1;
x1=1;
while(y1<c)
    for x=x1:x1+8;
        for y=y1:y1+8;
            cliptotal=0;
            partialrank=0;
            for i=1:8;
                for j=1:8;
                    if eqcount(x1+i,y1+j) > ClipLimit
                        incr=ClipLimit/eqcount(x1+i,y1+j);
                    else
                        incr=1;
                    end
                    cliptotal=cliptotal+(1-incr);
                    if GrayImg(x,y) > GrayImg(x1+i,y1+j)
                        partialrank = partialrank + incr;
                    end
                end
            end
            redistr = (cliptotal /64) * GrayImg(x,y);
            Output(x,y) = partialrank + redistr;
        end
    end
    if x1==1;
        x1=x1+7;
    else
        x1=x1+8;
    end
    if mod(x1,r)==0
        x1=1;
        if y1==1;
            y1=y1+7;
        else
            y1=y1+8;
        end
        
    end
end
    FinalOutput=uint8(Output);
    imshow(FinalOutput);
    title('Contrast Limited Adaptive Histogram Equalization');
end
    