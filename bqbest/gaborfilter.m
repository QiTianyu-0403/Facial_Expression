function [G,gabout] = gaborfilter(I,Sx,Sy,f,theta)
%  I : Input image����ͼ��
%  Sx & Sy : Variances along x and y-axes respectively�ֱ��� x �� y ��Ĳ��
%  f : The frequency of the sinusoidal function  �˲�Ƶ��
%  theta : The orientation of Gabor filter�˲�����

%  G : The output filter as described above ����������������˲���
%  gabout : The output filtered image �����˲������ͼ��

% ���I�Ƿ������Ķ���
if isa(I,'double')~=1
    I = double(I);
end
%ѭ��������sx����ȡ��
for x = -fix(Sx):fix(Sx)
    %ѭ��������sx����ȡ��
    for y = -fix(Sy):fix(Sy)
        %����xPrime
        xPrime = x * cos(theta) - y * sin(theta);
        %����yPrime
        yPrime = y * cos(theta) + x * sin(theta);
        G(fix(Sx)+x+1,fix(Sy)+y+1) = exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*sin(2*pi*f*xPrime);
    end
end
%��ά���
Imgabout = conv2(I,double(imag(G)),'same');
%��ά���
Regabout = conv2(I,double(real(G)),'same');
%����
gabout = sqrt(Imgabout.*Imgabout + Regabout.*Regabout);