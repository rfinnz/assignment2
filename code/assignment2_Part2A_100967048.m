%Part 2 a) in this part of the assignment, we are setting up a total of
%5 surface plots: sigma, voltage, the x and y components of the electric
%field and finally the current density plot. Comments are littered
%throughout the code to aid in the understanding in my process.

%setting up variables just like part 1
nx = 50;                
ny = (3/2)*nx;            
G = sparse(nx*ny);      
Op = zeros(1, nx*ny);    


Sigmatrix = zeros(nx, ny);    % a sigma matrix is required for this part
Sig1 = 1;                     % sigma value given outside the box
Sig2 = 10^-2;                 % sigma value given inside the box

%The box will be difined using a 1x4 matrix containing it's dimensions
box = [nx*2/5 nx*3/5 ny*2/5 ny*3/5]; 

for i = 1:nx
    
    for j = 1:ny
        
        
        if i > box(1) && i < box(2) && (j < box(3)||j > box(4))
            Sigmatrix(i, j) = Sig2;
            
        else
            Sigmatrix(i, j) = Sig1;
            
            
        end
    end
end

% Filling in G matrix with corresponding bottleneck conditions
for x = 1:nx
    
    for y = 1:ny
        
        n = y + (x-1)*ny;
        nposx = y + (x+1-1)*ny;
        nnegx = y + (x-1-1)*ny;
        nposy = y + 1 + (x-1)*ny;
        nnegy = y - 1 + (x-1)*ny;
        
        if x == 1
            
            G(n, :) = 0;
            G(n, n) = 1;
            Op(n) = 1;
            
        elseif x == nx
            
            G(n, :) = 0;
            G(n, n) = 1;
            Op(n) = 0;
            
        elseif y == 1

            G(n, nposx) = (Sigmatrix(x+1, y) + Sigmatrix(x,y))/2;
            G(n, nnegx) = (Sigmatrix(x-1, y) + Sigmatrix(x,y))/2;
            G(n, nposy) = (Sigmatrix(x, y+1) + Sigmatrix(x,y))/2;            
            G(n, n) = -(G(n,nposx)+G(n,nnegx)+G(n,nposy));
            
        elseif y == ny
            
            G(n, nposx) = (Sigmatrix(x+1, y) + Sigmatrix(x,y))/2;
            G(n, nnegx) = (Sigmatrix(x-1, y) + Sigmatrix(x,y))/2;
            G(n, nnegy) = (Sigmatrix(x, y-1) + Sigmatrix(x,y))/2;
            G(n, n) = -(G(n,nposx)+G(n,nnegx)+G(n,nnegy));
            
        else
            
            G(n, nposx) = (Sigmatrix(x+1, y) + Sigmatrix(x,y))/2;
            G(n, nnegx) = (Sigmatrix(x-1, y) + Sigmatrix(x,y))/2;
            G(n, nposy) = (Sigmatrix(x, y+1) + Sigmatrix(x,y))/2;
            G(n, nnegy) = (Sigmatrix(x, y-1) + Sigmatrix(x,y))/2;
            G(n, n) = -(G(n,nposx)+G(n,nnegx)+G(n,nposy)+G(n,nnegy));
            
        end
    end
end

% Sigma(x,y) Surface Plot
figure(1)
surf(Sigmatrix);
xlabel("X position")
ylabel("Y position")
zlabel("Sima")
axis tight
view([40 30]);
title("Sigma Surface Plot in the X and Y Planes")


Voltage = G\Op';


sol = zeros(ny, nx, 1);
for i = 1:nx
    for j = 1:ny
        n = j + (i-1)*ny;
        sol(j,i) = Voltage(n);
    end
end

%V(x,y) Surface Plot
figure(2)
surf(sol)
axis tight
xlabel("X position")
ylabel("Y position")
zlabel("Voltage")
view([40 30]);
title("Voltage Surface Plot with Given Bottleneck Conditions")

%The electric field can be derived from the surface voltage using a
%gradient

[elecx, elecy] = gradient(sol);

%X component of electric field surface plot
figure(3)
surf(-elecx)
axis tight
xlabel("X position")
ylabel("Y position")
zlabel("Electric Field")
view([40 30]);
title("The Surface Plot of the X-component of the Electric Field")

%Y component of electric field surface plot
figure(4)
surf(-elecy)
axis tight
xlabel("X position")
ylabel("Y position")
zlabel("Electric Field")
view([40 30]);
title("The Surface Plot of the Y-component of the Electric Field")

%J, the current density, is calculated by multiplying sigma and the
%electric field together. Combing the x and y matrices, a surface plot is
%derived by surfing this matrix.

J_x = Sigmatrix'.*elecx;
J_y = Sigmatrix'.*elecy;
J = sqrt(J_x.^2 + J_y.^2);

%J(x,y) Surface Plot
figure(5)
surf(J)
axis tight
xlabel("X position")
ylabel("Y position")
zlabel("Current Density")
view([40 30]);
title("Curent Density Surface Plot in the X and Y Planes")

%the end%