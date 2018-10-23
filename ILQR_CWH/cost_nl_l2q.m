function cost = cost_nl_l2q(u,xi,xdi,R)
%
% Function to determine cost using L2^2 + Quad Divergence
%
% Synopsis:
%     cost = cost_nl_l2q(u,xi,xdi,R)
%
% Input:
%     u           =   control input for all densities(column vector)
%     xi          =   states for each density (# states x # densities)
%     xdi         =   target states (# target states x # target densities)
%     R           =   Control Weight Matrix (matrix size u)
%
% Output:
%     cost          =   scalar cost using L2^2 + Quad Divergence
%
%
% By: Bryce Doerr -- Aug. 2018

%Initialization
xj=xi;
xdj=xdi;
J1=0;
J1s=0;
J2=0;
S=0.5^2*diag([1 1 1]);

for i=1:size(xi,2)
    for j=1:size(xi,2)
       J1=mvnpdf(xi(1:3,i), xj(1:3,j), 2*S)+J1;
    end
end

for i=1:size(xi,2)
    for dj=1:size(xdj,2)
        J2=mvnpdf(xi(1:3,i), xdj(1:3,dj), 2*S)+J2;
        J1s=-1*(-1/2*(xi(1:3,i)-xdj(1:3,dj))'*inv(2*S)*(xi(1:3,i)-xdj(1:3,dj))-log(sqrt((2*pi)^(size(xi,1)/2)*det(2*S))))+J1s;
    end
end

%Output cost function
cost=300*(J1)-1200*2*J2+u'*R*u+1/30*J1s;