function [resultImg] = scan(originalImg, rectWidth, rectHeight)
    %% Initialize parameter
    %% Initialize parameter
    target = [1 1; rectWidth 1; rectWidth rectHeight; 1 rectHeight];
    x_tar = target(:,1);
    y_tar = target(:,2);

    [h, w, c] = size(originalImg);
    resultImg = zeros(rectHeight,rectWidth,c);
    imshow(originalImg);

    %% Mouse input
    [ x, y ] = ginput(4);

    %% Calculate Homography
    m = [x(1) y(1) 1 0 0 0 -x(1)*x_tar(1) -y(1)*x_tar(1);
        x(2) y(2) 1 0 0 0 -x(2)*x_tar(2) -y(2)*x_tar(2);
        x(3) y(3) 1 0 0 0 -x(3)*x_tar(3) -y(3)*x_tar(3);
        x(4) y(4) 1 0 0 0 -x(4)*x_tar(4) -y(4)*x_tar(4);
        0 0 0 x(1) y(1) 1 -x(1)*y_tar(1) -y(1)*y_tar(1);
        0 0 0 x(2) y(2) 1 -x(2)*y_tar(2) -y(2)*y_tar(2);
        0 0 0 x(3) y(3) 1 -x(3)*y_tar(3) -y(3)*y_tar(3);
        0 0 0 x(4) y(4) 1 -x(4)*y_tar(4) -y(4)*y_tar(4);
        ];

    z = [x_tar(1); x_tar(2); x_tar(3); x_tar(4); y_tar(1); y_tar(2); y_tar(3); y_tar(4)];
    H = m\z;
    H = H';

    for i = 1:4
        a = (H(1)*x(i) + H(2)*y(i) + H(3))/(H(7)*x(i) + H(8)*y(i) + 1);
        b = (H(4)*x(i) + H(5)*y(i) + H(6))/(H(7)*x(i) + H(8)*y(i) + 1);
    end
    A = H(1) - H(7)*rectWidth;
    B = H(2) - H(8)*rectWidth;
    C = rectWidth - H(3);
    D = H(4) - H(7)*rectHeight;
    E = H(5) - H(8)*rectHeight;
    F = rectHeight - H(6);
    a = ((C*E)-(B*F))/((A*E)-(B*D)); 
    b = ((C*D)-(A*F))/((B*D)-(A*E)); 

    for i = 1:rectHeight
        for j = 1:rectWidth
            A = H(1) - H(7)*j;
            B = H(2) - H(8)*j;
            C = j - H(3);
            D = H(4) - H(7)*i;
            E = H(5) - H(8)*i;
            F = i - H(6);
            a = ((C*E)-(B*F))/((A*E)-(B*D)); 
            b = ((C*D)-(A*F))/((B*D)-(A*E)); 
            resultImg(i,j,:) = originalImg(round(b), round(a), :);
        end
    end 

    imshow(resultImg);
end