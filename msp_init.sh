#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Change to the directory containing your Terraform files
cd /path/to/terraform

echo "Initializing Terraform..."
terraform init

echo "Applying Terraform..."
terraform apply -auto-approve

echo "Terraform apply complete!"

# Run your Python script
echo "Running Python script..."
python3 migrate.py

echo "Python script finished!"