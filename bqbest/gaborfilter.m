function [G,gabout] = gaborfilter(I,Sx,Sy,f,theta)
%  I : Input image输入图像
%  Sx & Sy : Variances along x and y-axes respectively分别沿 x 和 y 轴的差额
%  f : The frequency of the sinusoidal function  滤波频率
%  theta : The orientation of Gabor filter滤波方向

%  G : The output filter as described above 如上面所述的输出滤波器
%  gabout : The output filtered image 经过滤波的输出图像

% 检测I是否给定类的对象
if isa(I,'double')~=1
    I = double(I);
end
%循环，并且sx向零取整
for x = -fix(Sx):fix(Sx)
    %循环，并且sx向零取整
    for y = -fix(Sy):fix(Sy)
        %计算xPrime
        xPrime = x * cos(theta) - y * sin(theta);
        %计算yPrime
        yPrime = y * cos(theta) + x * sin(theta);
        G(fix(Sx)+x+1,fix(Sy)+y+1) = exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*sin(2*pi*f*xPrime);
    end
end
%二维卷积
Imgabout = conv2(I,double(imag(G)),'same');
%二维卷积
Regabout = conv2(I,double(real(G)),'same');
%计算
gabout = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);