package main

import (
	"context"
	"ec2-cron/src"
	"fmt"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
)

// INSTANCE_IDS="ins_id1,ins_id2,ins_id3"
var (
	INSTANCE_IDS = os.Getenv("INSTANCE_IDS")
)

func HandleRequest(ctx context.Context, e interface{}) (string, error) {

	instandIds, ctx := strings.Split(INSTANCE_IDS, ","), context.TODO()
	ec2 := src.NewEC2(ctx)
	ec2Map := ec2.Describe(instandIds)
	r := ec2.ExecuteEC2(ec2Map)

	fmt.Println(r)

	return "Hello world", nil
}

func main() {
	lambda.Start(HandleRequest)
}
