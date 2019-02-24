
%Assignment 2 Part 1 B%
%ELEC 4700 RICHARD FINNEY 100967048%

%initiailizing the dimensions of our matrices, ensuring ny is 3/2 times nx
nx = 50;
ny = (3/2)*50;

%In Part B), we are preparing and comparing two solutions. Again, we are
%using finite difference method, but this time in 2-D. We are then finding
%a solution using the analytical method, which works by iterating to
%complete the summation of an infinite series. It won't, however, be 
%infinite in this case. I will provide more discussion at the end of
%this code to further explain, and to answer the questions asked in the
%assignment outline

G = sparse(nx*ny,nx*ny);
Op = sparse(nx*ny,1);

%filling in the G matrix's bulk nodes and BC's using a loop, similar
%to what we did in PA-5 using the Finite Difference method

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
            Op(n) = 1;
        elseif y == 1
            G(n, :) = 0;
            G(n, n) = 1;
        elseif y == ny
            G(n, :) = 0;
            G(n, n) = 1;
        else
            G(n, n) = -4;
            G(n, n+1) = 1;
            G(n, n-1) = 1;
            G(n, n+ny) = 1;
            G(n, n-ny) = 1;
        end
    end
end


Voltage = G\Op;



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
axis tight
title("Voltage Suface plot using the numerical method in Two Dimensions")
xlabel("X position")
ylabel("Y position")
zlabel("Voltage")

%variables to be used in our anayltical solution
a = ny;
b = nx/2;

x2 = linspace(-nx/2,nx/2, 50);
y2 = linspace(0,ny,ny);

[i,j] = meshgrid(x2,y2);

sol2 = sparse(ny,nx);

%iterating to create a summation of the infinite series (finite in this
%case)

for n = 1:2:600
    
    sol2 = (sol2 + (cosh(n*pi*i/a).*sin(n*pi*j/a))./(n*cosh(n*pi*b/a)));
    figure(2)
    surf(x2,y2,(4/pi)*sol2)
    title("Voltage Suface plot using the analytical method in Two Dimensions")
    xlabel("X position")
    ylabel("Y position")
    zlabel("Voltage")
    axis tight
    view(-130,30);
    pause(0.001)
end
%the end
 
%DISCUSSION%

%The solution using a series does approach the solution that was created
%using the FD method. Note that that we were capped at 600 iterations due
%to the fact that this series equation contained the terms cosh and sinh.
%This is the maximum mumber of iterations that could be used to recreate
%the FD solution. When I iterate above 600 the plot no longer looks like
%the true solution. This is because the cosh and sinh values approach
%infinity aroung this value, which increases the error in the solution, so
%we should stop at 600 iterations for best results.

%Through judging the results obtained using both methods, I would like to
%compare and contrast the strengths and weaknesses of both methods. It
%seems that numerical solutions would be an applicable means of finding a
%solution, given that the information you are feeding it is not too
%complicated. It is a method that will work given you have the right
%computing power to handle the equations you throw into it. For very
%complex equations, the hardware one uses may not be able to handle it. 

%The analytical method, on the other hand, is better (quicker) at competing
%simpler equations, and is the method of choice when dealing with
%relatively small data sets (simpler equations). The limitations, however,
%can be surmised by observing this part of the assignment. Certain
%iteration values may cause a breakdown in the equation which limits it's
%reliable accuracy. One must understand the limits of the equation to avoid
%these possible pitfalls. 
