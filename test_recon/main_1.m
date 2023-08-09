% clc;
% clear;
% 
% im1 = im2double(imread('./data_1/a0-188.png'));
% im2 = im2double(imread('./data_1/a1-188.png'));

img = im2double(imread('./data_1/test.png'));
imshow(img ,[]);
[im1 im2] = interpolation_2d('./data_1/test.png',2);

imshow([im1 im2],[]);
% [img1 img2] = interpolation_2d('./data_1/a1-188.png',3);

%% Get B,D
h1 = fspecial('average',[31,31]); %定义一个滤波模板
B1 = imfilter(im1, h1, 'replicate'); %均值滤波得到图1基层 'replicate'是对边界值的处理模式
B2 = imfilter(im2, h1, 'replicate'); %均值滤波得到图2基层

D1 = im1-B1; %细节层
D2 = im2-B2;
% imshow([D1  D2],[]);
%%

h2 = fspecial('laplacian', 0.2);
H1 = imfilter(im1, h2, 'replicate');
H2 = imfilter(im2, h2, 'replicate');

H1 = abs(H1); % 取绝对值
H2 = abs(H2);

h3 = fspecial('gaussian', [11,11], 5);
S1 = imfilter(H1, h3, 'replicate');
S2 = imfilter(H2, h3, 'replicate');
% imshow([H1 H2 ;S1 S2],[]);
%%
P1 = wmap(S1, S2);
P2 = wmap(S2, S1);

imshow([P1 P2],[]);
%%

%% Guide Filter

eps1 = 0.3^2;
eps2 = 0.03^2;
Wb1(:,:,1)  = guidedfilter(im1(:,:,1) , P1(:,:,1) , 4, eps1);
Wb2(:,:,1)  = guidedfilter(im2(:,:,1) , P2(:,:,1) , 4, eps1);
Wd1(:,:,1)  = guidedfilter(im1(:,:,1) , P1(:,:,1) , 3, eps2);
Wd2(:,:,1)  = guidedfilter(im2(:,:,1) , P2(:,:,1) , 3, eps2);
% 
% imshow([Wb1 Wb2 ;Wd1 Wd2],[]) ;
%%
Wbmax = Wb1+Wb2;
Wdmax = Wd1+Wd2;
Wb1 = Wb1./Wbmax;
Wb2 = Wb2./Wbmax;
Wd1 = Wd1./Wbmax;
Wd2 = Wd2./Wbmax;

imshow([Wb1 Wb2 ;Wd1 Wd2],[]) ;
B = B1.*Wb1+B2.*Wb2;
D = D1.*Wd1+D2.*Wd2;
im = B+D;
%%
imshow(im,[]); 


