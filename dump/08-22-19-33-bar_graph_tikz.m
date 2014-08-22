%function bar_graphtikz(x,y,xlab,ylab,titl)
function bar_graphtikz(x,y,xlab,ylab,titl)
close all;    

    bar(x,y);      
    xlabel(sprintf('%s',xlab),'FontSize',16);
    ylabel(sprintf('%s',ylab),'FontSize',16);
    title(sprintf('%s',titl),'FontSize',18);
    grid on;
    axis([min(x) max(x) min(y) max(y)*1.05]);
    
   system(sprintf('open %s/barplot_%s.pdf',folder,titl));


    xlabel(sprintf('%s',xlab),'FontSize',16);
    ylabel(sprintf('%s',ylab),'FontSize',16);
    title(sprintf('%s',titl),'FontSize',18);
    grid on;
    
    titl_tex = titl;
    titl = strrep(titl,' ','_');
    filetikz = sprintf('/Users/OSX/Documents/m2tikz_test/img/%s.tikz',titl);
    matlab2tikz(sprintf('%s',filetikz),'nosize',true);
    close all;
    filetex = sprintf('/Users/OSX/Documents/m2tikz_test/img/%s.tex',titl);
    system(sprintf('printf "\\n \\\\\\begin{figure}[htpb]\\n    \\centering\\n    \\input img/%s.tikz\\n    \\caption{Plot of %s}\\n    \\label{fig:%s}\\n \\\\\\end{figure}" >> %s',titl,titl_tex,titl,filetex));
    fprintf(sprintf('\n\nTwo files have been written:\n(image)\n    %s\nand\n(wrapper)\n    %s\n\nThis means that you can do:\n    input img/%s.tex in your document.\n\n',filetikz,filetex,titl));


end
