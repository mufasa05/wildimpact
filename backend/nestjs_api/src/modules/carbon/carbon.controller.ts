import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { CarbonService, PurchaseOffsetDto } from './carbon.service';
import { CurrentTenant } from '../../common/decorators/current-tenant.decorator';
import { TenantGuard } from '../../common/guards/tenant.guard';

@Controller('carbon')
@UseGuards(TenantGuard)
export class CarbonController {
  constructor(private readonly carbonService: CarbonService) {}

  @Get('projects')
  findAll(@CurrentTenant() tenantId: string) {
    return this.carbonService.findAll(tenantId);
  }

  @Get('purchases')
  getPurchases(@CurrentTenant() tenantId: string) {
    return this.carbonService.getPurchases(tenantId);
  }

  @Post('purchase')
  purchase(@CurrentTenant() tenantId: string, @Body() dto: PurchaseOffsetDto) {
    return this.carbonService.purchase(tenantId, dto);
  }
}
