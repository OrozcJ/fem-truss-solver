# T-SOLVER

A MATLAB package with functions to Solve 3D and 2D Truss structures.

![MATLAB](https://img.shields.io/badge/MATLAB-R2025b-orange.svg) [![License: MIT + Commons Clause](https://img.shields.io/badge/License-MIT%20%2B%20Commons%20Clause-yellow.svg)](LICENSE)

**Note:** Licensed under MIT with a Commons Clause restriction, free to use and modify, but commercial use/resale requires prior consent. See [LICENSE](LICENSE.md) for details.

![Opening image]("images\3.6\Figure_3_6.png")

# Intro 

The following library groups a set of functions useful for **Finite Element Method** with springs and bar elements, making it easier to automate the process while following the general **FEM** procedure. 

This project was intended as a way to apply the theory and computational approach of the **FEM** building it from scratch.  Considering the limitations of **truss elements** and the assumptions made during the formulation as seen in the theory file, this is an academic project solver and should only be used to analyze 2D or 3D truss structures under static conditions. 

# Features

- 2D and 3D truss analysis.
- Element stiffness formulation from first principles.
- Transform element stiffness from local to global coordinates. 
- Assemble the global stiffness matrix from a set of elements and its coordinates. 
- Displacement/reactions solving via partitioning.
- Strain/Stress post processing from previous results. 
- Built-in visualization (`plotTruss`).

# Function Reference

| Function             | Description                                                                     | Inputs                                                                    | Outputs            |
| -------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ------------------ |
| `BarElStiffness`     | Computes local element stiffness, and local stiffness matrix for a bar element. | `E`, `A`, `L`                                                             | `stf`, `ke`        |
| `transformStiffness` | Transforms local stiffness matrix to global coordinates.                        | local `ke`, `coordinates`                                                 | global `ke`        |
| `KAssembly`          | Assembles the global stiffness matrix from all elements.                        | `connectivity`, `stf`, `coordinates`                                      | `KG`               |
| `partitionMatrix`    | Partitions the global matrix by active/constrained DOFs.                        | `KG`, `active_vec`                                                        | `M`                |
| `UFSolver`           | Solves for unknown displacements and reaction forces.                           | `M`, `Uc`, `Fa`                                                           | `Ua`, `Fc`         |
| `postProcess`        | Computes strain and stress from nodal displacements.                            | `connectivity`, `coordinates`, `U`, `E`, `dim`                            | `strain`, `stress` |
| `plotTruss`          | Plots the (optionally scaled/deformed) truss geometry.                          | `connectivity`, `coordinates`, `displacements`, `multiplier`, `plotTitle` | MATLAB figure.     |
| `indexTransformer`   | Converts a pair of node indices (i,j) into the corresponding location vector.   | `idx`, `dim`                                                              | `L`                |
| `appendBar`          | Adds a global element stiffness matrix into the global stiffness matrix K.      | `K`, `Ke`, `L`                                                            | `K`                |

# Quick start

To run the following code, the minimum necessary are the functions contained in `src`. You can download them or add them to the path directly:

```
addpath('src')
```

# Usage

## Defining Problem data
To follow the general FEM procedure, you should first create a vector describing the domain of the problem, namely, the coordinates of each node and the connections between them. 

![Truss Example 3.2](images\3.2_example_intro\EX3.2-Hutton.png)

```
Name = "Example 3.2 - Hutton";
connection_vec = [1 3; 2 3];
crd = [0 0; 0 40; 40 40];
```
 After defining the Geometry of the problem the mechanical properties must be specified. 
 
```
L = [sqrt(2)*40 40];
[stf, ke] = BarElStiffness([10e7 10e7] ,[1.5 1.5], L);
```
 
 Finally, define the Boundary conditions and the force vector following the node mapping convention. 
 
```
active_vec = [0 0 0 0 1 1];
F = zeros(size(active_vec,2),1);
F([5,6]) = [500;300];
```

## Solving the Problem
You can define the constrained displacement vector and the active force vector from the previous data. 

```
Fa = F(active_vec ~= 0);          
Uc = active_vec(active_vec == 0)';
```

The global matrix is obtained, then partitioned considering the active vector, and then you can solve for reaction forces `Fc` and active displacements`Uc`. 

```
KG = KAssembly(connection_vec, stf, crd)  % Global stiffness matrix
M = partitionMatrix(KG, active_vec);      % Partitioning the matrix 

[Ua, Fc] = UFSolver(M, Uc, Fa) % Solving for unknown displacements and reaction forces
U = [Uc;Ua]
```

```
KG =  
  
1.0e+06 *  
  
1.3258    1.3258  0        0   -1.3258   -1.3258  
1.3258    1.3258  0        0   -1.3258   -1.3258  
0         0       3.7500   0   -3.7500    0  
0         0       0        0    0         0  
-1.3258  -1.3258  -3.7500  0    5.0758    1.3258  
-1.3258  -1.3258  0        0    1.3258    1.3258


Ua =                  Fc =
  
1.0e-03 *             -300.0000  
                      -300.0000 
0.0533                -200.0000  
0.1729                 0
```
## Postprocessing & Visualization 
Finally, you can obtain strain and stress values introducing the displacements obtained and plot the resulting deformation.

```
[epsilon, sigma] = postProcess(connection_vec,crd,U,10e7,"2d") % Solving for strain and stress

plotTruss(connection_vec,crd,U,1000,Name) % Plotting the truss

------------------------------------------
epsilon =                sigma = 

1.0e-05 *                282.842  133.333
  
0.282   0.133  
```

![3.2 PLot](images\3.2_example_intro\3.2fig.png)


# References
[1] D. V. Hutton, Fundamentals of Finite Element Analysis, 1st ed. New York, NY, USA: McGraw-Hill, 2004.
