%function graph(xlab,ylab,titl,x,y,leg,x1,y1,leg1,x2,y2,leg2,x3,y3,leg3)
function graphtikz(xlab, ylab, titl, x, y, leg, x1, y1, leg1, x2, y2, leg2, x3, y3, leg3)
close all; 
  
  if nargin == 6
     minx = min(x); miny = min(y); maxx = max(x); maxy = max(y); 
     plot(x,y,'linewidth',1.5); legend(sprintf('%s',leg));
  elseif nargin == 9
     minx = [min(x);min(x1)]; miny = [min(y);min(y1)]; maxx = [max(x);max(x1)]; maxy = [max(y);max(y1)]; 
     plot(x,y,x1,y1,'linewidth',1.5); legend(sprintf('%s',leg),sprintf('%s',leg1));
  elseif nargin == 12
     minx = [min(x);min(x1);min(x2)]; miny = [min(y);min(y1);min(y2)]; maxx = [max(x);max(x1);max(x2)]; maxy = [max(y);max(y1);max(y2)]; 
     plot(x,y,x1,y1,x2,y2,'linewidth',1.5); legend(sprintf('%s',leg),sprintf('%s',leg1),sprintf('%s',leg2));
  elseif nargin == 15
     minx = [min(x);min(x1);min(x2);min(x3)]; miny = [min(y);min(y1);min(y2);min(y3)]; maxx = [max(x);max(x1);max(x2);max(x3)]; maxy = [max(y);max(y1);max(y2);max(y3)]; 
     plot(x,y,x1,y1,x2,y2,x3,y3,'linewidth',1.5); legend(sprintf('%s',leg),sprintf('%s',leg1),sprintf('%s',leg2),sprintf('%s',leg3));
  else
      fprintf('===================================================\n\nYour input arguments are wrong, check "help graph"\n\n==============================================================')
  end    

    xlabel(sprintf('%s',xlab),'FontSize',16);
    ylabel(sprintf('%s',ylab),'FontSize',16);
    title(sprintf('%s',titl),'FontSize',18);
    grid on;
    
    titl_tex=titl;
    titl = strrep(titl,' ','_');
    filetikz = sprintf('/Users/OSX/Documents/m2tikz_test/img/%s.tikz',titl);
    matlab2tikz(sprintf('%s',filetikz),'nosize',true);
    close all;
    filetex = sprintf('/Users/OSX/Documents/m2tikz_test/img/%s.tex',titl);
    system(sprintf('printf "\\n \\\\\\begin{figure}[htpb]\\n    \\centering\\n    \\input img/%s.tikz\\n    \\caption{Plot of %s}\\n    \\label{fig:%s}\\n \\\\\\end{figure}" >> %s',titl,titl_tex,titl,filetex));
    fprintf(sprintf('\n\nTwo files have been written:\n(image)\n    %s\nand\n(wrapper)\n    %s\n\nThis means that you can do:\n    input img/%s.tex in your document.\n\n',filetikz,filetex,titl));


end
