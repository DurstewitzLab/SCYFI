
# Searcher for CYcles and FIxed points (SCYFI)
This package contains the code from [Eisenmann L., Monfared M., Göring N., Durstewitz D. Bifurcations and loss jumps in RNN training, Thirty-seventh Conference on Neural Information Processing Systems, 2023,
{https://openreview.net/forum?id=QmPf29EHyI}]. Please cite this work when using the code provided herewith.

We introduce a novel heuristic algorithm for detecting all fixed points and k-cycles in ReLU-based RNNs

Preliminary, more Information, data and Notebooks for all the plots will follow shortly
## Table of Contents

- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Usage](#usage)
- [License](#license)

## Getting Started

These instructions will guide you through setting up the project environment and running the main function.

### Installation

1. Clone this repository to your local machine:

   ```shell
   git clone [https://github.com/DurstewitzLab/SCYFI]
   cd SCYFI
   ```

2. Create and activate a new Julia environment:

   ```shell
   julia --project=. # This activates the project-specific environment
   ```

3. Install the required packages by activating the package manager (press `]` in the Julia REPL; Julia 1.8.3 is required for importing the DataFrames to create the plots):

   ```julia
   activate .
   instantiate
   ```

### Usage

1. Run the code in the file `main.jl` in your project directory and calling the function with the required parameters:

   ```julia

   # Set up PLRNN parameters
   A = ...
   W = ...
   h = ...
   required_order = ...

   cycles, eigenvalues =  find_cycles(A, W, h, required_order ,outer_loop_iterations=100,inner_loop_iterations=500)

   ```
2. The parameters A,W,h are the parameters of the PLRNN as matrices, the required order is the maximum order you want to find e.g. if required_order=10 all orders from 1 to 10 will be computed for the given parameters. outer_loop_iterations are the number of initializations of the code and a hypereparameter. inner_loop_iterations are the maximum number of allowed iterations of the algorithm and a hyperparameter as well. For more details see the paper: [PLACEHOLDER].

3. For using the shallow PLRNN just hand over the parameters as in this example:

   ```julia

   # Set up shPLRNN parameters

    A = [0.6172450705591427, 0.5261273846061184]
    W₁ = [-1.022331291385995 -0.6068651009735164 0.005478115970447768 -0.6765758765817282 0.17667276783032312 -0.37241595029711383 -0.2799681077442852 1.6336122869854053 0.7388068389577566 0.43655916960874785; -0.23031703096807454 -0.155167269588236 1.1743020054655264 1.4693401983283279 -1.141192841208352 0.11938698490497139 0.6192500266755361 0.03950302999313116 -0.9179498107708933 -0.1216362805456489]
    W₂ = [1.753949852408234 -0.692574927107241; -0.45303568496148183 -0.5365936668032565; 0.07984706960954363 -0.48651643130319855; -1.0455124065967838 -0.22986736948781128; 0.048362883726876985 0.8959123953895494; -1.0545422354241465 0.5685368747406444; -0.43826625604171476 -2.1955495493951815; -0.8981129185384389 -0.6454540072455006; 0.6162103523913983 -0.8644618121879155; -1.2236281701654421 -2.059927291272103]
  
    h₁ = [-0.5480895548836227, -0.2922735885352696]
    h₂ = [0.5352937111114038, -1.110030373073419, -1.3146036515301616, 0.2748467715335772, -1.4155203620983157, 0.7891282169615852, -0.13084812694281087, -0.40652418385647066, -0.9383323642698853, -0.9983356016811977]

    FPs,eigenvals =find_cycles(A, W₁,W₂, h₁,h₂,4,outer_loop_iterations=10,inner_loop_iterations=60)

   ```

3. Execute the `main.jl` script in your project environment:

   ```shell
   julia --project=. main.jl
   ```


