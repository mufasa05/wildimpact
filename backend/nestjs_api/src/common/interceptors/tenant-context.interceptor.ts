import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { TenantContextService } from '../tenant-context/tenant-context.service';

@Injectable()
export class TenantContextInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const tenantId =
      request.headers['x-tenant-id'] ||
      request.user?.activeTenantId ||
      request.query?.tenantId ||
      'default-hwange-lodge';

    return new Observable((subscriber) => {
      TenantContextService.run(
        {
          tenantId,
          userId: request.user?.id,
          role: request.user?.role,
        },
        () => {
          next.handle().subscribe(subscriber);
        },
      );
    });
  }
}
