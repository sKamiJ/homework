function outputImg = affineTransformation(inputImg)
%建立变换矩阵
s = 0.7;
m = 0.4;
theta = pi / 6;
T = [m*cos(theta)  s*sin(theta) 0;
     -m*sin(theta) s*cos(theta) 0;
     0 0 1];
%几何结构变换方式为affine
tform = maketform('affine', T);
%进行仿射变换
outputImg = imtransform(inputImg, tform);