function [g_f,h_f,q,t]=ADMM_solve_h(params,use_sz,model_xf,yf,small_filter_sz,w,model_w,frame,q,past_h,state)
   
     g_f = gpuArray(single(zeros(size(model_xf))));
     h_f = g_f;
     l_f = g_f;
     p_f = g_f;
     state.thetaa = g_f;
     q_updated = gpuArray(single(ones(1,size(model_xf,3))));
     q_updated = q_updated/norm(q_updated);
    
    mu    = 1;
    betha = 10;
    mumax = 10000;
    i = 1;
    
%     ws=bsxfun(@times,w,model_w);
    ws=w;
    T = prod(use_sz);
    S_xx = sum(conj(model_xf) .* model_xf, 3);
     if frame <=params.admm_3frame
         params.admm_iterations=3;end
    %   ADMM
   
    while (i <= params.admm_iterations)
        %   solve for G- please refer to the paper for more details
        B = S_xx + (T * mu);
        S_lx = sum(conj(model_xf) .* l_f, 3);
        S_hx = sum(conj(model_xf) .* h_f, 3);
        g_f = 1/(T*mu) * bsxfun(@times, yf, model_xf) - (1/mu) * l_f + h_f - ...
            (bsxfun(@rdivide,(1/(T*mu) * bsxfun(@times, model_xf, (S_xx .* yf)) - (1/mu) * bsxfun(@times, model_xf, S_lx) + bsxfun(@times, model_xf, S_hx)), B));
  
        %   solve for H
  %      h = (T/(mu*T+ params.admm_lambda))* ifft2(mu*g_f + l_f);
        ws=gather(ws);
        h=argmin_h(T,mu,params.admm_lambda1,g_f,l_f,ws,q,past_h, p_f);

        [sx,sy,h] = get_subwindow_no_window(h, floor(use_sz/2) , small_filter_sz);
        t = (single(zeros(use_sz(1), use_sz(2), size(h,3))));
        h=gather(h);
        t(sx,sy,:) = h;
%         t=h;
%         t=gather(t);
        h_f = fft2(t);
        
        % update q
        h_f=gather(h_f);
        g_f=gather(g_f);
        l_f=gather(l_f);
     
        h_t = ifft2(h_f);
        g_t = ifft2(g_f);
        l_t = ifft2(l_f);
        
        for ii = 1:size(h_f,3)
            hk = reshape(h_t(:,:,ii),[T,1]);
            gk = reshape(g_t(:,:,ii),[T,1]);
            lk = reshape(l_t(:,:,ii),[T,1]);
            
        q1 = (mu*T*(hk'*gk)) + (T*(hk'*lk)) + (params.gamma*q(:,:,ii));
        q2 = (mu*T*(hk'*hk))+params.admm_beta + (params.gamma);
        q_updated(:,ii)=q1/q2;
        end
        q_updated=gather(q_updated);
        q_updated = real(q_updated);
%         q_updated = q_updated/norm(q_updated);
        
        q = reshape(q_updated,[1,1,size(h_f,3)]);
        
        %update p
        thr = params.alpha/params.beta;
%         if state.frame==1
%         past_h = state.f_f; 
%             end
            temp = ifft2(h_f - past_h) + (state.thetaa/params.beta);
%             thr = 0.3*max(temp(:));
            p = wthresh(temp,'h',thr);
%             state.p = 1- state.p;
% %==============================only for plotting======================================
%             mean_p = mean(p,3);
%             mean_p1(:,:,1) = gather(mean_p);
%             mean_p1(:,:,2) = gather(mean_p);
%             mean_p1(:,:,3) = gather(mean_p);
%             mean_p1 = double(real(mean_p1)*255);
%             
%             mean_p2=zeros([size(mean_p,1),size(mean_p,2)]);
%              mean_p = gather(mean_p);
%             
%             mean_p2(sx,sy) = real(mean_p(sx,sy)); 
%             mean_p2=mean_p2/max(mean_p2(:));
% %             mean_p1 = ind2rgb(double(gather(mean_p)*255),map);
% %             colormap winter
% colormap jet
% mean_p2(mean_p2<0) = 0;
% % % mean_p2(mean_p2==nan) = 0;
%             figure(2)
% %             subplot(1,3,2)
% %             imshow(mean_p2,[])
%             surf(mean_p2)
% %             zlim([0 1])
%             title('B_h')
%            colormap jet
% %             subplot(1,3,2)
% %             imshow(mean(temp,3),[])
%             hold on
%              nm=[num2str(state.frame) '_bh.jpg'];
% saveas(gca,nm)
% %==================only for plotting ends=================================            
            p_f = fft2(p);
%             
            % update theta
            
            state.thetaa = state.thetaa + params.beta*(ifft2(h_f - p_f - past_h));
            
            
            % update beta
            
            params.beta = params.rou*params.beta;

        %   update L
        l_f = l_f + (mu * (g_f - h_f));
        
        %   update mu- betha = 10.
        mu = min(betha * mu, mumax);
        i = i+1;
               
    end
%     q(q<0.3*max(q))=0;
end
   