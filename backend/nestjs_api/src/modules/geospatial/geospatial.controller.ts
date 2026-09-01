import { Controller, Get, UseGuards } from '@nestjs/common';
import { GeospatialService } from './geospatial.service';
import { TenantGuard } from '../../common/guards/tenant.guard';

@Controller('geospatial')
@UseGuards(TenantGuard)
export class GeospatialController {
  constructor(private readonly geospatialService: GeospatialService) {}

  @Get('telemetry')
  getTelemetry() {
    return this.geospatialService.getPatrolCoordinates();
  }
}
