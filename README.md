# PostgreSQL Benchmarking Script

## Overview

This repository contains a benchmarking script designed to test and measure the performance of a PostgreSQL database server. The script runs various database operations, including creating tables, inserting data, and executing complex SQL queries to simulate different loads on the server.

## Features

- **Environment Setup**: Configures the PostgreSQL environment using Docker, ensuring consistent test conditions.
- **Data Generation**: Inserts synthetic GPS data and points of interest to facilitate complex queries.
- **Performance Testing**: Executes a series of SQL commands to test database read and write operations, including:
    - Insertions with `pgbench`.
    - Complex SQL queries involving geospatial calculations.
- **Timing**: Measures the execution time of each operation using nanosecond precision for accurate benchmarking results.

## Prerequisites

Before running the script, ensure that you have the following installed:
- Docker
- Docker Compose
- PostgreSQL client tools
- `bc` command-line calculator (for generating GPS coordinate data)

## Usage

To execute the benchmarking script, follow these steps:
1. Clone the repository to your local machine.
2. Navigate to the cloned directory.
3. Ensure that the `.env` file is configured with the correct database parameters.
4. Run the script using the following command:
   - `chmod +x go.sh`
   - './go.sh'

The script will output the timing results to `benchmark_results.txt`, which can be reviewed to understand the performance characteristics of the PostgreSQL server.

## Customization

You can modify the script to include additional SQL queries or to adjust the complexity and volume of data being processed. This allows you to tailor the benchmark to your specific testing needs or to replicate the typical workload of your production environment.

## Contributing

Contributions to enhance the benchmarking script are welcome. Please feel free to submit pull requests or create issues for any bugs or improvements you identify.

## License

Specify your license here or indicate if the repository is open source.

