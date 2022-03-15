function [w]=ADMM_solve_w(params,use_sz,model_w,h_f,state)
    
    w = gpuArray(params.w_init*single(ones(use_sz)));
    q = w;
    m = w;
    p1 = zeros(size(model_w));
    thetaaa=p1;
    
    mu    = 1;
    betha = 10;
    mumax = 10000;
    i = 1;
    params.admm_iterations=2;
    T = prod(use_sz);
    h=T*real(ifft2(h_f));
%     hw=bsxfun(@times,h,model_w);
    hw=h;
    Hh=sum(hw.^2,3);
%     Hh=sum(real(bsxfun(@times,h_f(:),conj(h_f(:)))));
    
    %   ADMM
    while (i <= params.admm_iterations)
        %   solve for w- please refer to the paper for more details
      %  w = (q-m)/(1+(params.admm_lambda1/mu)*Hh);
        w = bsxfun(@rdivide,(q-m),(1+(params.admm_lambda1/mu)*Hh));
        %   solve for q
%         q=(params.admm_lambda2*model_w + mu*(w+m))/(params.admm_lambda2 + mu);
        q=(params.admm_lambda2*(model_w + p1)+ mu*(w+m))/(params.admm_lambda2 + mu);
        
        %update p
        thr1 = params.alpha1/params.beta1;
%         if state.frame==1
%         past_h = state.f_f; 
%             end
            temp = (w - (thetaaa/params.beta1)  - model_w);
%             thr = 0.3*max(temp(:));
            p1 = wthresh(temp,'h',0.5*max(temp(:)));
%             state.p = 1- state.p;
% %=============only for plotting=======================
%             mean_p1 = mean(p1,3);
%             mean_p1(mean_p1<0) = 0;
%             mean_p1 = -1*mean_p1;
%             colormap jet
%             figure(3)
% %             subplot(1,3,3)
%             imshow(mean_p1,[])
% %             surf(mean_p1)
%             title('B_w')
% %             subplot(1,3,2)
% %             imshow(mean(temp,3),[])
%             hold on   
%             colormap jet
%             nm=[num2str(state.frame) '_Bw.jpg']
% saveas(gca,nm)
% %=============only for plotting ends=======================================
%             p_f = fft2(p);
%             
            % update theta            
           thetaaa = thetaaa + params.beta1*(w - model_w - p1);
            
            
            % update beta
            params.beta1 = params.rou1*params.beta1;

        
        %   update m
        m = m + (w - q);
        
        %   update mu- betha = 10.
        mu = min(betha * mu, mumax);
        i = i+1;
               
    end


end