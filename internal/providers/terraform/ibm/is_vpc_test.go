package ibm_test

import (
	"testing"

	"github.com/infracost/infracost/internal/providers/terraform/tftest"
)

func TestIsVpc(t *testing.T) {
	t.Parallel()
	if testing.Short() {
		t.Skip("skipping test in short mode")
	}

	tftest.GoldenFileResourceTests(t, "is_vpc_test")
}
