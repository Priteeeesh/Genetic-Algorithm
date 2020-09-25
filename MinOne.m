function z = MinOne(x1,x2)

    k = 0.5*sum(x1)/31;
    l = 0.5*sum(x2)/31;
    
    z = k+l-2*k^2-l^2+k*l;
end
