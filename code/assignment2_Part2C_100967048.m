%In part 2c) we are investigating narrowing of the bottle neck, this is
%done by changing the y valyes of the box that we used in parts a and b.
%Again, we are going to loop through values to multiply the y values and
%observe the effects this has on current. stay tuned for more

for bottleneck = 0.1:0.01:0.9

 %setting up variable matrices like in part 1   
    nx = 50;            
    ny = nx*3/2;        
    G = sparse(nx*ny);  
    Op = zeros(1, nx*ny);
    
    Sigmatrix = zeros(ny, nx); % a sigma matrix is required for this part
    Sig1 = 10^-2;              % sigma value given outside the box
    Sig2 = 1;                   % sigma value given inside the box
   
    
    %The bottleneck is incrementally "narrowed" by modifying the y values
    %of the box
    box = [nx*2/5 nx*3/5 ny*bottleneck ny*(1-bottleneck)]; 
    
    %filling in the G matrix
    for i = 1:nx
        
        for j = 1:ny
            
            n = j + (i-1)*ny;
            
            if i == 1
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 1;
                
            elseif i == nx
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 0;
                
            elseif j == 1
                
                if i > box(1) && i < box(2)
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                end
                
            elseif j == ny
                
                if i > box(1) && i < box(2)
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                end
                
            else
                
                if i > box(1) && i < box(2) && (j < box(3)||j > box(4))
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig1;
                    G(n, n-1) = Sig1;
                    G(n, n+ny) = Sig1;
                    G(n, n-ny) = Sig1;
                    
                else
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig2;
                    G(n, n-1) = Sig2;
                    G(n, n+ny) = Sig2;
                    G(n, n-ny) = Sig2;
                    
                end
            end
        end
    end
    
    
    for Length = 1 : nx
        
        for Width = 1 : ny
            
            if Length >= box(1) && Length <= box(2)
                Sigmatrix(Width, Length) = Sig1;
                
            else
                Sigmatrix(Width, Length) = Sig2;
                
            end
            
            if Length >= box(1) && Length <= box(2) && Width >= box(3) && Width <= box(4)
                
                Sigmatrix(Width, Length) = Sig2;
            end
        end
    end
        
    
    Voltage = G\Op';
    
    
    sol = zeros(ny, nx, 1);
    
    for i = 1:nx
        
        for j = 1:ny
            
            n = j + (i-1)*ny;
            sol(j,i) = Voltage(n);
            
        end
    end
        
    %The electric field can be derived from the surface voltage using a
    %gradient
    [elecx, elecy] = gradient(sol);
        
    %J, the current density, is calculated by multiplying sigma and the
    %electric field together.

    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
        
   %plotting bottleneck vs current
    figure(1)
    hold on
    
    if bottleneck == 0.1
        
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([bottleneck, bottleneck], [Currold, Currtot])
        
    end
    
    if bottleneck > 0.1
        
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([bottleneck-0.01, bottleneck], [Currold, Currtot])
        xlabel("Bottleneck");
        ylabel("Current Density");
        
    end
    
    title("The Effect of narrowing bottleneck on the Current Density")

end

%DISCUSSION%

%Observing the plot, we see that narrowing the bottleneck incrementally
%leads to a decrease in the current value, However, after a certain point,
%when the value of narrowing reaches 0.5, the current stagnates and does
%not decrease any more and stays fixed at about 71.5. Note that the
%relationship is not a linear decrease, but resembles an exponential
%decrease before current density   stops decreasing.