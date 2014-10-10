function Z=vandermonde(w,N);
%VANDERMONDE   Constructs Vandermonde matrix from frequencies
%
% Syntax:
%   Z=vandermonde(w,N);
%
% About:
%   This file is part of the Multi-Pitch Estimation Toolbox for the book
%   M. G. Christensen and A. Jakobsson, Multi-Pitch Estimation, Morgan &
%   Claypool Publishers, 2009.
%
% Input:
%   w        L frequencies in radians
%   N        
%
% Output:
%   Z        N-by-L Vandermonde matrix 
%
% Description:
%   Auxiliary function that computes the Vandermonde matrix for a set of
%   frequencies as described in Section 1.4 of Christensen and Jakobsson 
%   (2009).
%
% Example:
%   Z=vandermonde(2*pi*[1:5],100)
%
% Implemented By:
%   Mads G. Christensen (mgc@es.aau.dk)
w=w(:)';
Z=zeros(N,length(w));
z=[exp(j*w)];
for n=1:N,
  Z(n,:)=z.^(n-1);
end