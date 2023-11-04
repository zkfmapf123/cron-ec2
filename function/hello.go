package main

import (
	"context"
	"ec2-cron/src"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

// EC2 Instance.Properties
const TAG = "onoff-instance"

func HandleRequest(ctx context.Context, e interface{}) (string, error) {

	ec2 := src.NewEC2(ctx)
	ec2Map := ec2.DescribeUseTag(TAG)
	r := ec2.ExecuteEC2(ec2Map)

	fmt.Println(r)

	return "Hello world", nil
}

func main() {
	lambda.Start(HandleRequest)
}
