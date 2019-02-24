%In Part 2d) of the assignment, we are observing the effect of varying
%sigma on the current density. Like in parts c) and d), we are iterating
%through a loop using different sigma values and plotting sigma vs current
%density, and then drawing a conclusion from the plot.


for sigma = 1e-2:1e-2:0.9

    
    %setting up variable matrices like in part 1 
    nx = 50;            
    ny = nx*3/2;        
    G = sparse(nx*ny);  
    Op = zeros(1, nx*ny);
    
    Sigmatrix = zeros(ny, nx);             % a sigma matrix is required for this part
    Sig1 = 1;                              % sigma value given outside the box
    Sig2 = sigma;                           % sigma inside box will be modified
   
    %bottleneck remains the same this time.
    box = [nx*2/5 nx*3/5 ny*2/5 ny*3/5]; 
        
    
    for x = 1:nx
        
        for y = 1:ny
            
            n = y + (x-1)*ny;
            
            if x == 1
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 1;
                
            elseif x == nx
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 0;
                
            elseif y == 1
                
                if x > box(1) && x < box(2)
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                end
                
            elseif y == ny
                
                if x > box(1) && x < box(2)
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                end
                
            else
                
                if x > box(1) && x < box(2) && (y < box(3)||y > box(4))
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig2;
                    G(n, n-1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                else
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig1;
                    G(n, n-1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                end
            end
        end
    end
        
    
    for Length = 1 : nx
        
        for Width = 1 : ny
            
            if Length >= box(1) && Length <= box(2)
                Sigmatrix(Width, Length) = Sig2;
                
            else
                
                Sigmatrix(Width, Length) = Sig1;
                
            end
            
            if Length >= box(1) && Length <= box(2) && Width >= box(3) && Width <= box(4)
                
                Sigmatrix(Width, Length) = Sig1;
                
            end
        end
    end
            
    
    Voltage = G\Op';
            
    
    sol = zeros(ny, nx, 1);
    
    for x = 1:nx
        
        for y = 1:ny
            
            n = y + (x-1)*ny;
            
            sol(y,x) = Voltage(n);
            
        end
    end
            
    
    [elecx, elecy] = gradient(sol);
            
    
    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
            
   
    figure(1)
    hold on
    if sigma == 0.01
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([sigma, sigma], [Currold, Currtot])
    end
    if sigma > 0.01
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([sigma-0.01, sigma], [Currold, Currtot])
        xlabel("Sigma")
        ylabel("Current Density")
    end
    title("The Effect of varying the sigma value on Current Density")
    
end

%the end%

%DISCUSSION%

%From the plot it is noticed that sigma and current density are
%proportional; an increase in simga leads to an increase in current
%density. This relationship is linear, which is to be expected from the
%formula J = sigma x electric field. 