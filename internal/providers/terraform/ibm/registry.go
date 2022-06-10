package ibm

import "github.com/infracost/infracost/internal/schema"

var ResourceRegistry []*schema.RegistryItem = []*schema.RegistryItem{
	getIsVpcRegistryItem(),
	getCloudantRegistryItem(),
}

// FreeResources grouped alphabetically
var FreeResources = []string{
	"ibm_resource_group",
	"ibm_satellite_location",
}

var UsageOnlyResources = []string{
	"ibm_cloudant",
}
