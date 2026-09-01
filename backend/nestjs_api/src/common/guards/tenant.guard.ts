import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { TenantContextService } from '../tenant-context/tenant-context.service';

@Injectable()
export class TenantGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const tenantId = TenantContextService.getTenantId();
    if (!tenantId) {
      throw new ForbiddenException('Tenant context is missing or inaccessible');
    }
    return true;
  }
}
