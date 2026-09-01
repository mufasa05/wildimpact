import { Injectable } from '@nestjs/common';

@Injectable()
export class GeospatialService {
  getPatrolCoordinates() {
    return {
      lodgeCenter: { lat: -18.7322, lng: 26.9535, name: 'Hwange Main Hub' },
      activeRangers: [
        { id: 'R-01', name: 'Ranger Sibanda', lat: -18.741, lng: 26.962, battery: 94, status: 'Active Patrol' },
        { id: 'R-02', name: 'Ranger Moyo', lat: -18.718, lng: 26.938, battery: 88, status: 'Snare Sweep' },
        { id: 'R-03', name: 'Ranger Chuma', lat: -18.765, lng: 26.971, battery: 76, status: 'Observation Post' }
      ],
      recentPatrolRoutes: [
        [
          [-18.7322, 26.9535],
          [-18.7380, 26.9590],
          [-18.7450, 26.9650],
          [-18.7520, 26.9700],
          [-18.7610, 26.9750]
        ]
      ],
      wildlifeSightings: [
        { type: 'Elephant Herd (28)', lat: -18.739, lng: 26.961, time: '35 mins ago', verified: true },
        { type: 'Lion Pride (4)', lat: -18.715, lng: 26.932, time: '1 hr ago', verified: true },
        { type: 'Wild Dog Pack (12)', lat: -18.758, lng: 26.968, time: '2 hrs ago', verified: true },
        { type: 'Black Rhino (Mother+Calf)', lat: -18.729, lng: 26.945, time: '4 hrs ago', verified: true }
      ],
      satelliteNdvi: {
        sensor: 'Sentinel-2 L2A',
        acquisitionDate: '2026-08-20',
        cloudCoverPct: 1.2,
        meanNdvi: 0.68,
        vegetationHealth: 'Vigorous / Optimal Canopy Moisture',
        deforestationAlerts: 0
      }
    };
  }
}
