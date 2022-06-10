package ibm

import (
	"github.com/infracost/infracost/internal/resources/ibm"
	"github.com/infracost/infracost/internal/schema"
)

func getIsVpcRegistryItem() *schema.RegistryItem {
	return &schema.RegistryItem{
		Name:  "ibm_is_vpc",
		RFunc: newIsVpc,
	}
}

func newIsVpc(d *schema.ResourceData, u *schema.UsageData) *schema.Resource {
	region := d.Get("region").String()
	r := &ibm.IsVpc{
		Address: d.Address,
		Region:  region,
	}
	r.PopulateUsage(u)

	return r.BuildResource()
}
