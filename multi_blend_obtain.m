
function Pyramid_A = multi_blend_obtain(A)
 
%gaussian kernel
kernel=fspecial('gaussian',5,1);
 
%obtain the Gauss Pyramid
G_A0 = double(A);
G_A1 = imfilter(G_A0,kernel,'replicate');
G_A1 = imresize(G_A1,0.5,"Antialiasing",false);
G_A2 = imfilter(G_A1,kernel,'replicate');
G_A2 = imresize(G_A2,0.5,"Antialiasing",false);
G_A3 = imfilter(G_A2,kernel,'replicate');
G_A3 = imresize(G_A3,0.5,"Antialiasing",false);
G_A4 = imfilter(G_A3,kernel,'replicate');
G_A4 = imresize(G_A4,0.5,"Antialiasing",false);
G_A5 = imfilter(G_A4,kernel,'replicate');
G_A5 = imresize(G_A5,0.5,"Antialiasing",false);

 
%get Laplacian Pyramid
L_A0 = double(G_A0)-imresize(G_A1,size(G_A0),"Antialiasing",false);
L_A1 = double(G_A1)-imresize(G_A2,size(G_A1),"Antialiasing",false);
% subplot(131);imshow(L_A0);
L_A2 = double(G_A2)-imresize(G_A3,size(G_A2),"Antialiasing",false);
L_A3 = double(G_A3)-imresize(G_A4,size(G_A3),"Antialiasing",false);
L_A4 = double(G_A4)-imresize(G_A5,size(G_A4),"Antialiasing",false);
L_A5 = double(G_A5);


Pyramid_A = {};
Pyramid_A{end+1} = L_A0;
Pyramid_A{end+1} =  L_A1;
Pyramid_A{end+1} =  L_A2;
Pyramid_A{end+1} =  L_A3;
Pyramid_A{end+1} =  L_A4;
Pyramid_A{end+1} =  L_A5;


% subplot(141);imshow(L_A0,[]);
% subplot(142);imshow(L_A1,[]);
% subplot(143);imshow(L_A2,[]);
% subplot(144);imshow(L_A3,[]);



end