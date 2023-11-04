package src

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_ContextEC2(t *testing.T) {
	ctx := context.TODO()
	e := NewEC2(ctx)

	assert.NotEqual(t, e, nil)
}

func Test_Describe_instanceId(t *testing.T) {
	ctx := context.TODO()
	e := NewEC2(ctx)

	m := e.DescribeUseTag("onoff-instance")

	assert.Equal(t, len(m), 3)
	assert.NotEqual(t, m, nil)

}
