classdef testTrussSolver < matlab.unittest.TestCase
    % Validates the FEM truss pipeline against three known problems
    % from Hutton's "Fundamentals of Finite Element Analysis":
    % Example 3.2 (2D, 2-bar), Example 3.6 (2D, 8-bar), Example 3.8 (3D, 4-bar)

    properties
        tol = 1e-4
    end

    methods (Test)

        function testExample3_2(testCase)
            mode = "2d";
            connect = [1 3; 2 3];
            L = [sqrt(2)*40 40];
            [stf, ~] = BarElStiffness([10e7 10e7], [1.5 1.5], L);
            cord = [0 0; 0 40; 40 40];
            avector = [0 0 0 0 1 1];
            F = zeros(size(avector,2),1);
            F([5,6]) = [500;300];

            Fa = F(avector ~= 0);
            Uc = avector(avector == 0)';
            KG = KAssembly(connect, stf, cord, mode);
            M = partitionMatrix(KG, avector);
            [Ua, Fc] = UFSolver(M, Uc, Fa);

            Ua_expected = [5.3333; 1.7310] * 1e-4;
            Fc_expected = [-300; -300; -200; 0];

            testCase.verifyEqual(Ua, Ua_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(Fc, Fc_expected, 'AbsTol', 1e-3)

            % Equilibrium check
            F_all = zeros(size(avector,2),1);
            F_all(avector==1) = Fa;
            F_all(avector==0) = Fc;
            testCase.verifyEqual(sum(F_all(1:2:end)), 0, 'AbsTol', 1e-6); % Sum Fx
            testCase.verifyEqual(sum(F_all(2:2:end)), 0, 'AbsTol', 1e-6); % Sum Fy
        end

        function testExample3_6(testCase)
            mode = "2d";
            connect = [1 3; 1 4; 2 4; 3 4; 3 5; 5 4; 4 6; 5 6];
            stf = zeros(1,8);
            stf([1,3,4,5,7,8]) = BarElStiffness(10e6,1.5,40);
            stf([2,6]) = BarElStiffness(10e6,1.5,40*sqrt(2));
            cord = [0 0; 0 40; 40 0; 40 40; 80 0; 80 40];
            avector = [0 0 0 0 1 1 1 1 1 1 1 1];
            F = zeros(size(avector,2),1);
            F(6) = -2000;
            F([9,11,12]) = [2000; 4000; 6000];

            Fa = F(avector ~= 0);
            Uc = avector(avector == 0)';
            KG = KAssembly(connect, stf, cord, mode);
            M = partitionMatrix(KG, avector);
            [Ua, Fc] = UFSolver(M, Uc, Fa);
            U = [Uc;Ua];
            [strain, stress] = postProcess(connect,cord,U,10e6,mode);

            Ua_expected = [ 0.02133;
                            0.04085;
                           -0.01600;
                            0.04619;
                            0.04267;
                            0.15014;
                           -0.00533;
                            0.16614 ];

            Fc_expected = [-12000; -4000; 6000; 0];

            strain_expected = [5.33e-4;
                               3.77e-4;
                              -4.00e-4;
                               1.33e-4;
                               5.33e-4;
                              -5.67e-4;
                               2.67e-4;
                               4.00e-4 ];
            
            stress_expected = [5333;
                               3771;
                              -4000;
                               1333;
                               5333;
                              -5657;
                               2667;
                               4000 ];

            testCase.verifyEqual(Ua, Ua_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(Fc, Fc_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(strain, strain_expected, 'AbsTol', 1);
            testCase.verifyEqual(stress, stress_expected, 'AbsTol', 1);

            % Equilibrium check
            F_all = zeros(size(avector,2),1);
            F_all(avector==1) = Fa;
            F_all(avector==0) = Fc;
            testCase.verifyEqual(sum(F_all(1:2:end)), 0, 'AbsTol', 1e-6); % Sum Fx
            testCase.verifyEqual(sum(F_all(2:2:end)), 0, 'AbsTol', 1e-6); % Sum Fy
        end

        function testExample3_8(testCase)
            mode = "3d";
            connect = [1 2; 1 4; 2 4; 3 4];
            stf = 3e5*ones(1,4);
            cord = [0 0 30; 0 0 -30; 0 -30 0; 40 0 0];
            avector = [0 0 0 0 0 0 0 0 0 1 1 1];
            F = zeros(size(avector,2),1);
            F(11) = -5000;

            Fa = F(avector ~= 0);
            Uc = avector(avector == 0)';
            KG = KAssembly(connect, stf, cord, mode);
            M = partitionMatrix(KG, avector);
            [Ua, Fc] = UFSolver(M, Uc, Fa);

            Ua_expected = [0.01736; -0.06944; 0.0];
            Fc_expected = [-3333.3333; 
                                    0; 
                                 2500; 
                           -3333.3333; 
                                    0; 
                                -2500;
                            6666.6666; 
                                 5000; 
                                  0 ];

            testCase.verifyEqual(Ua, Ua_expected, 'AbsTol', 1e-3);
            testCase.verifyEqual(Fc, Fc_expected, 'AbsTol', 1e-3);

            % Equilibrium sanity check
            F_all = zeros(size(avector,2),1);
            F_all(avector==1) = Fa;
            F_all(avector==0) = Fc;
            testCase.verifyEqual(sum(F_all(1:3:end)), 0, 'AbsTol', 1e-6); % Sum Fx
            testCase.verifyEqual(sum(F_all(2:3:end)), 0, 'AbsTol', 1e-6); % Sum Fy
            testCase.verifyEqual(sum(F_all(3:3:end)), 0, 'AbsTol', 1e-6); % Sum Fz
        end

    end
end