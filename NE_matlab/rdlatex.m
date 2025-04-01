function b=rdlatex(a,opts)
% str=RDLATEX(sym,opts)
% probably integrate with latex
% modifies the latex function to do some expression substitution
% latex now handles 
% syms a12 a_12
    
% opts.splitpts (could) inserts '\\' to allow long equations with the latex
% split or aligned environments (see insert after)
if nargin==1
    opts.dummy=1;
    opts.trig=true;
end

if strcmp(class(a),'sym')
    b=latex(a);
elseif strcmp(class(a),'cell')
    b='\left(';
    for jj=1:length(a)-1;
        b=[b latex(a{jj}) ','];
    end
    b=[b latex(a{end}) '\right)'];
else
    b=latex(sym(a));
end

% Notation simplification: suggestion is to take the latex generated
% string and insert it below along with the replacement string

if isfield(opts,'trig') % short forms of trig
    if opts.trig
        b=strrep(b,'\cos\left(\theta _{1}+\theta _{2}\right)','c_{12}');
        b=strrep(b,'\cos\left(\theta _{1}+\theta _{3}\right)','c_{13}');
        b=strrep(b,'\cos\left(\theta _{2}+\theta _{3}\right)','c_{23}');
        b=strrep(b,'\cos\left(\theta _{1}+\theta _{2}+\theta _{3}\right)','c_{123}');
        b=strrep(b,'\cos\left(\theta _{1}\right)','c_1');
        b=strrep(b,'\cos\left(\theta _{2}\right)','c_2');
        b=strrep(b,'\cos\left(\theta _{3}\right)','c_3');
        b=strrep(b,'\sin\left(\theta _{1}+\theta _{2}\right)','s_{12}');
        b=strrep(b,'\sin\left(\theta _{1}+\theta _{3}\right)','s_{13}');
        b=strrep(b,'\sin\left(\theta _{2}+\theta _{3}\right)','s_{23}');
        b=strrep(b,'\sin\left(\theta _{1}+\theta _{2}+\theta _{3}\right)','s_{123}');
        b=strrep(b,'\sin\left(\theta _{1}\right)','s_1');
        b=strrep(b,'\sin\left(\theta _{2}\right)','s_2');
        b=strrep(b,'\sin\left(\theta _{3}\right)','s_3');
    end
else
    % remove the brackets around theta
        b=strrep(b,'\cos\left(\theta _{1}\right)','\cos\theta_{1}');
        b=strrep(b,'\cos\left(\theta _{2}\right)','\cos\theta_{2}');
        b=strrep(b,'\cos\left(\theta _{3}\right)','\cos\theta_{3}');
        b=strrep(b,'\sin\left(\theta _{1}\right)','\sin\theta_{1}');
        b=strrep(b,'\sin\left(\theta _{2}\right)','\sin\theta_{2}');
        b=strrep(b,'\sin\left(\theta _{3}\right)','\sin\theta_{3}');
end


% differentials
b=strrep(b,'\mathrm{dtheta}','{\dot\theta}');
b=strrep(b,'\mathrm{ddtheta}','{\ddot\theta}');
b=strrep(b,'\mathrm{dphi}','{\dot\phi}');
b=strrep(b,'\mathrm{ddphi}','{\ddot\phi}');
b=strrep(b,'\mathrm{domega}','{\dot\omega}');

b=strrep(b,'\mathrm{dotq}_','{\dot{q}_');
b=strrep(b,'\mathrm{ddotq}_','{\ddot{q}_');

% Variables
b=strrep(b,'\mathrm{Lcog}_{1}','L_{cog1}');
b=strrep(b,'\mathrm{Lcog}_{2}','L_{cog2}');
b=strrep(b,'\mathrm{Lcog}_{3}','L_{cog3}');
b=strrep(b,'\mathrm{Lcog}_{4}','L_{cog4}');


% matrix hack
% Prefer to use AMS bmatrix
b=strrep(b,'\left(\begin{array}{cccccccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{ccccccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{cccccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{ccccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{cccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{ccc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{cc}','\begin{bmatrix}');
b=strrep(b,'\left(\begin{array}{c}','\begin{bmatrix}');
b=strrep(b,'\end{array}\right)','\end{bmatrix}');

end

