# LaplacianPyramid
拉普拉斯金字塔融合 图像（matlab）


使用说明：
clear all
close all
img = imread('./data/a0-64.png');
% img1 = imread('./data/a1-64.png');
% figure(10)
imtool(img,[]);
[A,B] = interpolation_2d('./data/a0-64.png',5);
figure(10)
imshow(A,[]);
figure(9)

imshow(B,[]);

% figure(10)

% imwrite(uint8(A),'./a.bmp');
% imwrite(uint8(B),'./b.bmp');
% 
% figure
% imshow(B,[]);

% C = multi_blend(A,B);

%%迭代（权重衰减）
C=img;
max_iter=27;
w=linspace(0.99,0.1,max_iter);

for  i = 1:max_iter
    if mod(i,2)==1
           C = multi_blend(C,B,w(i));
    else
           C = multi_blend(C,A,w(i));
    end
    
  
end

imtool(C,[]);


