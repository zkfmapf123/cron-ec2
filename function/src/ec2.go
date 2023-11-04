package src

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/ec2/types"
)

type AWSEC2 struct {
	ctx    context.Context
	client *ec2.Client
}

func NewEC2(ctx context.Context) *AWSEC2 {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		panic(err)
	}

	ec2Client := ec2.NewFromConfig(cfg)
	return &AWSEC2{
		ctx:    ctx,
		client: ec2Client,
	}
}

func (e AWSEC2) DescribeUseTag(tag string) map[string]string {
	descMap := make(map[string]string)

	input := &ec2.DescribeInstancesInput{
		Filters: []types.Filter{
			{
				Name:   aws.String("tag:Properties"),
				Values: []string{tag},
			},
		},
	}

	output, err := e.client.DescribeInstances(e.ctx, input)
	if err != nil {
		panic(err)
	}

	for _, reserv := range output.Reservations {
		for _, ins := range reserv.Instances {
			id, status := *ins.InstanceId, ins.State.Name
			descMap[id] = string(status)
		}

	}

	return descMap
}

// ok,
func (e AWSEC2) ExecuteEC2(ec2Map map[string]string) map[string]string {

	for instanceId, status := range ec2Map {
		if status == "running" {
			errMsg := offToEC2(e, instanceId)

			if errMsg != "" {
				ec2Map[instanceId] = errMsg
			} else {
				ec2Map[instanceId] = "stopped"
			}
			continue
		}

		errMsg := onToEc2(e, instanceId)
		if errMsg != "" {
			ec2Map[instanceId] = errMsg
		} else {
			ec2Map[instanceId] = "running"
		}
	}

	return ec2Map
}

func onToEc2(awsEC2 AWSEC2, instanceId string) string {
	runInstance := &ec2.StartInstancesInput{
		InstanceIds: []string{instanceId},
	}

	_, err := awsEC2.client.StartInstances(awsEC2.ctx, runInstance)
	if err != nil {
		return err.Error()
	}

	return ""
}

func offToEC2(awsEC2 AWSEC2, instanceId string) string {
	stopInstance := &ec2.StopInstancesInput{
		InstanceIds: []string{instanceId},
	}

	_, err := awsEC2.client.StopInstances(awsEC2.ctx, stopInstance)
	if err != nil {
		return err.Error()
	}

	return ""
}
