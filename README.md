# Share_for_CAIE
# Optimal Scheduling of Ethylene Plants under Uncertainty: An Unsupervised Learning-based Data-Driven Strategy

- The available data, results, and MATLAB codes in this project are the exact data, results, and MATLAB codes used in the paper named **"Optimal Scheduling of Ethylene Plants under Uncertainty: An Unsupervised Learning-based Data-Driven Strategy"** submitted to **"Computers & Industrial Engineering"**.

- A brief description of each file is as follows:
  - main.m (MATLAB file): the main program
  - Sorted_clustered_data.m (MATLAB file): reorder the clustered data according to the clustering markers
  - Plot_clustered_data.m (MATLAB file): plot the clustering results of uncertain data (with the data center)
  - Plot_clustered_data_svc.m (MATLAB file): plot the clustering results of uncertain data (without the data center)
  - Plot_uncertainty_set.m (MATLAB file): plot uncertainty sets constructed based on the SVC method
  - solve_d.m (MATLAB file): solve the dual of SVC formulations
  - get_K.m (MATLAB file): calculate the kernel matrix
  - svc.m (MATLAB file): SVC algorithm
  - test_data.mat (data file): the uncertain data

- Notes:
  - To run the above program, the CVX toolbox and Gurobi solver should be installed in MATLAB.
  - The CVX can be downloaded from this page: http://cvxr.com/cvx/download/
  - The license of Gurobi can be received from this page: https://www.gurobi.com/downloads/end-user-license-agreement-academic/
  - The guide to using Gurobi with CVX can be obtained from this page: http://cvxr.com/cvx/doc/gurobi.html#gurobi
