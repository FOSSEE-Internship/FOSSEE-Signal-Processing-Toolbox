function [k,v]= tf2latc(varargin)

// To convert transfer function filter parameters to lattice filter form
// Calling sequences
//
//
//[k,v]= tf2latc(b,a) : GIves both the lattice and ladder parameters on providing the numerator and 
// denominator transfer function coefficients
//
//k= tf2latc(1,a) : Outputs the lattice parameters for an all pole lattice filter
//
//[k,v]= tf2latc(1,a) : Outputs both the lattice and ladder parameters for an all pole lattice filter
//
//k= tf2latc(b) : Gives the lattice parameters for an FIR lattice filter
//
//k= tf2latc(b,'phase') : 'phase' denotes the type of FIR filter, which can be 'max'(maximum phase filter) and 'min' (minimum phase filter)

//Input parameters:
//        b: Numerator coefficients of the transfer function
//        a: Denominator coefficients of the transfer function
//
//Output Parametrs:
//        k: lattice parameters
//        v: ladder parmeters
//
//Example:
//
//        Convert an IIR filters to its corresponding lattice parameters
//        a=[1 1/5 3/5];
//        k=tf2latc(1,a);
//
//Author: Shrenik Nambiar
//
//References: John G.Proakis, Dimitris G.Manolakis, Digital Signal Processing, Pearson Publishers,//Fourth Edition
//            M.H Hayes, Statistical Digital Signal Processing and Modelling,John Wiley and Sons,1996
//
//Input validation statements


        if(argn(2)<1) then
            error("Atleast one input argument required");
        end
        
        b= varargin(1);
        a = [];
        phase='';
        
        if (max(abs(b)) == 0) then
            error("Numerator coefficients should not be zero");
        end 
        
//b= b./b(1);   //normalizing
//a= a/a(1);
        
        b=b(:);   //converting into column vectors
        a=a(:);

//According to the input given by the user,the below piece of code will direct the flow exectution to the appropriate function.

        if(argn(1)==2 & length(varargin)==2) then
            if(varargin(1)==1) then
                a= varargin(2);
                [k v]= allpole2latc(b,a);
            else
                b= varargin(1);
                a= varargin(2);
                [k v]= iir2latc(b,a);
            end
        elseif(argn(1)==1 & length(varargin)==2) then
            if(type(varargin(2))==10) then
                b= varargin(1);
                phase= varargin(2);
                select phase
                case "max" then
                    [k v]= fir2latc(b,a);
                case "min" then
                    [k v]= fir2latc(b,a);
                else
                    error("Invalid option, input should either be max or min");
                end
            else
                a= varargin(2);
                b= varargin(1);
                [k v]= allpole2latc(b,a);
            end
        elseif(argn(1)==1 & length(varargin)==1) then
                b= varargin(1);
                [k v]= fir2latc(b,a);
        else
            error("Too many input arguments");
        end
        
        
endfunction

function [k,v]= allpole2latc(b,a)

    k= poly2rc(a);
    v= [b;zeros(length(k))];
    
endfunction


function [k,v]= iir2latc(b,a)
    
    [b,a] = eqtflength(b,a);        //to make the size of numerator and denominator equal
    len= length(a);
    k= poly2rc(a);
    
    [p,temp] = rlevinson(a,1);
    v= zeros(len,1);
    
    for i = len:-1:1,
        term= temp*v;
        v(i)= b(i)-term(i);
    end
    v=flipdim(v,1);
endfunction

function [k,v]= fir2latc(b,a)
    
    v = [];
    if(argn(2)==1) then
        v=b;
        k=zeros(length(v)-1,1);
    elseif(argn(2)==2) then
        if(strcmpi(phase,'max')) then
            b= conj(b($:-1:1));             //conjugating the polynomial to make it minimum phase filter
        end
        k= poly2rc(a);
    end

endfunction
