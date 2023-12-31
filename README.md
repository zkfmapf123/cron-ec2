# Handling Cron-EC2

## Architecture

![archi](./public/archi.png)

## Desc

- 09:00, 18:00 까지만 동작하는 인스턴스 구조입니다.
- aws_scheduler_schedule 의 cron 기능을 사용합니다.
- EC2는 tag:Properties 가 "onoff-instance" 입니다.
- Lambda에서는 tag:Properties 가 "onoff-instance" 인 Instance를 검색합니다 (추후 환경변수로 수정가능...)
- Terraform + Lambda (Golang) 사용하여 구현합니다.

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
2. provider.tf를 수정하여야 합니다.
3. Terraform + Provisioning

```sh

    alias tf='terraform'

    ## Provisioning
    cd infra
    tf init
    tf plan -var-file=[tfvars file] OR Make plan
    tf apply -var-file=[tfvars file] OR Make apply

    ## Lambda Function Update
    cd function
    make run
```

## 혹시

- Lambda에서 Timeout이 난다면, Timeout 시간을 늘려줘야 합니다 (Default 3초)
- Slack 기능은 귀찮아서 그냥 안함
