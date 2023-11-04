package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest(ctx context.Context, e interface{}) (string, error) {
	fmt.Println("event ", e)
	return "Hello world", nil
}

func main() {
	lambda.Start(HandleRequest)
}
