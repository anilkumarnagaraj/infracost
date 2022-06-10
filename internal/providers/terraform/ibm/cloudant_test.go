package ibm_test

import (
	"testing"

	"github.com/infracost/infracost/internal/providers/terraform/tftest"
)

func TestCloudant(t *testing.T) {
	//t.Parallel()
	if testing.Short() {
		t.Skip("skipping test in short mode")
	}
	//opts.CaptureLogs = true
	opts := tftest.DefaultGoldenFileOptions()
	opts.CaptureLogs = true
	tftest.GoldenFileResourceTestsWithOpts(t, "cloudant_test", opts)
	//tftest.GoldenFileResourceTests(t, "cloudant_test")
}
