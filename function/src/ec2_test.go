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

	m := e.Describe([]string{"i-064c20bf00e2ea080", "i-0cd41a0dfaabc87f2", "i-0a9d27016484cdec2"})

	assert.Equal(t, len(m), 3)
	assert.NotEqual(t, m, nil)
}
