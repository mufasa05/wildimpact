import { Injectable, NotFoundException } from '@nestjs/common';
import { TenantContextService } from '../../common/tenant-context/tenant-context.service';

export interface CreateProjectDto {
  name: string;
  description: string;
  type: string;
  targetMetric: number;
  unit: string;
  latitude?: number;
  longitude?: number;
  imageUrl?: string;
}

export interface CreateMilestoneDto {
  title: string;
  description: string;
  metricDelta: number;
  evidenceUrl?: string;
  latitude?: number;
  longitude?: number;
  verifiedBy?: string;
}

@Injectable()
export class ConservationService {
  // In-memory tenant-scoped store (simulating Prisma DB with tenantId isolation)
  private projects: Map<string, any[]> = new Map([
    [
      'hwange-safari-lodge',
      [
        {
          id: 'proj-001',
          tenantId: 'hwange-safari-lodge',
          name: 'Sector 7 Anti-Poaching Patrol & Snare Sweep',
          description: 'Daily ranger patrols, snare sweeps, and wildlife corridor security in Hwange Buffer Zone.',
          type: 'ANTI_POACHING',
          targetMetric: 300,
          currentMetric: 245,
          unit: 'patrol hours',
          latitude: -18.7322,
          longitude: 26.9535,
          imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1200&q=80',
          milestones: [
            {
              id: 'm-1',
              title: 'Cleared 45km Sinamatella boundary',
              description: 'Zero illegal snares found; 2 elephant breeding herds sighted safely.',
              metricDelta: 40,
              latitude: -18.612,
              longitude: 26.341,
              verifiedBy: 'Chief Ranger Sibanda',
              createdAt: new Date(Date.now() - 86400000 * 2).toISOString(),
            },
            {
              id: 'm-2',
              title: 'Main Camp Night Surveillance completed',
              description: 'Thermal camera tracking and GPS patrol path logged.',
              metricDelta: 35,
              latitude: -18.734,
              longitude: 26.958,
              verifiedBy: 'Ranger Moyo',
              createdAt: new Date(Date.now() - 86400000).toISOString(),
            }
          ]
        },
        {
          id: 'proj-002',
          tenantId: 'hwange-safari-lodge',
          name: 'Dete Community Solar Borehole & Water Sanctuary',
          description: 'Deep solar pump supplying fresh drinking water to 400 households and reducing wildlife conflict at waterholes.',
          type: 'WATER_PROJECT',
          targetMetric: 50000,
          currentMetric: 38200,
          unit: 'liters/day',
          latitude: -18.6189,
          longitude: 26.8654,
          imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=80',
          milestones: [
            {
              id: 'm-3',
              title: 'Installed 12 high-capacity solar PV panels',
              description: 'Clean solar power active; water flow rate at 4,200 L/hr.',
              metricDelta: 15000,
              latitude: -18.618,
              longitude: 26.865,
              verifiedBy: 'Engineer Ndlovu',
              createdAt: new Date(Date.now() - 86400000 * 5).toISOString(),
            }
          ]
        },
        {
          id: 'proj-003',
          tenantId: 'hwange-safari-lodge',
          name: 'Gwayi Indigenous Forest Reforestation',
          description: 'Planting teak and acacia saplings in deforested buffer zones with local youth clubs.',
          type: 'REFORESTATION',
          targetMetric: 1000,
          currentMetric: 760,
          unit: 'trees planted',
          latitude: -18.892,
          longitude: 27.124,
          imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=1200&q=80',
          milestones: []
        }
      ]
    ]
  ]);

  findAll(tenantId: string) {
    return this.projects.get(tenantId) || [];
  }

  findOne(tenantId: string, id: string) {
    const list = this.findAll(tenantId);
    const proj = list.find((p) => p.id === id);
    if (!proj) throw new NotFoundException(`Project ${id} not found`);
    return proj;
  }

  create(tenantId: string, dto: CreateProjectDto) {
    const list = this.projects.get(tenantId) || [];
    const newProj = {
      id: `proj-${Date.now()}`,
      tenantId,
      ...dto,
      currentMetric: 0,
      milestones: [],
      createdAt: new Date().toISOString(),
    };
    list.push(newProj);
    this.projects.set(tenantId, list);
    return newProj;
  }

  addMilestone(tenantId: string, projectId: string, dto: CreateMilestoneDto) {
    const proj = this.findOne(tenantId, projectId);
    const newMilestone = {
      id: `m-${Date.now()}`,
      ...dto,
      createdAt: new Date().toISOString(),
    };
    proj.milestones.unshift(newMilestone);
    proj.currentMetric += dto.metricDelta;
    return newMilestone;
  }
}
