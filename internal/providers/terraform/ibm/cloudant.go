package ibm

import (
	"github.com/infracost/infracost/internal/resources/ibm"
	"github.com/infracost/infracost/internal/schema"
)

func getCloudantRegistryItem() *schema.RegistryItem {
	return &schema.RegistryItem{
		Name:  "ibm_cloudant",
		RFunc: newCloudant,
	}
}

func newCloudant(d *schema.ResourceData, u *schema.UsageData) *schema.Resource {
	r := &ibm.Cloudant{
		Address: d.Address,
		Region:  d.Get("location").String(),
		Plan:    d.Get("plan").String(),
	}

	if r.Plan == "lite" {
		return &schema.Resource{
			Name:      d.Address,
			NoPrice:   true,
			IsSkipped: true,
		}
	}

	r.PopulateUsage(u)

	return r.BuildResource()
}
