#!/bin/bash

# Get the first argument passed to the script (the command)
command=$1

# Shift all arguments down by one (removing the first argument)
shift

echo "Running $command"

# Perform the command specified by the first argument
case $command in
  # If the command is "train", run the train.py script with all remaining arguments

  train)
  {  
    julia --compiled-modules=no train_to_script.jl
    julia --compiled-modules=no train.jl
  }
    ;;

  # If the command is "predict", run the predict.py script with all remaining arguments
  predict)
  {

    julia --compiled-modules=no predict_to_script.jl
    julia --compiled-modules=no predict.jl
  }
    ;;


  # If the command is "standby", keep the container running without doing anything
  standby)
    tail -f /dev/null
    ;;

  # If an unknown command is passed, display an error message and exit with a non-zero status code
  *)
    echo "Invalid or missing command. Please specify one of the following commands:"
    echo "train: Train the model"
    echo "predict: Make batch predictions with the model"
    echo "standby: Run the container in standby mode to keep the container running without doing anything"
    exit 1
    ;;
esac