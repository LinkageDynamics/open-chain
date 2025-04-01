function [M3,VG3]=splithelper3lmass(tau)
% Helper function
    knockout=@(expr,vars) subs(expr,vars,zeros(size(vars))); % sets the symbolic vars to 0
    syms ddtheta_1 ddtheta_2 ddtheta_3 real

    [nlinks,~]=size(tau);
    if nlinks ~= 3;warning('link count is wrong');end

    tau1=expand(tau);

    [c{11}, t{11}]=coeffs(tau1(1),[ddtheta_1],'All');
    [c{12}, t{12}]=coeffs(tau1(1),[ddtheta_2],'All');
    [c{13}, t{13}]=coeffs(tau1(1),[ddtheta_3],'All');
    [c{21}, t{21}]=coeffs(tau1(2),[ddtheta_1],'All');
    [c{22}, t{22}]=coeffs(tau1(2),[ddtheta_2],'All');
    [c{23}, t{23}]=coeffs(tau1(2),[ddtheta_3],'All');
    [c{31}, t{31}]=coeffs(tau1(3),[ddtheta_1],'All');
    [c{32}, t{32}]=coeffs(tau1(3),[ddtheta_2],'All');
    [c{33}, t{33}]=coeffs(tau1(3),[ddtheta_3],'All');
    %    if length(t32)~=2;warning(sprintf('%s',t32));end
    for jj=[11:13 21:23 31:33];
        if length(t{jj})~=2;
            
            if length(t{jj})==1;% replace with a symbolic 0
                c{jj}=sym(0);
                disp(sprintf('Note: setting jj=%d  to 0 (t{jj}=%s )',jj,t{jj}));
            else
                warning(sprintf('jj=%d t{jj}=%s',jj,t{jj}));
            end 
        end
    end
   
    M3=[simplify(c{11}(1)), simplify(c{12}(1)), simplify(c{13}(1));
        simplify(c{21}(1)), simplify(c{22}(1)), simplify(c{23}(1));
        simplify(c{31}(1)), simplify(c{32}(1)), simplify(c{33}(1)) ];
    %%     
    VG3(1)=knockout(tau1(1),[ddtheta_1, ddtheta_2, ddtheta_3]); 
    VG3(2)=knockout(tau1(2),[ddtheta_1, ddtheta_2, ddtheta_3]);
    VG3(3)=knockout(tau1(3),[ddtheta_1, ddtheta_2, ddtheta_3]);
    VG3=VG3(:); % make it a column

end % function

