import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { TenantContextService } from '../tenant-context/tenant-context.service';

export const CurrentTenant = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): string | undefined => {
    return TenantContextService.getTenantId();
  },
);

export const CurrentUser = createParamDecorator(
  (data: string | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);
