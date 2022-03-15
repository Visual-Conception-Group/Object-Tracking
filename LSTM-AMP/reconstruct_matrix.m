function B=reconstruct_matrix(X);
% [M,N]=size(X);
% C=zeros(M,N);
% [U E V]=svd(X);
% pos=find(E<0);
% E(pos)=0;
% n=rank(E)
% for i=1:n
%     C=C+(kron(U(:,i)',V(:,i))*E(i,i))';
% end
% B=C;
[v d]=eig(X);
pos=find(d<0);
d(pos)=0;
B=v*d*v';
end