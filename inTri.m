function [w1,w2,w3,r] = inTri(vx, vy, v0x, v0y, v1x, v1y, v2x, v2y)

    v0x = repmat(v0x, size(vx,1), size(vx,2));
    v0y = repmat(v0y, size(vx,1), size(vx,2));
    v1x = repmat(v1x, size(vx,1), size(vx,2));
    v1y = repmat(v1y, size(vx,1), size(vx,2));
    v2x = repmat(v2x, size(vx,1), size(vx,2));
    v2y = repmat(v2y, size(vx,1), size(vx,2));
    w1 = ((vx-v2x).*(v1y-v2y) - (vy-v2y).*(v1x-v2x))./...
    ((v0x-v2x).*(v1y-v2y) - (v0y-v2y).*(v1x-v2x)+eps);
    w2 = ((vx-v2x).*(v0y-v2y) - (vy-v2y).*(v0x-v2x))./...
    ((v1x-v2x).*(v0y-v2y) - (v1y-v2y).*(v0x-v2x)+eps);
    w3 = 1 - w1 - w2;
    r = (w1>=0) & (w2>=0) & (w3>=0) & (w1<=1) & (w2<=1) & (w3<=1);
end