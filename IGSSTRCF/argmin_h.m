function h=argmin_h(T,mu,lambda,g_f,l_f,w0,q,past_h, p_f)
% 
%      lhd= T ./  (lambda*w0 .^2 + mu*T); % left hand
%   
%      X=ifft2(mu*g_f + l_f);
% %      h=gpuArray(zeros(size(X)));
%      % compute T for each channel
% 
%      h=bsxfun(@times,lhd,X);
%===========================
for count=1:size(q,3)
    lhd(:,:,count)= T ./  (lambda*w0 .^2 + mu*T + mu*T*q(:,:,count)*q(:,:,count) + 0.00001*eye(size(w0,1))); % left hand
end
%      lhd= T ./  (lambda*w0 .^2 + mu*T); % left hand
%      X=bsxfun(@times,q,/ifft2(mu*g_f + l_f)) + (0.0001*past_h);
     X=ifft2(mu*g_f + l_f) + (0.00001*(past_h + p_f));
% X=ifft2(mu*g_f + l_f) ;
%      h=gpuArray(zeros(size(X)));
     % compute T for each channel

     h=bsxfun(@times,lhd,X);

     %==========================

end