function [h,t] = stepz(b,varargin)
    if(argn(2)<1 | argn(2)>4) then
        error("Input arguments should lie between 1 and 4");
    end
    
    if(argn(1) ~=2) then
        error("Outpu argument should be 2");
    end
    flag= true;
    if(size(b)> [1 1]) then
        
        if(size(b,2) ~= 6) then
            error(" SOS must be k by 6 matrix");
        end
        flag = false;
        if argn(2)>1 then
            n= varargin(1);
        else
            n=[];
        end
        
        if argn(2)>2 then
            fs = varargin(2);
        else
            fs=1;
        end
        
        if( type(n) ~=8) then
            error("n must be of type double");
        end
        
        if(type(fs) ~= 8) then
            error("fs must be of type double");
        end
        
        if (type(b) ~=8) then
            error("            ");
        end
    end
    
        
        
    if flag then
        if(argn(2)>1)
            a= varargin(1);
                if (size(a)> [1 1]) then
                    error(" a has wrong input size");
                end
        else
            a=1;
        end
            
        if(argn(2)>2) then
            n= varargin(2);
        else
            n=[];
        end
            
        if(argn(2)>3) then
             fs= varargin(3);
        else
             fs=1;
        end
            
        if(type(n) ~=8) then
            error(" n must be of type double");
        end

        if(type(fs) ~=8) then
            error(" fs must be of type double");
        end            
            
        if( type(b) ~=8 & type(a)~= 8) then
            error("b and a should be of type double");
        end
            
    end
        
        t=0;
        N=[];
        
        if (argn(2)<2) then
            if flag
                n =impzlength(b,a);
            else
                n= impzlength(b);
            end
        elseif(length(n)>1)
            N= round(n);
            n =max(N)+1;
            M=  min(min(N),0);
        end
        
        t1 = (t:(n-1))'/fs;
        
        x = ones(size(t1));
        if flag
            s= filter(b,a,x);
        else
            s= sfilter(b,x);
        end
        
        if ~isempty(N) then
            s= s(N-m+1);
            t1= t1(N-m+1);
        end
        
endfunction
