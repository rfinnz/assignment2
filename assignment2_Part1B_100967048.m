nx = 50;
ny = (3/2)*50;

%we are going to need two matrices for this part. Not just a G matrix, but
%a matrix we can use for the operations of the G matrix. the solution will
%be in the form Ax = b, and to get x this will be  b\A, in this case it
%will be G\Op.


G = sparse(nx*ny,nx*ny);
Op = zeros(nx*ny,1);
for x = 1:nx
    for y = 1:ny
        
        n = y + (x-1)*ny;
        
        if x == 1 
            
            G(n,:) = 0;
            G(n,n) = 1;
            Op(n) = 1;
            
        elseif x == nx 
            
            G(n,:) = 0;
            G(n,n) = 1;
            Op(n) = 0;
            
        elseif y == 1 
            
            G(n, :) = 0;
            G(n, n) = -3;
            G(n, n+1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
      
        elseif y == ny
        
            G(n, n) = -3;
            G(n, n-1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
            
        else
            
            G(n, n) = -4;
            G(n, n+1) = 1;
            G(n, n-1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
            
        end
    end
end

Voltage =     G\Op;



%now, need to create matrix to be surfed (x,y,voltage)

sol = zeros(nx,ny,1);

for x = 1:nx
    for y = 1:ny
        
        n = y + (x-1)*ny;
        sol(x,y) = Voltage(n);
    end  
end   

figure(1)
surf(sol)
title("Voltage in one dimension")
view(-130,30)
