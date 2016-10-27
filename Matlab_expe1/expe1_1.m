%读取图1与图2
img1 = imread('./图1.jpg');
img2 = imread('./图2.png');
%显示图1与图2
subplot(1,2,1), imshow(img1), title('图1');
subplot(1,2,2), imshow(img2), title('图2');
%写入图1与图2
imwrite(img1,'./图1_复制.jpg');
imwrite(img2,'./图2_复制.png');