# Handling Cron-EC2

## Architecture

![archi](./public/archi.png)

## Folders

```
    infra
        |-- ec2.tf
        |-- event-bridge.tf
        |-- lambda.tf
    function
```

## Execution

1. .tfvars 작성 (./infra/tfvars.examples 참고)

```sh

    ## Provisioning
    cd infra
    tf init
    tf plan -var-file=[tfvars file]
    tf apply -var-file=[tfvars file]

    ## Lambda Function Update

    ## Test
```
