import { Injectable, NotFoundException } from '@nestjs/common';

export interface PurchaseOffsetDto {
  offsetProjectId: string;
  touristName: string;
  touristEmail: string;
  tonnes: number;
  paymentMethod: 'STRIPE' | 'PAYNOW_ECOCASH';
}

@Injectable()
export class CarbonService {
  private offsetProjects: Map<string, any[]> = new Map([
    [
      'hwange-safari-lodge',
      [
        {
          id: 'offset-001',
          tenantId: 'hwange-safari-lodge',
          name: 'Hwange Rural School Solar Microgrid',
          description: 'Deploying off-grid solar kits to eliminate diesel generators and power computer labs in Hwange primary schools.',
          pricePerTonne: 12.50,
          totalCapacity: 500.0,
          remainingCapacity: 342.5,
          registryId: 'ZCR-2026-SOLAR-089',
          zimbabweCampfirePct: 20.0, // 20% direct to CAMPFIRE rural council
          impactDescription: 'Each tonne powers 1 classroom for 6 months + funds local technician training.',
          imageUrl: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=1200&q=80',
        },
        {
          id: 'offset-002',
          tenantId: 'hwange-safari-lodge',
          name: 'Binga District Clean Biomass Cookstoves',
          description: 'Replacing open-fire cooking with high-efficiency rocket stoves, reducing wood consumption by 70% in Zambezi valley.',
          pricePerTonne: 10.00,
          totalCapacity: 800.0,
          remainingCapacity: 615.0,
          registryId: 'ZCR-2026-STOVE-104',
          zimbabweCampfirePct: 25.0,
          impactDescription: 'Saves 3.2 tonnes of indigenous firewood per household per year.',
          imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80',
        },
        {
          id: 'offset-003',
          tenantId: 'hwange-safari-lodge',
          name: 'Zambezi Wildlife Corridor Native Tree Planting',
          description: 'Restoring degraded teak corridors connecting Hwange to Victoria Falls National Parks.',
          pricePerTonne: 15.00,
          totalCapacity: 1200.0,
          remainingCapacity: 920.0,
          registryId: 'ZCR-2026-FOREST-044',
          zimbabweCampfirePct: 15.0,
          impactDescription: 'Direct community tree nursery employment for 35 women in Dete.',
          imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80',
        }
      ]
    ]
  ]);

  private purchases: any[] = [
    {
      id: 'purch-991',
      offsetProjectId: 'offset-001',
      touristName: 'Elena Rostova',
      touristEmail: 'elena.rostova@example.com',
      tonnes: 2.6,
      amountPaid: 32.50,
      campfireShare: 6.50,
      certificateCode: 'WI-HW-2026-98124',
      status: 'ISSUED',
      paymentMethod: 'STRIPE',
      projectName: 'Hwange Rural School Solar Microgrid',
      createdAt: new Date(Date.now() - 86400000 * 1).toISOString(),
    },
    {
      id: 'purch-992',
      offsetProjectId: 'offset-002',
      touristName: 'Marcus Lindqvist',
      touristEmail: 'marcus.l@example.se',
      tonnes: 4.1,
      amountPaid: 41.00,
      campfireShare: 10.25,
      certificateCode: 'WI-HW-2026-98125',
      status: 'ISSUED',
      paymentMethod: 'PAYNOW_ECOCASH',
      projectName: 'Binga District Clean Biomass Cookstoves',
      createdAt: new Date(Date.now() - 86400000 * 3).toISOString(),
    }
  ];

  findAll(tenantId: string) {
    return this.offsetProjects.get(tenantId) || [];
  }

  getPurchases(tenantId: string) {
    return this.purchases;
  }

  purchase(tenantId: string, dto: PurchaseOffsetDto) {
    const projects = this.findAll(tenantId);
    const proj = projects.find((p) => p.id === dto.offsetProjectId);
    if (!proj) throw new NotFoundException('Offset project not found');

    const amountPaid = Number((dto.tonnes * proj.pricePerTonne).toFixed(2));
    const campfireShare = Number((amountPaid * (proj.zimbabweCampfirePct / 100)).toFixed(2));
    const certCode = `WI-ZW-${Date.now().toString().slice(-6)}`;

    proj.remainingCapacity = Math.max(0, proj.remainingCapacity - dto.tonnes);

    const purchase = {
      id: `purch-${Date.now()}`,
      offsetProjectId: proj.id,
      projectName: proj.name,
      touristName: dto.touristName,
      touristEmail: dto.touristEmail,
      tonnes: dto.tonnes,
      amountPaid,
      campfireShare,
      certificateCode: certCode,
      status: 'ISSUED',
      paymentMethod: dto.paymentMethod,
      createdAt: new Date().toISOString(),
    };

    this.purchases.unshift(purchase);
    return purchase;
  }
}
