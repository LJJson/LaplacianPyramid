clear all
close all

I = imread('coins.png');
test_img = imresize(I,[64,64],'Antialiasing',false);
% imwrite(test_img,'./test.png');
% imshow(test_img,[]);
[A,B] = interpolation_2d('./test.png',2);
% subplot(131);imshow(A,[]);title("横向插值后",'FontSize',20);
% subplot(132);imshow(B,[]);title("纵向插值后",'FontSize',20);
% subplot(133);imshow(test_img,[]);title("原图",'FontSize',20);

a = multi_blend_obtain(test_img);
b = multi_blend_obtain(A);
c = multi_blend_obtain(B);

% subplot(151);imshow(c{1});
% subplot(152);imshow(c{2});
% subplot(153);imshow(c{3});
% subplot(154);imshow(c{4});
% subplot(155);imshow(c{5});


b_dif = {};
c_dif = {};
dIFF={};
maskb={};
maskc={};

K = fspecial('gaussian',5,1);
n = imfilter(A,K);

w1=abs(double(A-imfilter(A,K)));
w2=abs(double(B-imfilter(B,K)));
% imshow([A n ;w1 w2],[]);    
% imshow([w1 w2],[]);  
f = fspecial('average', [3 3]);
e = 0.6;

for i =1:length(a)
    %%自己的方法计算权重
    maskb{i} = w1;
    G_W2 = imfilter(w1,K,'replicate');%高斯模糊
    G_W2 = imresize(G_W2,0.5,"Antialiasing",false);%缩小一倍
    w1 = G_W2;
    
    maskc{i} = w2;
    C_W2 = imfilter(w2,K,'replicate');%高斯模糊
    C_W2 = imresize(C_W2,0.5,"Antialiasing",false);%缩小一倍
    w2 = C_W2;
%     
%     mask_b{i} = maskb{i}./(maskb{i}+maskc{i});
%     mask_c{i} = maskc{i}./(maskb{i}+maskc{i});
%     figure
%     imshow([mask_b{i} mask_c{i}],[]);
%%
%     %%加入强度计算权重
    F11 = maskb{i};
    F12 = maskc{i};
    E1 = imfilter(F11.^2, f, 'replicate');%计算能量
    E2 = imfilter(F12.^2, f, 'replicate');
%     imshow([E1 E2; F11 F12],[]);
    M = imfilter(F11.*F12, f, 'replicate').^2./(E1.*E2);%计算匹配度
    F11(E1<E2) = F12(E1<E2);%匹配度低时
    
    W_min = 0.5*(1 - (1-M)./(1-e));%计算权重
    W_max = 1 - W_min;

%     imshow([W_min W_max],[]);
    F21 = W_min.*maskb{i}+W_max.*maskc{i};
    F22 = W_min.*maskc{i}+W_max.*maskb{i};
    
    mask_c{i} = F21./(F21 + F22);
    mask_b{i} = F22./(F21 + F22);
%     imshow([F21 F22],[]);
%     F21(E1>E2) = F22(E1>E2);%匹配度高时
%     
%     F11(M>e) = F21(M>e);%按匹配度计算
% %     figure
% %     imshow(F11,[]);
%     pyr{i} = F11;
%%




end


% for i =1:length(a)
%     mask_b{i} = imguidedfilter(mask_b{i},maskb{i});
%     mask_c{i} = imguidedfilter(mask_c{i},maskc{i});
% end



for i=1:length(a)
    
%     dIFF{end+1}=a{i}-(0.5*b{i}+0.5*c{i}); 
    dIFF{end+1}=a{i}-(mask_b{i}.*b{i}+mask_c{i}.*c{i});% mask权重
    disp(['mean diff value: ',num2str(mean(abs(dIFF{end}),'all'))]);
%     figure
%     imshow(dIFF{end},[]);
    
    
end

% for i=1:1:size(a,2)
%     b_dif{end+1} = a{i} - b{i};
%     c_dif{end+1} = a{i} - c{i};
% end

% figure 
% subplot(141);imshow(b_dif{1},[]);
% subplot(142);imshow(b_dif{2},[]);
% subplot(143);imshow(b_dif{3},[]);
% subplot(144);imshow(b_dif{4},[]);
% 
% figure 
% subplot(141);imshow(c_dif{1},[]);
% subplot(142);imshow(c_dif{2},[]);
% subplot(143);imshow(c_dif{3},[]);
% subplot(144);imshow(c_dif{4},[]);



