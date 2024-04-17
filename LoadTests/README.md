# Load Tests

The *LoadTests* folder contains the load tests for the mHealthAtlas system.

## Run Tests

Install [Appache JMeter](https://jmeter.apache.org/). Then execute the `setupLoadtest.sh` to clean the environment.
After the environment is clean execute `./apache-jmeter-5.4.1/bin/jmeter.sh -n -t "<path-to-testplan>/<testplan-name>.jmx" -l "<path-to-testplan-results>/<testplan-result>.jtl" -e -o "<path-to-testplan-report/<testplan-report-directory>"` command in the folder which contains the `jmeter.sh` script.

## *LoadTests* Folder Structure

The table below gives an overview of the subfolder structure of the *LoadTests* folder.

| Folder | Short Description |
| ----   |     ----          |
| [root directory](./) | contains the script to clean the load test environment, the load test plans and the load test results |
| [mHealthAtlas_Load0](mHealthAtlas_Load0/) | contains the load test reports for the first load test. (baseline test) |
| [mHealthAtlas_Load1](mHealthAtlas_Load1/) | contains the load test reports for the second load test. (load test) |
| [mHealthAtlas_Load2](mHealthAtlas_Load2/) | contains the load test reports for the third load test. (scalability test) |
