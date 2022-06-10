package ibm

import (
	"github.com/infracost/infracost/internal/resources"
	"github.com/infracost/infracost/internal/schema"
)

// IsVpc struct represents <TODO: cloud service short description>.
//
// <TODO: Add any important information about the resource and links to the
// pricing pages or documentation that might be useful to developers in the future, e.g:>
//
// Resource information: https://cloud.ibm.com/<PATH/TO/RESOURCE>/
// Pricing information: https://cloud.ibm.com/<PATH/TO/PRICING>/
type IsVpc struct {
	Address string
	Region  string
}

// IsVpcUsageSchema defines a list which represents the usage schema of IsVpc.
var IsVpcUsageSchema = []*schema.UsageItem{
}

// PopulateUsage parses the u schema.UsageData into the IsVpc.
// It uses the `infracost_usage` struct tags to populate data into the IsVpc.
func (r *IsVpc) PopulateUsage(u *schema.UsageData) {
	resources.PopulateArgsWithUsage(r, u)
}

// BuildResource builds a schema.Resource from a valid IsVpc struct.
// This method is called after the resource is initialised by an IaC provider.
// See providers folder for more information.
func (r *IsVpc) BuildResource() *schema.Resource {
	costComponents := []*schema.CostComponent{
		// TODO: add cost components
	}

	return &schema.Resource{
		Name:           r.Address,
		UsageSchema:    IsVpcUsageSchema,
		CostComponents: costComponents,
	}
}

