clc
clear
close all

im1 = im2double(imread('./data_1/a.png'));
im2 = im2double(imread('./data_1/b.png'));



level = 4;%金字塔层数
sigma = 1;%金字塔每层提取的细节尺度。小了可能导致细节提取不充分，大了可能会导致融合结果失真。

im1_pyr = MLPD(im1, level, sigma);
im2_pyr = MLPD(im2, level, sigma);

pyr = pyr_fusion(im1_pyr, im2_pyr);
% 
% for i =level-1:-1:1
%    figure
%    imshow(pyr{i},[]);
%     
% end

out = pyr{level};

for i = level-1 : -1 : 1
    out = pyr{i} + imresize(out,[size(pyr{i},1) size(pyr{i},2)],'bilinear');
%     figure;
%     imshow(out,[])
end

dif = im2-out;
disp(['mean diff value: ',num2str(mean(abs(dif),'all'))]);
imshow([out]);

%------------------------------函数1 金字塔分解------------------------------
function pyr = MLPD(I, nlev, sigma)
%Laplacian Pyramid Decomposition
%多通道拉普拉斯金字塔分解
%   nlev  金字塔层数
%   sigma 高斯模糊程度

if ~exist('nlev', 'var')
    nlev = 4;
end
 
if ~exist('sigma', 'var')
    sigma = 1;
end

k = fspecial('gaussian', floor(sigma*3)*2+1, sigma);
 
%构建拉普拉斯金字塔
pyr = cell(nlev,1);
J = I;

for j = 1:nlev-1
    J_blur = imfilter(J, k, 'replicate');
    J_blur_down = J_blur(1:2:size(J_blur,1)-1,1:2:size(J_blur,2)-1, :); %downsample 
    J_blur_high = imresize(J_blur_down,[size(J_blur,1) size(J_blur,2)],'bilinear');
    pyr{j} = J-J_blur_high;
    J=J_blur_down;
end
pyr{nlev}=J_blur_down; %最上一层即为高斯金字塔
end
%------------------------------函数2 金字塔融合------------------------------
function pyr = pyr_fusion(pyr1,pyr2, e)
%pyramid fusion
%局部能量特征的拉普拉斯金字塔融合

if ~exist('e', 'var')
    e = 0.6;
end

n = size(pyr1, 1);
pyr = cell(n, 1);

f = fspecial('average', [3 3]);

% 对每一层融合
for i=n:-1:1
    F11 = pyr1{i};
    F12 = pyr2{i};
    E1 = imfilter(F11.^2, f, 'replicate');%计算能量
    E2 = imfilter(F12.^2, f, 'replicate');
    res = (E1<E2);
%     imshow([E1 E2; F11 F12],[]);
    M = imfilter(F11.*F12, f, 'replicate').^2./(E1.*E2);%计算匹配度
    F11(E1<E2) = F12(E1<E2);%匹配度低时
    
    W_min = 0.5*(1 - (1-M)./(1-e));%计算权重
    W_max = 1 - W_min;
    F21 = W_min.*pyr1{i}+W_max.*pyr2{i};
    F22 = W_min.*pyr2{i}+W_max.*pyr1{i};
    F21(E1>E2) = F22(E1>E2);%匹配度高时
    
    F11(M>e) = F21(M>e);%按匹配度计算
%     figure
%     imshow(F11,[]);
    pyr{i} = F11;
end
end