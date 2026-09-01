import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { ConservationService, CreateProjectDto, CreateMilestoneDto } from './conservation.service';
import { CurrentTenant } from '../../common/decorators/current-tenant.decorator';
import { TenantGuard } from '../../common/guards/tenant.guard';

@Controller('conservation')
@UseGuards(TenantGuard)
export class ConservationController {
  constructor(private readonly conservationService: ConservationService) {}

  @Get('projects')
  findAll(@CurrentTenant() tenantId: string) {
    return this.conservationService.findAll(tenantId);
  }

  @Get('projects/:id')
  findOne(@CurrentTenant() tenantId: string, @Param('id') id: string) {
    return this.conservationService.findOne(tenantId, id);
  }

  @Post('projects')
  create(@CurrentTenant() tenantId: string, @Body() dto: CreateProjectDto) {
    return this.conservationService.create(tenantId, dto);
  }

  @Post('projects/:id/milestones')
  addMilestone(
    @CurrentTenant() tenantId: string,
    @Param('id') id: string,
    @Body() dto: CreateMilestoneDto,
  ) {
    return this.conservationService.addMilestone(tenantId, id, dto);
  }
}
