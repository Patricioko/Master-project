clear;
clc;
I=imread('D:\Patricio\studyfromNTU\Robotics_vision\image0\24.jpg');
imshow(I)
[centers,radii] = imfindcircles(I,[1 10]);
centers(1,1);
radii;

f=450;
z_corr3d_came=(150*f)/radii

ratio=150/radii;
coor2d_pixel=[centers(1,1)-256;centers(1,2)-256];
trans1=[cosd(90) -sind(90);sind(90) cosd(90)];
coor2d_pixel=trans1*coor2d_pixel;
coor3d_came=[coor2d_pixel(1,1)*ratio;coor2d_pixel(2,1)*ratio;z_corr3d_came];

alpha=[cosd(-90) -sind(-90) 0;sind(-90) cosd(90) 0;0 0 1];
beta=[cosd(100) 0 -sind(100);0 1 0;sind(100) 0 cosd(100)];
gamma=[1 0 0;0 cosd(15) -sind(15);0 sind(15) cosd(15)];

world_T_came=alpha*beta*gamma;
world_came=[1.5;-5;1.5];


coor3d_world=(world_T_came*coor3d_came)./10000+world_came
(world_T_came*coor3d_came)./10000;