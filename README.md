# Hybrid-FOX-TSA
This repository contains the MATLAB implementation of the Hybrid FOX-TSA optimization algorithm
Hybrid FOX-TSA Implementation

This repository contains the MATLAB implementation of the Hybrid FOX-TSA optimization algorithm, designed to navigate complex search spaces and achieve superior performance in both benchmark functions and real-world optimization problems. The project includes implementations of various benchmark functions from CEC2014, CEC2017, CEC2019, CEC2020, and CEC2022, along with comparisons against standard optimization algorithms such as PSO, GWO, FOX, and TSA.

Features

Hybrid FOX-TSA algorithm combining exploratory and exploitative capabilities.

Benchmarking scripts for CEC2014, CEC2017, CEC2019, CEC2020, and CEC2022.

Comparative analysis against PSO, GWO, TSA, and FOX algorithms.

Visualization of convergence curves and performance metrics.

Requirements

MATLAB R2021b or later.

Optimization Toolbox (optional but recommended).

Files

Hybrid_FOX_TSA_func.m: Core implementation of the Hybrid FOX-TSA algorithm.

mainCEC2014.m, mainCEC2017.m, mainCEC2019.m, mainCEC2020.m, mainCEC2022.m: Benchmark testing scripts for different CEC suites.

PSO_func.m: Implementation of the Particle Swarm Optimization algorithm.

TSA_func.m: Implementation of the Tree-Seed Algorithm.

Usage

Clone the repository:

git clone https://github.com/SirwanRustay/Hybrid-FOX-TSA

Navigate to the directory and open MATLAB.

Run any of the main files for testing (e.g., mainCEC2014.m):

mainCEC2014

Results

Comparative performance of Hybrid FOX-TSA against other algorithms.

Statistical analyses of results, including t-tests and Wilcoxon signed-rank tests.

Benchmark results include:

Convergence speed

Solution quality

Computational efficiency

Citation

If you use this implementation in your research, please cite the following paper:

Sirwan A. Aula, Tarik A. Rashid,FOX-TSA: Navigating Complex Search Spaces and Superior Performance in Benchmark and Real-World Optimization Problems,Ain Shams Engineering Journal,Volume 16, Issue 1, 2025, 103185,ISSN 2090-4479,https://doi.org/10.1016/j.asej.2024.103185.Read the article on ScienceDirect

Abstract

In the dynamic field of optimization, hybrid algorithms have garnered significant attention for their ability to combine the strengths of multiple methods. This study presents the Hybrid FOX-TSA algorithm, a novel optimization technique that merges the exploratory capabilities of the FOX algorithm with the exploitative power of the TSA algorithm. The primary objective is to evaluate the efficiency, robustness, and scalability of this hybrid approach across multiple CEC benchmark suites, including CEC2014, CEC2017, CEC2019, CEC2020, and CEC2022, alongside real-world engineering design problems. The results demonstrate that the Hybrid FOX-TSA algorithm consistently outperforms established optimization techniques, such as PSO, GWO, and the original FOX and TSA algorithms, in terms of convergence speed, solution quality, and computational efficiency. Notably, the hybrid approach avoids premature convergence and navigating complex search spaces, producing optimal or near-optimal solutions in various test cases. For instance, the algorithm achieved superior performance in minimizing design costs in the Pressure Vessel and Welded Beam Design problems, as well as effectively handling the complex landscapes of the CEC2020 and CEC2022 benchmarks. These results affirm the Hybrid FOX-TSA algorithm as a powerful and adaptable tool for tackling complex optimization problems, particularly in high-dimensional and multimodal landscapes. The integration of statistical analyses, such as t-tests and Wilcoxon signed-rank tests, further supports the statistical significance of its performance improvements.

License

This project is licensed under the MIT License. See the LICENSE file for details.

Keywords

Multi-objective optimization, Hybrid optimization, FOX-TSA Algorithm, CEC benchmark suites, Particle swarm optimization, Grey wolf optimizer, Engineering design problems, Convergence analysis, Algorithm performance.

Contributing

Contributions are welcome! If you have improvements or suggestions, feel free to fork the repository and submit a pull request.

Contact

For questions or feedback, please contact the authors or open an issue on GitHub.

