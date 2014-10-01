function out = hs(wk,L)
    L = 1:L;
    res=sum(wk.*L)
    res/sum(L)
end
