import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { ConservationController } from './modules/conservation/conservation.controller';
import { ConservationService } from './modules/conservation/conservation.service';
import { CarbonController } from './modules/carbon/carbon.controller';
import { CarbonService } from './modules/carbon/carbon.service';
import { GeospatialController } from './modules/geospatial/geospatial.controller';
import { GeospatialService } from './modules/geospatial/geospatial.service';
import { TenantsService } from './modules/tenants/tenants.service';
import { ReportingService } from './modules/reporting/reporting.service';
import { TenantContextInterceptor } from './common/interceptors/tenant-context.interceptor';
import { TenantContextService } from './common/tenant-context/tenant-context.service';

@Module({
  imports: [],
  controllers: [
    ConservationController,
    CarbonController,
    GeospatialController,
  ],
  providers: [
    ConservationService,
    CarbonService,
    GeospatialService,
    TenantsService,
    ReportingService,
    TenantContextService,
    {
      provide: APP_INTERCEPTOR,
      useClass: TenantContextInterceptor,
    },
  ],
})
export class AppModule {}
