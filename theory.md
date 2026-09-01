# Finite Element Method for 2D and 3D Trusses

Theoretical background for the truss solver, following the notation and derivation used in D. V. Hutton, *Fundamentals of Finite Element Analysis* (McGraw-Hill).

---

## 1. The Bar (Truss) Element in Local Coordinates

A truss (pin-jointed bar) element carries axial load only. Consider a single bar element connecting global nodes $1$ and $2$, with cross-sectional area $A$, elastic modulus $E$, and length $L$. In its own **local** axis (aligned with the bar), the element has one degree of freedom per node: the local axial displacements $U_1^{(e)}$ and $U_2^{(e)}$.

Treating the bar as a linear spring of stiffness $AE/L$, the local element stiffness matrix relates local nodal forces to local nodal displacements:

![localimage](images\local_el.jpg)
$$
\begin{Bmatrix} f_1 \\ f_2 \end{Bmatrix}
= \frac{AE}{L}
\begin{bmatrix} 1 & -1 \\ -1 & 1 \end{bmatrix}
\begin{Bmatrix} U_1^{(e)} \\ U_2^{(e)} \end{Bmatrix}
$$

so the **local element stiffness matrix** is

$$
[k^{(e)}] = \frac{AE}{L}
\begin{bmatrix} 1 & -1 \\ -1 & 1 \end{bmatrix}
$$

This local stifness matrix is the same $2\times2$ matrix regardless of whether the element sits in a 2D or 3D truss. Everything that follows is about correctly *transform* this matrix into the global coordinate system. Element stiffness matrixes are singular and symetrical. 

---

## 2. Coordinate Transformation (2D)

Each element is oriented in the global $x$–$y$ plane at some angle $\theta$, measured from the global $x$-axis to the element's own axis. Using node $i$ and node $j$'s global coordinates $(x_i,y_i)$ and $(x_j,y_j)$, define the direction cosine and sine as:

$$
c = \cos\theta = \frac{x_j - x_i}{L}, \qquad
s = \sin\theta = \frac{y_j - y_i}{L}, \qquad
L = \sqrt{(x_j-x_i)^2 + (y_j-y_i)^2}
$$
![global_2D](images\notation.jpg)
Each node has two global displacement components. For a truss with $n$ nodes, all global displacements are collected in a single vector $\{U\}$ of length $2n$, and node $i$'s pair of components sits at positions $2i-1$ and $2i$. $U_{2i-1}$ is the horizontal displacement of node $i$ and $U_{2i}$ its vertical displacement (likewise $U_{2j-1}, U_{2j}$ for node $j$). 

These four entries, $\{U_{2i-1},\,U_{2i},\,U_{2j-1},\,U_{2j}\}$, are the global degrees of fredoom (DOF) of this particular element formalized in 4 entries as the element's **transformation vector** $\{L^{(e)}\}$.

For an element connecting global nodes $i$ and $j$, the **transformation vector** $\{L^{(e)}\}$ is, for a 2D truss (2 dof/node):

$$
\{L^{(e)}\} = \begin{bmatrix} 2i-1 & 2i & 2j-1 & 2j \end{bmatrix}
$$


The **local displacement** $U_1^{(e)}$ and $U_2^{(e)}$ at each node is the projection of the global displacements onto the bar axis:

$$
U_1^{(e)} = c\,U_{2i-1} + s\,U_{2i}, \qquad U_2^{(e)} = c\,U_{2j-1} + s\,U_{2j}
$$

which is written in matrix form as $\{U^{(e)}\} = [R]\{U\}$, where R represents the rotation matrix (or called also transformation matrix) defined:
$$
[R] = \begin{bmatrix} c & s & 0 & 0 \\ 0 & 0 & c & s \end{bmatrix}
$$

### Global element stiffness matrix (2D)

Applying the standard congruence transformation $[K^{(e)}] = [R]^T[k^{(e)}][R]$ to the local $2\times2$ matrix gives the $4\times4$ **element stiffness matrix in global coordinates**:

$$
[K^{(e)}] = \frac{AE}{L}
\begin{bmatrix}
c^2 & cs & -c^2 & -cs \\
cs & s^2 & -cs & -s^2 \\
-c^2 & -cs & c^2 & cs \\
-cs & -s^2 & cs & s^2
\end{bmatrix}
$$

ordered with respect to the element's transformation vector $\{L^{(e)}\} = \{2i-1,\,2i,\,2j-1,\,2j\}$. Every 2D bar element in the mesh reduces to this same form, differing only in $c$, $s$, $L$, $A$, $E$, and which global dof its transformation vector points to. This matrix is also symetrical and singular. all stiffnes matrices are so, except when the Bounday conditions are applied. 

---

## 3. Coordinate Transformation (3D)

The extension to space trusses follows exactly the same logic with a third direction cosine. For a bar running from node $i$ at $(x_i,y_i,z_i)$ to node $j$ at $(x_j,y_j,z_j)$:

$$
L = \sqrt{(x_j-x_i)^2+(y_j-y_i)^2+(z_j-z_i)^2}
$$

$$
c_x = \frac{x_j-x_i}{L}, \qquad c_y = \frac{y_j-y_i}{L}, \qquad c_z = \frac{z_j-z_i}{L}
$$

is it useful to define an unitary vector $\lambda$ to compute direction cosines better:

$$ \boldsymbol{\lambda}^{(e)} = \frac{1}{L}\left[(X_j - X_i)\mathbf{I} + (Y_j - Y_i)\mathbf{J} + (Z_j - Z_i)\mathbf{K}\right]$$

$$\boldsymbol{\lambda}^{(e)} = \cos\theta_x\,\mathbf{I} + \cos\theta_y\,\mathbf{J} + \cos\theta_z\,\mathbf{K}$$


Each node now carries three global displacement components. Node $i$'s components sit at positions $3i-2$, $3i-1$ and $3i$ in the global vector $\{U\}$ (likewise $3j-2$, $3j-1$, $3j$ for node $j$), giving the element's 3D transformation vector $\{L^{(e)}\}$ the entries $\{U_{3i-2},\,U_{3i-1},\,U_{3i},\,U_{3j-2},\,U_{3j-1},\,U_{3j}\}$. The rotation matrix becomes $2\times6$:

$$
[R] = \begin{bmatrix} c_x & c_y & c_z & 0 & 0 & 0 \\ 0 & 0 & 0 & c_x & c_y & c_z \end{bmatrix}
$$

### Global element stiffness matrix (3D)

Applying $[K^{(e)}] = [R]^T[k^{(e)}][R]$ again yields the $6\times6$ element stiffness matrix in global coordinates:

$$
[K^{(e)}] = \frac{AE}{L}
\begin{bmatrix}
c_x^2 & c_xc_y & c_xc_z & -c_x^2 & -c_xc_y & -c_xc_z \\
c_xc_y & c_y^2 & c_yc_z & -c_xc_y & -c_y^2 & -c_yc_z \\
c_xc_z & c_yc_z & c_z^2 & -c_xc_z & -c_yc_z & -c_z^2 \\
-c_x^2 & -c_xc_y & -c_xc_z & c_x^2 & c_xc_y & c_xc_z \\
-c_xc_y & -c_y^2 & -c_yc_z & c_xc_y & c_y^2 & c_yc_z \\
-c_xc_z & -c_yc_z & -c_z^2 & c_xc_z & c_yc_z & c_z^2
\end{bmatrix}
$$

---

## 4. Assembly: the Direct Stiffness Method

Each element stiffness matrix $[K^{(e)}]$ is already expressed in terms of global displacement components, but only at that element's own transformation vector. To build the structure's global stiffness matrix $[K]$, every entry of $[K^{(e)}]$ must be added into the specified row/column of $[K]$ given by that transformation vector $\{L^{(e)}\}.$


$$
\{L^{(e)}\} = \begin{bmatrix} 2i-1 & 2i & 2j-1 & 2j \end{bmatrix}
$$

and for a 3D truss (3 dof/node):

$$
\{L^{(e)}\} = \begin{bmatrix} 3i-2 & 3i-1 & 3i & 3j-2 & 3j-1 & 3j \end{bmatrix}
$$

Note this $L^{(e)}$ is unrelated to the bar length $L$ used in section 1–3, same letter, but here it names the element's list of global dof, not a distance.

The global stiffness matrix is then assembled by superposition:

$$
K_{L^{(e)}(p),\,L^{(e)}(q)} \mathrel{+}= K^{(e)}_{p,q} \qquad \forall\, p,q \in \{1,\dots,2n_e\ \text{or}\ 3n_e\}
$$

i.e. each element contributes additively to the degrees of freedom in its transformation vector; nodes shared by multiple bars simply accumulate contributions from every connected element. This mapping step is exactly what `indexTransformer.m` computes and `appendBar.m` / `KAssembly.m` apply when scattering each element matrix into the global $[K]$.

The full system, before boundary conditions, is

$$
\{F\} = [K]\{U\}
$$

where $\{F\}$ is the global load vector and $\{U\}$ the global displacement vector, both of length $2n$ (2D) or $3n$ (3D) for $n$ nodes.

---

## 5. Applying Boundary Conditions (Partitioning)

$[K]$ as assembled is singular (rigid-body modes are unconstrained), so supports must be imposed before solving. The approach is to **partition** the system according to which displacements are known (prescribed, usually zero at supports) and which forces are known (applied loads at free nodes).

Every global DOF falls into exactly one of two sets:

- **Active dof, subscript $a$ :** displacement unknown, applied force known (the unrestrained, free dof).
- **Constrained dof, subscript $c$ :** displacement known (prescribed by a support, usually $0$), reaction force unknown.

Reorder $\{U\}$ and $\{F\}$ so all active DOF come first and all constrained DOF come last, and partition $[K]$ to match:

$$\begin{Bmatrix} F_c \\ F_a \end{Bmatrix} = \begin{bmatrix} K_{cc} & K_{ca} \\ K_{ac} & K_{aa} \end{bmatrix} \begin{Bmatrix} U_c \\ U_a \end{Bmatrix}$$

Here $U_c$ (the support displacements, typically $0$) is known and $F_a$ (applied loads at the active dof) is known; $U_a$ and $F_c$ (reaction forces) are the unknowns. This partition is what `partitionMatrix.m` builds, and solving it is the job of `UFSolver.m`.

---

## 6. Solving for Displacements

From the first (active) row of the partitioned system:

$$F_a = K_{aa}\,U_a + K_{ac}\,U_c$$

Since $U_c$ is known, this can be solved directly for the unknown active displacements:

$$U_a = K_{aa}^{-1}\big(F_a - K_{ac}\,U_c\big)$$

For the common case of homogeneous supports ($U_c = 0$), this reduces to $U_a = K_{aa}^{-1}F_a$.

---

## 7. Recovering Reaction Forces

With $U_a$ known, the second (constrained) row of the partitioned system gives the support reactions directly:

$$F_c = K_{cc}\,U_c + K_{ca}\,U_a$$

The full global displacement vector $\{U\}$ and global force vector $\{F\}$ are then reassembled from $U_a, U_c$ and $F_a, F_c$ by undoing the reordering from section 5. This and the following steps are what `postProcess.m` carries out.

---

## 8. Element Strain, Stress and Axial Force Recovery

Once the global displacement vector $\{U\}$ is known, each element's local axial strain and stress can be recovered by mapping its own global nodal displacements and transforming them back to local coordinates using the relations:

$$U_1^{(e)} = U_1^{(e)}\cos\theta + U_2^{(e)}\sin\theta$$
$$U_2^{(e)} = U_3^{(e)}\cos\theta + U_4^{(e)}\sin\theta$$

and for 3D:

$$U_1^{(e)} = U_1^{(e)}\cos\theta_x + U_2^{(e)}\cos\theta_y + U_3^{(e)}\cos\theta_z$$
$$U_2^{(e)} = U_4^{(e)}\cos\theta_x + U_5^{(e)}\cos\theta_y + U_6^{(e)}\cos\theta_z$$

Strain can be then computed as:

$$ \varepsilon = \frac{U_2- U_1}{L}$$

and stress is obtained by multiplying strain by its Young's modulus. For a 2D element with nodes $i,j$:

$$
\sigma^{(e)} = \frac{E}{L}
\begin{bmatrix} -c & -s & c & s \end{bmatrix}
\begin{Bmatrix} U_{2i-1} \\ U_{2i} \\ U_{2j-1} \\ U_{2j} \end{Bmatrix}
$$

and for a 3D element:

$$
\sigma^{(e)} = \frac{E}{L}
\begin{bmatrix} -c_x & -c_y & -c_z & c_x & c_y & c_z \end{bmatrix}
\begin{Bmatrix} U_{3i-2} \\ U_{3i-1} \\ U_{3i} \\ U_{3j-2} \\ U_{3j-1} \\ U_{3j} \end{Bmatrix}
$$
A positive result indicates tension, negative indicates compression. The internal axial force follows directly:

$$
f^{(e)} = A\,\sigma^{(e)}
$$

or using the $2\times2$ local stifness matrix as showed in section 1 once local element displacements ar known. 

---

## 9. Summary of the Solution Sequence

1. **Per element:** compute the geometry data, $L$, and $k^{(e)}$ $\rightarrow$ `BarElStiffness.m`.

2. **Assembly:** map each $[k^{(e)}]$ into $[K]$ using the element's transformation vector $\{L^{(e)}\}$ to get them in global coordinates $[K^{(e)}]$ and add them to the global stiffness matrix. $\rightarrow$ `indexTransformer.m`, `appendBar.m`, `KAssembly.m`.

3. **Boundary conditions:** partition $[K]$, $\{F\}$, $\{U\}$ into free/constrained sets $\rightarrow$ `partitionMatrix.m`.

4. **Solve:** compute unknown active displacements $U_a$ and constrained-dof reactions $F_c$ $\rightarrow$ `UFSolver.m`.

5. **Post-process:** recover element stresses and axial forces from $\{U\}$ $\rightarrow$ `postProcess.m`.

This sequence is identical in structure for 2D and 3D trusses; the only differences are the number of dof per node (2 vs. 3), the size of $[K^{(e)}]$ ($4\times4$ vs. $6\times6$), and the number of direction cosines used to build $[R]$.

---

### Reference

D. V. Hutton, *Fundamentals of Finite Element Analysis*, McGraw-Hill.
