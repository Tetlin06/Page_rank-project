# PageRank Modeling Using Markov Chains

## Overview
This project implements a simplified **PageRank algorithm** using **Markov Chains** to model the probability distribution of a web surfer navigating a network of linked web pages. The core tasks include:
- **Crawling web pages** to build an **adjacency matrix**.
- **Constructing a transition probability matrix** based on link structure.
- **Handling dangling nodes** to ensure irreducibility.
- **Computing PageRank scores** using:
  - The **Eigenvector Method** (exact solution, computationally expensive).
  - The **Power Method** (iterative, efficient for large matrices).
- **Comparing performance** across different **network sizes (N)** and **damping factors (p)**.

---

## Requirements
- **MATLAB** (Tested on MATLAB R2023a)
- **Internet Connection** (for crawling web pages)
- `webread` and `addpath` functions should work properly in your MATLAB setup.

---

## File Structure
- **`pagerank_model.m`** – The main script that runs the PageRank calculations.
- **`surfer.m`** – The web crawler that collects URLs and builds the adjacency matrix.  
  - Contains an internal helper function **`hashfun`** for tracking visited URLs.
- **`PageRankResults.mat`** (optional) – A saved results file, if enabled.

---

## How to Run the Model
### 1. Open MATLAB
Navigate to the directory where the scripts are located.

### 2. Run the Main Script
Execute:
```matlab
pagerank_model
```
This will:
- Start crawling pages from the **root URL**.
- Construct the adjacency matrix **G**.
- Compute **PageRank scores** using both **Eigenvector** and **Power Method**.
- Print the **top-ranked pages** and **computation times**.

---

## Input Parameters and How to Modify Them
Several parameters control the behavior of the model. Modify these at the beginning of `pagerank_model.m`:

### 1. **Root URL**
Defines the starting webpage for the crawl.
```matlab
root_url = 'https://www.gradescope.com/'; % Change this to another website if desired
```

### 2. **Network Size (N)**
Defines the number of pages to collect.
```matlab
N_values = [100, 200, 300, 400, 500]; % Modify as needed
```
- Larger **N** means more links but **slower computation**.

### 3. **Damping Factor (p)**
Defines the probability of following a link vs. randomly jumping to another page.
```matlab
p_values = [0.05, 0.10, 0.85, 0.90, 0.95];
```
- **Low p (e.g., 0.05)** → Higher randomness, uniform-like distribution.
- **High p (e.g., 0.95)** → Stronger influence of network structure.

### 4. **Enable/Disable Progress Display**
Set to `1` to show progress, `0` for a faster run.
```matlab
printon = 0;
```

### 5. **MATLAB Path for `surfer.m`**
Ensure the path is correctly set to where `surfer.m` is located.
```matlab
addpath('/MATLAB Drive/HW 2');
```

---

## Understanding the Output
### 1. **Top 10 Pages (PageRank Results)**
For each (N, p) combination, the script prints the **top-ranked web pages**:
```
Top 10 pages using Eigenvector method for N = 100, p = 0.85:
1. https://example.com/page1 (Probability: 0.016126)
2. https://example.com/page2 (Probability: 0.010689)
...
```

```
Top 10 pages using Power method for N = 100, p = 0.85:
1. https://example.com/page3 (Probability: 0.015890)
...
```

### 2. **Performance Metrics**
The script prints computation times:
```
Performance for N = 100, p = 0.85:
Eigenvector method time: 0.0321 seconds
Power method time: 0.0023 seconds, iterations: 5
```
- **Eigenvector Method** is exact but slow (**O(N³) complexity**).
- **Power Method** is fast and scales well (**O(N × iterations)**).

### 3. **Performance Comparison Table**
A summary table is generated:
```
Performance Comparison Table:
         p = 0.05            p = 0.10           p = 0.85           p = 0.90           p = 0.95
N = 100  Eig: 0.029s  Power: 0.002s, 5 iter  
N = 300  Eig: 0.019s  Power: 0.002s, 6 iter  
N = 500  Eig: 0.061s  Power: 0.004s, 4 iter  
```

---

## Modifying the Web Crawler (`surfer.m`)
If you want to:
- **Change the types of links followed**: Modify this section inside `surfer.m`:
  ```matlab
  skips = {'.gif', '.jpg', '.pdf', '.css', '.js', 'google', 'twitter'};
  ```
  Add **unwanted sites** to prevent crawling unnecessary links.

- **Increase the number of crawled pages**: Modify `n` in:
  ```matlab
  [U, G] = surfer(root_url, n, printon);
  ```

---

## Troubleshooting
### 1. **Web Crawling Issues**
If `webread` fails:
- Ensure MATLAB has **internet access**.
- Try another root URL.
- Increase timeout settings in `webread`.

### 2. **Memory or Speed Issues**
- **Reduce `N_values`** for faster runs.
- **Lower `max_iterations`** in the Power Method:
  ```matlab
  max_iterations = 500;
  ```

### 3. **MATLAB Path Errors**
If `surfer.m` isn’t found:
- Run:
  ```matlab
  addpath('/correct/path/to/script');
  ```

---

## Future Improvements
- Implement **Sparse Matrix Optimizations** for efficiency.
- Expand **crawling capabilities** to handle JavaScript-heavy sites.
- Compare with **Google's original PageRank implementation**.

---

## Acknowledgments
This project is based on PageRank algorithms and Markov Chain modeling techniques inspired by Google's web ranking system.

---

