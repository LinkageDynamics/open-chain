function [G3,remaining3]=splithelper3lgravity(VG3)
% [G3,remaining3]=splithelper3lgravity(VG3)
% Takes the expression once the acceleration components are removed and 
% isolates the gravity matrix

    syms g_x g_y g_z real

    [nlinks,~]=size(VG3);
    if nlinks ~= 3;warning('link count is wrong');end


for jj=1:nlinks
        clear sometempvariable
        [CF1, t1]=coeffs(VG3(jj),g_x,'All');
        if string(t1(1))=="g_x" % have g_x elements
            GG(jj,1)=simplify(CF1(1));
            sometempvariable=CF1(2)
        else
            GG(jj,1)=sym(0); %carry on c1
            disp('2')
            sometempvariable=CF1(1);
        end
        [CF1, t1]=coeffs(sometempvariable,g_y,'All');
        if string(t1(1))=="g_y" % have g_y elements
            GG(jj,2)=simplify(CF1(1));
            sometempvariable=CF1(2);
        else
            GG(jj,2)=sym(0); %carry on c1
            sometempvariable=CF1(1);
        end
        [CF1, t1]=coeffs(sometempvariable,g_z,'All');
        if string(t1(1))=="g_z" % have g_z elements
            GG(jj,3)=simplify(CF1(1));
            VV(jj)=CF1(2);
        else
            GG(jj,3)=sym(0); %carry on c1
            VV(jj)=CF1(1);
        end
    end
G3=GG;
remaining3=VV;
end