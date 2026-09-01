% ------------------- PROBLEM DATA -------------------

     Name = "Example 3.2";
     mode = "2d";
     connect = [1 3; 2 3];
     L = [sqrt(2)*40 40];
     [stf, ke] = BarElStiffness([10e7 10e7] ,[1.5 1.5], L);
     cord = [0 0; 0 40; 40 40];
     avector = [0 0 0 0 1 1];
     F = zeros(size(avector,2),1);
     F([5,6]) = [500;300];
    
    % Name = "Example 3.6";
    % mode = "2d";
    % connect = [1 3; 1 4; 2 4; 3 4; 3 5; 5 4; 4 6; 5 6];
    % stf = zeros(1,8);
    % stf([1,3,4,5,7,8]) = BarElStiffness(10e6,1.5,40);
    % stf([2,6]) = BarElStiffness(10e6,1.5,40*sqrt(2));
    % cord = [0 0; 0 40; 40 0; 40 40; 80 0; 80 40];
    % 
    % avector = [0 0 0 0 1 1 1 1 1 1 1 1]; % Defining constrained displacements
    % F = zeros(size(avector,2),1);
    % % Definig forces
    % F(6) = -2000;
    % F([9,11,12]) = [2000; 4000; 6000]; 
    
    
    
    % Name = "Example 3.8";
    % mode = "3d";
    % connect = [1 2; 1 4; 2 4; 3 4];
    % stf = 3e5*ones(1,4);
    % cord = [0 0 30; 0 0 -30; 0 -30 0; 40 0 0];
    % avector = [0 0 0 0 0 0 0 0 0 1 1 1];
    % F = zeros(size(avector,2),1);
    % F(11) = -5000;



Fa = F(avector ~= 0);
Uc = avector(avector == 0)';
KG = KAssembly(connect, stf, cord, mode)  % Global Stiffness Matrix
M = partitionMatrix(KG, avector);         % Partitioning the matrix and aplyong boundary conditions

[Ua, Fc] = UFSolver(M, Uc, Fa)            % SOlving for unkonwn displacements and reaction forces
U = [Uc;Ua]

[epsilon, sigma] = postProcess(connect,cord,U,10e7,mode)    % Solving for stress and strain
plotTruss(connect,cord,U,2000,Name)                          % Plottig the truss
