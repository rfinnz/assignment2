
% Assignment 2 Part 2 b). In this part of the assignment we are
% investigating mesh density. To do this we will start at a mesh size multiple
% of 10, and incrementally increase this size to observe the effect on the
% current density.

%nx will be incrementally increased using this loop. Note that meshsize
%replaces nx in this code.
for meshsize = 10:10:100

    %multiplying these values by the respective meshsize 
    ny = (3/2)*meshsize;         
    G = sparse(meshsize*ny);   
    Op = zeros(1, meshsize*ny); 
    
    
    Sigmatrix = zeros(ny, meshsize);       % The sigma matrix with nx set to meshsize
    Sig1 = 1;                              % sigma value given outside the box
    Sig2 = 10^-2;                          % sigma value given inside the box
        
   
    %bottleneck conditions with meshsize replacing nx
    box = [meshsize*2/5 meshsize*3/5 ny*2/5 ny*3/5];  
    
   %Filling in G matrix 
    for x = 1:meshsize
        
        for y = 1:ny
            
            n = y + (x-1)*ny;
            
            if x == 1
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 1;
                
            elseif x == meshsize
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
    
    %Just like in part a), except using different meshsizes
    for Length = 1 : meshsize
        
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
    
    
    sol = zeros(ny, meshsize, 1);
    
    for i = 1:meshsize
        
        for j = 1:ny
            
            n = j + (i-1)*ny;
            sol(j,i) = Voltage(n);
            
        end
    end
    
   %electric field found using gradient of voltage
    [elecx, elecy] = gradient(sol);
    
    %current desntiy is sigma times electric field
    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
    
   %plotting current density vs mesh size                                     
    figure(1)
    hold on
    
    if meshsize == 10
        
        Curr = sum(J, 1);                 
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([meshsize, meshsize], [Currold, Currtot])
        
    end
    if meshsize > 10
        
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([meshsize-10, meshsize], [Currold, Currtot])
        xlabel("Meshsize")
        ylabel("Current Density")
        
    end
    
    title("The effect of Mesh Size on Current Density")

end

%the end%

%DISCUSSION%

%Analyzing the results of the plot, we see that meshsize and current
%density are proportional; an increase in meshsize leads to an increase in
%current density, which is to be expected.