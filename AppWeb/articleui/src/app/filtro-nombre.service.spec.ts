import { TestBed } from '@angular/core/testing';

import { FiltroNombreService } from './filtro-nombre.service';

describe('FiltroNombreService', () => {
  let service: FiltroNombreService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(FiltroNombreService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
