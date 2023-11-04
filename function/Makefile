clean:
	@rm -rf main && rm -rf function.zip

binary:
	@GOOS=linux GOARCH=amd64 go build -tags lambda.norpc -o hello hello.go

zip:
	@zip function.zip hello

upload:
	@aws lambda update-function-code --function-name ec2-handling-cron --zip-file fileb://function.zip

run:
	make clean && make binary && make zip && make upload