package ibm

import (
	"github.com/infracost/infracost/internal/resources"
	"github.com/infracost/infracost/internal/schema"
	"github.com/shopspring/decimal"
	//"google.golang.org/appengine/log"
)

// Cloudant struct represents <TODO: cloud service short description>.
//
// <TODO: Add any important information about the resource and links to the
// pricing pages or documentation that might be useful to developers in the future, e.g:>
//
// Resource information: https://cloud.ibm.com/<PATH/TO/RESOURCE>/
// Pricing information: https://cloud.ibm.com/<PATH/TO/PRICING>/
type Cloudant struct {
	Address string
	Region  string
	Plan    string

	AdditionalConsumptionStorageGB *float64 `infracost_usage:"additional_consumption_storage_gb"`
}

// CloudantUsageSchema defines a list which represents the usage schema of Cloudant.
var CloudantUsageSchema = []*schema.UsageItem{
	{Key: "additional_backup_storage_gb", DefaultValue: 0, ValueType: schema.Float64},
}

// PopulateUsage parses the u schema.UsageData into the Cloudant.
// It uses the `infracost_usage` struct tags to populate data into the Cloudant.
func (r *Cloudant) PopulateUsage(u *schema.UsageData) {
	resources.PopulateArgsWithUsage(r, u)
}

func (r *Cloudant) BuildResource() *schema.Resource {
	costComponents := []*schema.CostComponent{
		r.readCapacityCostComponent(),
		r.writeCapacityCostComponent(),
		r.globalQueryCostComponent(),
		r.additionalCostComponent(),
	}

	return &schema.Resource{
		Name:           r.Address,
		UsageSchema:    CloudantUsageSchema,
		CostComponents: costComponents,
	}
}

func (r *Cloudant) readCapacityCostComponent() *schema.CostComponent {
	return &schema.CostComponent{
		Name:            "Read capacity (100 Reads/sec)",
		Unit:            "months",
		UnitMultiplier:  decimal.NewFromInt(1),
		MonthlyQuantity: decimalPtr(decimal.NewFromInt(1)),
		ProductFilter: &schema.ProductFilter{
			VendorName:       strPtr("ibm"),
			Region:           strPtr(r.Region),
			Service:          strPtr("Cloudant"),
			ProductFamily:    strPtr("Databases"),
			AttributeFilters: []*schema.AttributeFilter{},
		},
	}

}

func (r *Cloudant) writeCapacityCostComponent() *schema.CostComponent {
	return &schema.CostComponent{
		Name:            "Write capacity (50 writes/sec)",
		Unit:            "months",
		UnitMultiplier:  decimal.NewFromInt(1),
		MonthlyQuantity: decimalPtr(decimal.NewFromInt(1)),
		ProductFilter: &schema.ProductFilter{
			VendorName:       strPtr("ibm"),
			Region:           strPtr(r.Region),
			Service:          strPtr("Cloudant"),
			ProductFamily:    strPtr("Databases"),
			AttributeFilters: []*schema.AttributeFilter{},
		},
	}

}

func (r *Cloudant) globalQueryCostComponent() *schema.CostComponent {
	return &schema.CostComponent{
		Name:            "Global query capacity (5 global queries/sec)",
		Unit:            "months",
		UnitMultiplier:  decimal.NewFromInt(1),
		MonthlyQuantity: decimalPtr(decimal.NewFromInt(1)),
		ProductFilter: &schema.ProductFilter{
			VendorName:       strPtr("ibm"),
			Region:           strPtr(r.Region),
			Service:          strPtr("Cloudant"),
			ProductFamily:    strPtr("Databases"),
			AttributeFilters: []*schema.AttributeFilter{},
		},
	}

}

// additionalCostComponent returns a cost component for additional consumption-based charges per GB.
func (r *Cloudant) additionalCostComponent() *schema.CostComponent {
	var quantity *decimal.Decimal
	if r.AdditionalConsumptionStorageGB != nil {
		quantity = decimalPtr(decimal.NewFromFloat(*r.AdditionalConsumptionStorageGB))
	}

	return &schema.CostComponent{
		Name:            "Additional consumption-based charges",
		Unit:            "GB",
		UnitMultiplier:  decimal.NewFromInt(1),
		MonthlyQuantity: quantity,
		ProductFilter: &schema.ProductFilter{
			VendorName:       strPtr("ibm"),
			Region:           strPtr(r.Region),
			Service:          strPtr("Cloudant"),
			ProductFamily:    strPtr("Databases"),
			AttributeFilters: []*schema.AttributeFilter{},
		},
	}
}
