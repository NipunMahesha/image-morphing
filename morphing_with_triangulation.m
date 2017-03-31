clear all
close all

A = imread('woman.jpg');
B = imread('tiger.jpg');
B = imresize(B,[size(A,1),size(A,2)]);
num_points = 10;

height = size(A,1);
width = size(A,2);

height2 = size(B,1);
width2 = size(B,2);

% mark feature points on first image
imshow(A);
[xA,yA] = ginput(num_points);
xA = [xA;1;width;width;1];
yA = [yA;1;1;height;height];


% mark feature points on second image
imshow(B);
[xB,yB] = ginput(num_points);
xB = [xB;1;width;width;1];
yB = [yB;1;1;height;height];

steps = 10;
results= uint8(zeros(steps,height,width,3));
alpha = 0.0;

for i = (1:steps+1)
    
    
    xC = alpha*xB + (1-alpha)*xA;
    yC = alpha*yB + (1-alpha)*yA;
    triC = delaunay(xC,yC);
    ntri = size(triC,1);
    
    % allocate memory for x, y coordinators
    xCA = zeros(height,width);
    yCA = zeros(height,width);
    xCB = zeros(height,width);
    yCB = zeros(height,width);
    [X,Y] = meshgrid(1:width,1:height);
    
    
    % warp the intermediate grid to source and target grid
    for k = 1:ntri
        [w1,w2,w3,r] = inTri(X, Y, xC(triC(k,1)), yC(triC(k,1)), xC(triC(k,2)), yC(triC(k,2)), xC(triC(k,3)), yC(triC(k,3)));
        w1(~r)=0;
        w2(~r)=0;
        w3(~r)=0;
        xCA = xCA + w1.*xA(triC(k,1)) + w2.*xA(triC(k,2)) + w3.*xA(triC(k,3));
        yCA = yCA + w1.*yA(triC(k,1)) + w2.*yA(triC(k,2)) + w3.*yA(triC(k,3));
        xCB = xCB + w1.*xB(triC(k,1)) + w2.*xB(triC(k,2)) + w3.*xB(triC(k,3));
        yCB = yCB + w1.*yB(triC(k,1)) + w2.*yB(triC(k,2)) + w3.*yB(triC(k,3));
    end

    % interpolate each point by using 'interp2' function 
    VCA(:,:,1) = interp2(X,Y,double(A(:,:,1)),xCA,yCA);
    VCA(:,:,2) = interp2(X,Y,double(A(:,:,2)),xCA,yCA);
    VCA(:,:,3) = interp2(X,Y,double(A(:,:,3)),xCA,yCA);

    VCB(:,:,1) = interp2(X,Y,double(B(:,:,1)),xCB,yCB);
    VCB(:,:,2) = interp2(X,Y,double(B(:,:,2)),xCB,yCB);
    VCB(:,:,3) = interp2(X,Y,double(B(:,:,3)),xCB,yCB);

    % cross-dissolve 
    C = alpha*VCB + (1-alpha)*VCA;

    % convert double to uint8 format and display
    %figure
    imshow(uint8(C));
    
    results(i,:,:,:) = uint8(C);
    filename = strcat(['result_img_',num2str(i),'.jpg']);
    imwrite(uint8(C),filename);
    
    alpha = alpha +.1;
end

