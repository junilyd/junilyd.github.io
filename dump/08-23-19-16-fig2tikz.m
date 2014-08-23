%function fig2tikz(gcf,xlab,ylab,titl,type_str,svn_path)
%
% INPUTS: 
%       figure handle and labels
%       type_str: 2d for wide layout and 3d for square layout (surf plots)
%       svn_path: the path to svn dir (could be set in startup.m)
% OUTPUTS:
%       one *.tikz file as specified inside the file.
%       one *.tex file as specified inside the file.
%       Print of where these are being created
%
% DEPENDENCIES:
%       Dependent on matlab2tikz.m 
function fig2tikz(gcf,xlab,ylab,titl,type_str,svn_path) 
 
    xlabel(sprintf('%s',xlab),'FontSize',16);
    ylabel(sprintf('%s',ylab),'FontSize',16);
    
    titl_tex = titl; titl = strrep(titl,' ','_');
    filetikz = sprintf('%s/img/%s.tikz',svn_path,titl);
    filetex = sprintf('%s/img/%s.tex',svn_path,titl);
    system(sprintf('sudo rm %s && rm %s',filetex,filetikz)); 

    if type_str == '3d'
         matlab2tikz(sprintf('%s/img/%s.tikz',svn_path,titl),'width','9cm','height','8cm');
    end
    if type_str == '2d' 
        matlab2tikz(sprintf('%s',filetikz),'nosize',true);
    end
    system(sprintf('printf "\\n \\\\\\begin{figure}[htpb]\\n    \\centering\\n    \\input img/%s.tikz\\n    \\caption{Plot of %s}\\n    \\label{fig:%s}\\n \\\\\\end{figure}" >> %s',titl,titl_tex,titl,filetex));
    fprintf(sprintf('\n\nTwo files have been written:\n(image)\n    %s\nand\n(wrapper)\n    %s\n\nThis means that you can do:\n    input img/%s.tex in your document.\n\n',filetikz,filetex,titl));
end
