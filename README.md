# Julia Regression Template

This is a dockerized, Julia-based linear regression model. The purpose of this project is to provide a functional model that can be used as a template for building your own regression model.

The implementation contains a simple preprocessing pipeline which handles missing data and categorical features. The main prediction model is a linear regressor. You may replace the preprocessing logic, or the linear regression model, with your own custom logic. The model is implemented in Julia scripts for training and batch prediction tasks.

The model inputs and outputs follow the Ready Tensor specifications. You can read about the specifications here: https://docs.readytensor.ai/category/model-requirements

## Project Structure

The following is the directory structure of the project:

- **`model_inputs_outputs/`**: This directory contains files that are either inputs to, or outputs from, the model. When running the model locally (i.e. without using docker), this directory is used for model inputs and outputs. This directory is further divided into:
  - **`/inputs/`**: This directory contains all the input files for this project, including the `data` and `schema` files. The `data` is further divided into `testing` and `training` subsets.
  - **`/model/artifacts/`**: This directory is used to store the model artifacts, such as trained models and their parameters.
  - **`/outputs/`**: The outputs directory contains sub-directory for prediction results.
- **`src/`**: This directory holds the source code for the project. It is further divided into various subdirectories:

  - **`train.ipynb`**: This script is used to train the model. It loads the data, preprocesses it, trains the model, and saves the artifacts in the path `./model_inputs_outputs/model/artifacts/`.
  - **`predict.ipynb`**: This script is used to run batch predictions using the trained model. It loads the artifacts and creates and saves the predictions in a file called `predictions.csv` in the path `./model_inputs_outputs/outputs/predictions/`.
  - **`train_to_script.jl`**: This script is used to convert the `train.ipynb` script to julia script.
  - **`predict_to_script.jl`**: This script is used to convert the `predict.ipynb` script to julia script.

- **`.gitignore`**: This file specifies the files and folders that should be ignored by Git.
- **`Dockerfile`**: This file is used to build the Docker image for the application.
- **`entry_point.sh`**: This file is used as the entry point for the Docker container. It is used to run the application. When the container is run using one of the commands `train` or `predict`, this script runs the corresponding script in the `src` folder to execute the task.
- **`Project.toml`**-: This file contains information about the packages used in the project.
- **`LICENSE`**: This file contains the license for the project.
- **`README.md`**: This file (this particular document) contains the documentation for the project, explaining how to set it up and use it.

## Usage

In this section we cover the following:

- How to prepare your data for training
- How to run the model implementation locally (without Docker)
- How to run the model implementation with Docker

### Preparing your data

- If you plan to run this model implementation on your own regression dataset, you will need your training and testing data in a CSV format. Also, you will need to create a schema file as per the Ready Tensor specifications. The schema is in JSON format, and it's easy to create. You can use the example schema file provided in the `schema` directory as a template.

### To run locally (without Docker)

- Create your virtual environment and install dependencies listed in `Project.toml`.
- Run the script `src/train.ipynb` to train the linear regression model. This will save the model artifacts, including the preprocessing pipeline and label encoder, in the path `./model_inputs_outputs/model/artifacts/`.
- Run the script `src/predict.ipynb` to run batch predictions using the trained model. This script will load the artifacts and create and save the predictions in a file called `predictions.csv` in the path `./model_inputs_outputs/outputs/predictions/`.

### To run with Docker

1. Set up a bind mount on host machine: It needs to mirror the structure of the `model_inputs_outputs` directory. Place the train data file in the `model_inputs_outputs/inputs/data/training` directory, the test data file in the `model_inputs_outputs/inputs/data/testing` directory, and the schema file in the `model_inputs_outputs/inputs/schema` directory.
2. Build the image. You can use the following command: <br/>
   `docker build -t model_img .` <br/>
   Here `model_img` is the name given to the container (you can choose any name).
3. Note the following before running the container for train, batch prediction:
   - The train and batch predictions tasks require a bind mount to be mounted to the path `/opt/model_inputs_outputs/` inside the container. You can use the `-v` flag to specify the bind mount.
   - When you run the train or batch prediction tasks, the container will exit by itself after the task is complete.
   - When you run training task on the container, the container will save the trained model artifacts in the specified path in the bind mount. This persists the artifacts even after the container is stopped or killed.
   - When you run the batch prediction task, the container will load the trained model artifacts from the same location in the bind mount. If the artifacts are not present, the container will exit with an error.
   - Container runs as user 1000. Provide appropriate read-write permissions to user 1000 for the bind mount. Please follow the principle of least privilege when setting permissions. The following permissions are required:
     - Read access to the `inputs` directory in the bind mount. Write or execute access is not required.
     - Read-write access to the `outputs` directory and `model` directories. Execute access is not required.
4. To run batch predictions, place the prediction data file in the `model_inputs_outputs/inputs/data/testing` directory in the bind mount. Then issue the command: <br/>
   `docker run -v <path_to_mount_on_host>/model_inputs_outputs:/opt/model_inputs_outputs model_img predict` <br/>
   This will load the artifacts and create and save the predictions in a file called `predictions.csv` in the path `model_inputs_outputs/outputs/predictions/` in the bind mount.

## LICENSE

This project is provided under the MIT License. Please see the [LICENSE](LICENSE) file for more information.

## Contact Information

Repository created by Ready Tensor, Inc. (https://www.readytensor.ai/)
