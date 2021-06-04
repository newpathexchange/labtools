## Usage
The AWS provider needs to be downloaded and installed on the first run, and any time the version changes.

    # Go to the directory where the code is stored
    cd code/aws/vpc
    # Initialize Terraform setup
    terraform init

Now the build and tear down can be repeated, as needed. (The “plan” and “show” commands are optional. Make sure all of the object in the VPC are cleaned up before issuing the “destroy”.)

    # Show what changes Terraform will make
    terraform plan
    # Apply the changes
    terraform apply
    # Show state information for the resources
    terraform show
    # Remove the resources
    terraform destroy
