function [A,B] = interpolation_2d(path,inter_num)
% path  is pic de dress
% inter_num is intervals sample

img = imread(path);
% t = (img - min(img(:))) / (max(img(:)) - min(img(:)));
% img = t*255;
intervals=inter_num;
A=zeros(size(img));
B=zeros(size(img));

A(1:intervals:end,:)=img(1:intervals:end,:);
B(:,1:intervals:end)=img(:,1:intervals:end);
% subplot(121);imshow(A,[]);title("横向间隔取值",'FontSize',20);
% subplot(122);imshow(B,[]);title("纵向间隔取值",'FontSize',20);

% 生成网格
[X,Y] = meshgrid(1:size(A,2), 1:size(A,1));

mask=false(size(A));
mask(1:intervals:end,:)=true;

XX=X(1:intervals:end,:);
YY=Y(1:intervals:end,:);
AA=A(1:intervals:end,:);

Xq=X(~mask);
Yq=Y(~mask);

new_img = interp2(XX, YY, double(AA), Xq, Yq, 'linear');
% figure
% imshow(uint8(A));
A(~mask)=new_img(:);

% figure
% imshow(uint8(A));
% title('横向插值');

%%%  B
% 生成网格
[X,Y] = meshgrid(1:size(B,2), 1:size(B,1));

mask=false(size(B));
mask(:,1:intervals:end)=true;

XX=X(:,1:intervals:end);
YY=Y(:,1:intervals:end);
BB=B(:,1:intervals:end);

Bq=X(~mask);
By=Y(~mask);

new_b = interp2(XX, YY, double(BB), Bq, By, 'linear');
% figure
% imshow(uint8(B));
B(~mask)=new_b(:);
A(isnan(A))=0;
B(isnan(B))=0;
% figure
% imshow(uint8(B));
% title('竖向插值');

end



