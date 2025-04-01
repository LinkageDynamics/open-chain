%function [C,B]=splitV3(V3)


V3=expand(remaining3(:)); % make it a column at the same time

[nlinks,~]=size(V3);
if nlinks ~= 3;warning('link count is wrong');end

syms sdq1 sdq2 sdq3 dq1dq2 dq1dq3 dq2dq3 real

V3=subs(V3,dtheta_1*dtheta_1,sdq1);
V3=subs(V3,dtheta_2*dtheta_2,sdq2);
V3=subs(V3,dtheta_3*dtheta_3,sdq3);
V3=subs(V3,dtheta_1*dtheta_2,dq1dq2);
V3=subs(V3,dtheta_1*dtheta_3,dq1dq3);
V3=subs(V3,dtheta_2*dtheta_3,dq2dq3);

[c{1},t{1}]=coeffs(V3(1),[sdq1 sdq2 sdq3 dq1dq2 dq1dq3 dq2dq3]);
[c{2},t{2}]=coeffs(V3(2),[sdq1 sdq2 sdq3 dq1dq2 dq1dq3 dq2dq3]);
[c{3},t{3}]=coeffs(V3(3),[sdq1 sdq2 sdq3 dq1dq2 dq1dq3 dq2dq3]);


% Not sure how to do this yet, but brute force it for now.

% from t1,t2,t3 (PLANAR CASE ONLY)
%C3(1,:)=[0 c{1}(1) c{1}(2)];
%C3(2,:)=[c{2}(1) 0 c{2}(2)];
%C3(3,:)=[c{3}(1) c{3}(2) 0];
%B3(1,:)=[c{1}(3) c{1}(4) c1(5)];
%B3(2,:)=[0 c{2}(3) c{2}(4)];
%B3(3,:)=[c{3}(3) 0 0];


C3=sym(zeros(nlinks,nlinks));
B3=sym(zeros(nlinks*(nlinks-1)/2,nlinks)); % in case we can extend! n(n+1)/2-n

% of course we could have an inner loop to select from a cell array of variable names, but...
for jj=1:3
    res=string(t{jj})=="sdq1";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);C3(jj,1)=c{jj}(ii);end
    res=string(t{jj})=="sdq2";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);C3(jj,2)=c{jj}(ii);end
    res=string(t{jj})=="sdq3";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);C3(jj,3)=c{jj}(ii);end

    res=string(t{jj})=="dq1dq2";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);B3(jj,1)=c{jj}(ii);end
    res=string(t{jj})=="dq1dq3";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);B3(jj,2)=c{jj}(ii);end
    res=string(t{jj})=="dq2dq3";
    if sum(res)>=2 ; warning('panic in the disco');end
    if any(res); ii=find(res);B3(jj,3)=c{jj}(ii);end
end

%        [Vc, t1]=coeffs(VG{jj},g_x,'All');
%        if string(t1(1))=="g_x" % have g_x elements
%            GG(jj,1)=simplify(CF1(1));
%            sometempvariable=CF1(2)
%        else
%            GG(jj,1)=sym(0); %carry on c1
%            disp('2')
%            sometempvariable=CF1(1);
%        end
