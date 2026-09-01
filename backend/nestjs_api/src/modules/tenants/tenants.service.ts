import { Injectable } from '@nestjs/common';

@Injectable()
export class TenantsService {
  private tenants = [
    {
      id: 'hwange-safari-lodge',
      name: 'Hwange Safari Lodge',
      slug: 'hwange-safari',
      country: 'Zimbabwe',
      region: 'Matabeleland North / Hwange National Park',
      currency: 'USD',
      campfireSharePct: 20.0,
      totalPatrolHours: 1240,
      hectaresProtected: 48500,
      carbonOffsetFundedUsd: 18450,
      treesPlanted: 1420,
    },
    {
      id: 'vic-falls-river-lodge',
      name: 'Victoria Falls River Lodge',
      slug: 'vic-falls-river',
      country: 'Zimbabwe',
      region: 'Zambezi National Park',
      currency: 'USD',
      campfireSharePct: 20.0,
      totalPatrolHours: 820,
      hectaresProtected: 24000,
      carbonOffsetFundedUsd: 12100,
      treesPlanted: 890,
    },
    {
      id: 'mana-pools-camp',
      name: 'Mana Pools Wilderness Camp',
      slug: 'mana-pools-camp',
      country: 'Zimbabwe',
      region: 'Zambezi Valley UNESCO Heritage Area',
      currency: 'USD',
      campfireSharePct: 25.0,
      totalPatrolHours: 1450,
      hectaresProtected: 62000,
      carbonOffsetFundedUsd: 22800,
      treesPlanted: 2100,
    }
  ];

  findAll() {
    return this.tenants;
  }

  findOne(id: string) {
    return this.tenants.find((t) => t.id === id || t.slug === id) || this.tenants[0];
  }
}
