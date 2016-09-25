function fftshift_myimplementation(X)
close all;
    cooley_tuckey(X);

end
%-----------COOLEY TUCKEY----------------------------------------------

function Y2=cooley_tuckey(X)
X=imread(X);
X=rgb2gray(X);
X=double(X);
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
imshow((Y2));
title('cooley tukey');  
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
        Y(k+N/2) = temp -exp(Twiddle_factor)*Y(k+(N/2));
    end   
  end

end

%------------FFTSHIFT-------------------------------------------------- 

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
figure;
imshow((Y12));
title('After center shift');
Y12=ifft(Y12);
end

function Y1=fftshif1(x1)
N=length(x1);
if N==1
    Y1(1)=x1(1);
else
    Y1=[x1((N/2)+1:N) x1(1:N/2)];
end
end
%---------IFFTSHIFT---------------------------------------------------
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
figure;
imshow((Y21));
title('After inverse center shift');
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

%--------------IFFT---------------------------------------------------
function Y1=ifft(Y12)
Y12=iffshif(Y12);

X=Y12;
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
figure;
  imshow(Y2/(max(max(Y2))));
  title('IFFT');
  
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